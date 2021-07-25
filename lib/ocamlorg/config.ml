let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let opam_polling =
  env_with_default "OCAMLORG_OPAM_POLLING" "60" |> int_of_string

let documentation_path =
  Sys.getenv_opt "OCAMLORG_DOC_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(v "var" / "occurent-output")

let opam_repository_path =
  Sys.getenv_opt "OCAMLORG_REPO_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(v "var" / "opam-repository")

let github_oauth_token =
  match Sys.getenv_opt "OCAMLORG_GITHUB_TOKEN" with
  | Some token ->
    token
  | None ->
    (match Bos.OS.File.read (Fpath.v ".token") with
    | Ok token ->
      token
    | Error (`Msg m) ->
      Fmt.failwith
        "No Github OAuth token found in the environment or from the filesystem \
         (%s)"
        m)
