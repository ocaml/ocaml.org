(* Streamable HTTP transport for MCP over Dream (JSON-RPC 2.0 over HTTP
   POST). *)

val routes :
  ?tools:Tool.t list ->
  ?trust_xff:bool ->
  rate_limit:int ->
  rate_window:int ->
  cache_max:int ->
  cache_max_bytes:int ->
  cache_ttl:int ->
  max_body:int ->
  unit ->
  Dream.route list
(** The [/mcp] routes (a POST handling JSON-RPC, a GET declining with 405),
    wrapped in a per-IP rate-limit middleware and sharing an in-app response
    cache. [tools] are injected by the web layer; [trust_xff], the rate-limit,
    cache, and body-size parameters come from the server config. *)
