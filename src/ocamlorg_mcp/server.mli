(* Transport-agnostic MCP dispatch. *)

val handle :
  ?cache:Cache.t -> ?tools:Tool.t list -> string -> string option Lwt.t
(** [handle ?cache ?tools body] handles one raw JSON-RPC request body, returning
    the response body, or [None] for a notification (which takes no reply).
    [tools] are the tools injected by the web layer (none by default); [cache]
    memoises deterministic [tools/call] results. *)
