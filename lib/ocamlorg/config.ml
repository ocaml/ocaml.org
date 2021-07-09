let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let graphql_api =
  env_with_default "OCAMLORG_GRAPHQL_API" "http://localhost:8081/"
  |> Uri.of_string

let opam_polling =
  env_with_default "OCAMLORG_OPAM_POLLING" "30" |> int_of_string
