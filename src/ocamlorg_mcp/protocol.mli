(* Minimal JSON-RPC 2.0 + Model Context Protocol helpers, reimplemented for
   ocaml.org (issue #3775), depending only on yojson. The type shapes follow the
   MCP spec, revision 2025-06-18. *)

val latest_protocol_version : string
(** The newest protocol revision this server speaks. *)

val supported_protocol_versions : string list
(** Protocol revisions this server can speak, newest first. *)

val is_supported_protocol_version : string -> bool
(** [true] iff the given revision is one we can speak. *)

type id = [ `Int of int | `String of string | `Null ]
(** A JSON-RPC id is an integer or a string; [`Null] is used for responses to
    requests we could not associate with an id. *)

val id_of_json : Yojson.Safe.t -> id
val json_of_id : id -> Yojson.Safe.t

(** JSON-RPC 2.0 standard error codes. *)

val parse_error : int
val invalid_request : int
val method_not_found : int
val invalid_params : int

type request = {
  id : id option;  (** [None] for notifications, which take no reply. *)
  method_ : string;
  params : Yojson.Safe.t;  (** [`Null] when absent. *)
}

val member_opt : string -> Yojson.Safe.t -> Yojson.Safe.t option
(** [member_opt key json] is the value of [key] in a JSON object, or [None]. *)

val parse_request : Yojson.Safe.t -> (request, string) result
(** Parse a JSON-RPC request object, or describe why it is malformed. *)

val ok_response : id -> Yojson.Safe.t -> Yojson.Safe.t
(** A successful JSON-RPC response carrying [result]. *)

val error_response : id -> code:int -> message:string -> Yojson.Safe.t
(** A JSON-RPC error response. *)
