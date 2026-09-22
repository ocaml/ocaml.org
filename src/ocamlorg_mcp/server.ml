(* Transport-agnostic MCP dispatch: given a raw JSON-RPC request body, produce
   the response body, or [None] for a notification (which takes no reply). *)

let server_info =
  `Assoc [ ("name", `String "ocaml.org"); ("version", `String "0.1.0") ]

(* We only advertise the tools capability for now. *)
let capabilities = `Assoc [ ("tools", `Assoc [ ("listChanged", `Bool false) ]) ]

(* Build the [tools/call] result payload (the [content]/[isError] object, sans
   the per-request JSON-RPC [id], so it is safe to cache across requests). The
   handler is [Lwt]-returning (Block B's docs tools fetch asynchronously). *)
let call_result (tool : Tool.t) arguments : Yojson.Safe.t Lwt.t =
  let open Lwt.Syntax in
  let+ result = tool.handler arguments in
  match result with
  | Ok content ->
      `Assoc [ ("content", `List content); ("isError", `Bool false) ]
  | Error msg ->
      (* Tool errors are reported in-band, not as JSON-RPC errors. *)
      `Assoc
        [
          ("content", `List [ Tool.text_content msg ]); ("isError", `Bool true);
        ]

(* [true] iff a tools/call result object is an in-band error, which we must not
   cache (a docs-ci fetch may fail transiently). *)
let is_error_result = function
  | `Assoc fields -> (
      match List.assoc_opt "isError" fields with
      | Some (`Bool b) -> b
      | _ -> false)
  | _ -> false

let dispatch ?cache ?(tools = []) (req : Protocol.request) (id : Protocol.id) :
    Yojson.Safe.t Lwt.t =
  (* The effective registry is [ping] plus any tools injected by the web layer
     (Block A onward). [ping] stays first and is always present, so the isolated
     library keeps a working handshake even with no tools injected. *)
  let registry = Tool.ping :: tools in
  match req.method_ with
  | "initialize" ->
      let result =
        `Assoc
          [
            ("protocolVersion", `String Protocol.latest_protocol_version);
            ("capabilities", capabilities);
            ("serverInfo", server_info);
          ]
      in
      Lwt.return (Protocol.ok_response id result)
  | "ping" ->
      (* JSON-RPC-level ping (distinct from the "ping" tool): empty result. *)
      Lwt.return (Protocol.ok_response id (`Assoc []))
  | "tools/list" ->
      let tools = List.map Tool.to_json registry in
      Lwt.return (Protocol.ok_response id (`Assoc [ ("tools", `List tools) ]))
  | "tools/call" -> (
      match Protocol.member_opt "name" req.params with
      | Some (`String name) -> (
          match List.find_opt (fun (t : Tool.t) -> t.name = name) registry with
          | None ->
              Lwt.return
                (Protocol.error_response id ~code:Protocol.invalid_params
                   ~message:("unknown tool: " ^ name))
          | Some tool ->
              let open Lwt.Syntax in
              let arguments =
                Option.value ~default:(`Assoc [])
                  (Protocol.member_opt "arguments" req.params)
              in
              let+ result =
                match (cache, tool.cacheable) with
                | Some cache, true -> (
                    let now = Unix.gettimeofday () in
                    let key =
                      "tools/call:" ^ tool.name ^ ":"
                      ^ Yojson.Safe.to_string arguments
                    in
                    match Cache.find cache ~now ~key with
                    | Some value -> Lwt.return value
                    | None ->
                        let+ value = call_result tool arguments in
                        (* Cache only successful results; a transient docs-ci
                           failure must not be pinned for the whole TTL. *)
                        if not (is_error_result value) then
                          Cache.store cache ~now ~key value;
                        value)
                | _ -> call_result tool arguments
              in
              Protocol.ok_response id result)
      | _ ->
          Lwt.return
            (Protocol.error_response id ~code:Protocol.invalid_params
               ~message:"missing tool name"))
  | m ->
      Lwt.return
        (Protocol.error_response id ~code:Protocol.method_not_found
           ~message:("unknown method: " ^ m))

let handle ?cache ?(tools = []) (body : string) : string option Lwt.t =
  let error_json id ~code ~message =
    Lwt.return
      (Some (Yojson.Safe.to_string (Protocol.error_response id ~code ~message)))
  in
  match Yojson.Safe.from_string body with
  | exception _ ->
      error_json `Null ~code:Protocol.parse_error ~message:"invalid JSON"
  | json -> (
      match Protocol.parse_request json with
      | Error message ->
          error_json `Null ~code:Protocol.invalid_request ~message
      | Ok req -> (
          match req.id with
          | None ->
              (* notification: process side effects (none yet), no reply *)
              Lwt.return None
          | Some id ->
              let open Lwt.Syntax in
              let+ response = dispatch ?cache ~tools req id in
              Some (Yojson.Safe.to_string response)))
