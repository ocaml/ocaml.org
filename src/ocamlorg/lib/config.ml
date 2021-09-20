let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let opam_polling =
  env_with_default "OCAMLORG_OPAM_POLLING" "300" |> int_of_string

let documentation_url =
  Sys.getenv_opt "OCAMLORG_DOC_URL"
  |> Option.value ~default:"https://docs-data.ocaml.org/live/"

let opam_repository_path =
  Sys.getenv_opt "OCAMLORG_REPO_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(v "_var" / "opam-repository")
