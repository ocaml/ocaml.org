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
   fan-out on the shared service. *)
let mcp_rate_limit =
  env_with_default "OCAMLORG_MCP_RATE_LIMIT" "60" |> int_of_string

let mcp_rate_window =
  env_with_default "OCAMLORG_MCP_RATE_WINDOW" "60" |> int_of_string

(* In-app response cache for /mcp (POST bypasses the edge Varnish): at most
   [mcp_cache_max] entries, each valid for [mcp_cache_ttl] seconds. *)
let mcp_cache_ttl =
  env_with_default "OCAMLORG_MCP_CACHE_TTL" "300" |> int_of_string

let mcp_cache_max =
  env_with_default "OCAMLORG_MCP_CACHE_MAX" "1024" |> int_of_string
