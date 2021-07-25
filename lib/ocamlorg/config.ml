let documentation_path =
  Sys.getenv_opt "OCAMLORG_DOC_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(v "var" / "occurent-output")

let opam_repository_path =
  Sys.getenv_opt "OCAMLORG_REPO_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(v "var" / "opam-repository")
