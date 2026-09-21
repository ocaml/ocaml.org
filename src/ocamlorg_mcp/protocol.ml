(* Minimal JSON-RPC 2.0 + Model Context Protocol helpers, reimplemented for
   ocaml.org (issue #3775). We depend only on yojson so the endpoint carries no
   extra opam dependency. The type shapes follow the MCP spec, revision
   2025-06-18: https://modelcontextprotocol.io/specification/2025-06-18 *)

let latest_protocol_version = "2025-06-18"

(* A JSON-RPC id is an integer or a string; [`Null] is used for responses to
   requests we could not associate with an id (parse/invalid-request errors). *)
type id = [ `Int of int | `String of string | `Null ]

let id_of_json : Yojson.Safe.t -> id = function
  | `Int i -> `Int i
  | `String s -> `String s
  | _ -> `Null

let json_of_id : id -> Yojson.Safe.t = function
  | `Int i -> `Int i
  | `String s -> `String s
  | `Null -> `Null

(* JSON-RPC 2.0 standard error codes. *)
let parse_error = -32700
let invalid_request = -32600
let method_not_found = -32601
let invalid_params = -32602

type request = {
  id : id option; (* [None] for notifications, which take no reply *)
  method_ : string;
  params : Yojson.Safe.t; (* [`Null] when absent *)
}

let member_opt key : Yojson.Safe.t -> Yojson.Safe.t option = function
  | `Assoc l -> List.assoc_opt key l
  | _ -> None

let parse_request (json : Yojson.Safe.t) : (request, string) result =
  match json with
  | `Assoc _ -> (
      match member_opt "method" json with
      | Some (`String method_) ->
          let id =
            match member_opt "id" json with
            | None | Some `Null -> None
            | Some j -> Some (id_of_json j)
          in
          let params = Option.value ~default:`Null (member_opt "params" json) in
          Ok { id; method_; params }
      | _ -> Error "missing or non-string \"method\"")
  | _ -> Error "request is not a JSON object"

let ok_response (id : id) (result : Yojson.Safe.t) : Yojson.Safe.t =
  `Assoc
    [ ("jsonrpc", `String "2.0"); ("id", json_of_id id); ("result", result) ]

let error_response (id : id) ~code ~message : Yojson.Safe.t =
  `Assoc
    [
      ("jsonrpc", `String "2.0");
      ("id", json_of_id id);
      ("error", `Assoc [ ("code", `Int code); ("message", `String message) ]);
    ]
