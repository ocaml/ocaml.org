let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let to_bool s =
  match String.lowercase_ascii s with "true" | "1" -> true | _ -> false

let debug = to_bool @@ env_with_default "OCAMLORG_DEBUG" "true"

let port = env_with_default "PORT" "8080" |> int_of_string

let secret_key =
  env_with_default
    "OCAMLORG_SECRET_KEY"
    "6qWiqeLJqZC/UrpcTLIcWOS/35SrCPzWskO/bDkIXBGH9fCXrDphsBj4afqigTKe"

let github_oauth_token =
  match Sys.getenv_opt "GITHUB_TOKEN" with 
    | Some token -> token 
    | None -> 
        match Bos.OS.File.read (Fpath.v ".token") with 
          | Ok token -> token 
          | Error (`Msg m) -> Fmt.failwith "No Github OAuth token found in the environment or from the filesystem (%s)" m
