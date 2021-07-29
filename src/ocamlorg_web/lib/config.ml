let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let to_bool s =
  match String.lowercase_ascii s with "true" | "1" -> true | _ -> false

let debug = to_bool @@ env_with_default "OCAMLORG_DEBUG" "true"

let port = env_with_default "PORT" "8080" |> int_of_string

let secret_key =
  env_with_default
    "OCAMLORG_SECRET_KEY"
    "6qWiqeLJqZC/UrpcTLIcWOS/35SrCPzWskO/bDkIXBGH9fCXrDphsBj4afqigTKe"

let meta_description =
  "OCaml is a general purpose industrial-strength programming language with an \
   emphasis on expressiveness and safety."
