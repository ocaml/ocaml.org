let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let to_bool s =
  match String.lowercase_ascii s with "true" | "1" -> true | _ -> false

let http_port = env_with_default "OCAMLORG_HTTP_PORT" "8080" |> int_of_string

let manual_path =
  env_with_default "OCAMLORG_MANUAL_PATH" "html-compiler-manuals"

let v2_path = env_with_default "OCAMLORG_V2_PATH" "data/v2"

(* MCP server endpoint (issue #3775). Off by default while it stabilises. *)
let mcp_enabled = env_with_default "OCAMLORG_MCP_ENABLED" "false" |> to_bool

(* Per-IP rate limit on the /mcp route: [mcp_rate_limit] requests per
   [mcp_rate_window] seconds. Public no-auth endpoint, so this bounds agent
   fan-out on the shared service.

   The default is deliberately generous because web connectors (claude.ai,
   ChatGPT, ...) reach the endpoint from a small pool of vendor egress IPs, so
   many unrelated users share one IP-keyed bucket (issue #3812). With no auth
   there is no per-user key downstream of the connector, so the only lever is a
   larger shared bucket; abuse is backstopped by the planned edge limiter. *)
let mcp_rate_limit =
  env_with_default "OCAMLORG_MCP_RATE_LIMIT" "300" |> int_of_string

let mcp_rate_window =
  env_with_default "OCAMLORG_MCP_RATE_WINDOW" "60" |> int_of_string

(* Trust [X-Forwarded-For] for the rate-limit bucket key. Off by default: the
   header is client-spoofable, so honouring it lets a client bypass the limiter
   by varying the value per request. Enable only when the app sits behind an
   edge proxy that sets or sanitises [X-Forwarded-For]; the limiter then keys on
   the rightmost (proxy-appended) entry. *)
let mcp_trust_xff = env_with_default "OCAMLORG_MCP_TRUST_XFF" "false" |> to_bool

(* In-app response cache for /mcp (POST bypasses the edge Varnish): at most
   [mcp_cache_max] entries totalling at most [mcp_cache_max_bytes] bytes, each
   valid for [mcp_cache_ttl] seconds. The byte budget matters because response
   size is client-selectable (a cached module-documentation result can be ~130
   KB), so the entry cap alone admits a deliberately fillable ~135 MB worst case
   (issue #3889). Default: 32 MB. *)
let mcp_cache_ttl =
  env_with_default "OCAMLORG_MCP_CACHE_TTL" "300" |> int_of_string

let mcp_cache_max =
  env_with_default "OCAMLORG_MCP_CACHE_MAX" "1024" |> int_of_string

let mcp_cache_max_bytes =
  env_with_default "OCAMLORG_MCP_CACHE_MAX_BYTES" "33554432" |> int_of_string

(* Max accepted /mcp request-body size in bytes; larger bodies get 413 (issue
   #3884). A JSON-RPC request is small, so 1 MB is generous. *)
let mcp_max_body =
  env_with_default "OCAMLORG_MCP_MAX_BODY" "1048576" |> int_of_string
