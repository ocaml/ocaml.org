(* Transport-agnostic MCP dispatch: given a raw JSON-RPC request body, produce
   the response body, or [None] for a notification (which takes no reply). *)

let server_info =
  `Assoc [ ("name", `String "ocaml.org"); ("version", `String "0.1.0") ]

(* We only advertise the tools capability for now. *)
let capabilities = `Assoc [ ("tools", `Assoc [ ("listChanged", `Bool false) ]) ]

let dispatch (req : Protocol.request) (id : Protocol.id) : Yojson.Safe.t =
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
      Protocol.ok_response id result
  | "ping" ->
      (* JSON-RPC-level ping (distinct from the "ping" tool): empty result. *)
      Protocol.ok_response id (`Assoc [])
  | "tools/list" ->
      let tools = List.map Tool.to_json Tool.registry in
      Protocol.ok_response id (`Assoc [ ("tools", `List tools) ])
  | "tools/call" -> (
      match Protocol.member_opt "name" req.params with
      | Some (`String name) -> (
          match Tool.find name with
          | None ->
              Protocol.error_response id ~code:Protocol.invalid_params
                ~message:("unknown tool: " ^ name)
          | Some tool -> (
              let arguments =
                Option.value ~default:(`Assoc [])
                  (Protocol.member_opt "arguments" req.params)
              in
              match tool.handler arguments with
              | Ok content ->
                  Protocol.ok_response id
                    (`Assoc
                      [ ("content", `List content); ("isError", `Bool false) ])
              | Error msg ->
                  (* Tool errors are reported in-band, not as JSON-RPC
                     errors. *)
                  Protocol.ok_response id
                    (`Assoc
                      [
                        ("content", `List [ Tool.text_content msg ]);
                        ("isError", `Bool true);
                      ])))
      | _ ->
          Protocol.error_response id ~code:Protocol.invalid_params
            ~message:"missing tool name")
  | m ->
      Protocol.error_response id ~code:Protocol.method_not_found
        ~message:("unknown method: " ^ m)

let handle (body : string) : string option =
  let error_json id ~code ~message =
    Some (Yojson.Safe.to_string (Protocol.error_response id ~code ~message))
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
              None (* notification: process side effects (none yet), no reply *)
          | Some id -> Some (Yojson.Safe.to_string (dispatch req id))))
