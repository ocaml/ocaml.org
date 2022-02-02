let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let to_bool s =
  match String.lowercase_ascii s with "true" | "1" -> true | _ -> false

let debug = to_bool @@ env_with_default "OCAMLORG_DEBUG" "true"
let hostname = env_with_default "OCAMLORG_HOSTNAME" "localhost"
let http_port = env_with_default "OCAMLORG_HTTP_PORT" "8080" |> int_of_string
let https_port = env_with_default "OCAMLORG_HTTPS_PORT" "8081" |> int_of_string
let https_enabled = env_with_default "OCAMLORG_HTTPS_ENABLED" "false" |> to_bool

let letsencrypt_staging =
  env_with_default "OCAMLORG_LETSENCRYPT_STAGING" "true" |> to_bool

let certificate_file_path =
  env_with_default "OCAMLORG_CERTIFICATE_PATH" "v3.ocaml.org.pem"

let private_key_file_path =
  env_with_default "OCAMLORG_PRIVATE_KEY_PATH" "v3.ocaml.org.key"

let secret_key =
  env_with_default "OCAMLORG_SECRET_KEY"
    "6qWiqeLJqZC/UrpcTLIcWOS/35SrCPzWskO/bDkIXBGH9fCXrDphsBj4afqigTKe"

let meta_description =
  "OCaml is a general purpose industrial-strength programming language with an \
   emphasis on expressiveness and safety."
