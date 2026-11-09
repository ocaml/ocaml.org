let default_cache_dir =
  match Sys.os_type with
  | "Unix" -> Fpath.(v (Sys.getenv "HOME") / ".cache" / "ocamlorg")
  | _ -> Fpath.(v (Sys.getenv "APPDATA") / "ocamlorg" / "cache")

let opam_repository =
  Sys.getenv_opt "OCAMLORG_REPO_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(default_cache_dir / "opam-repository")

let package_state =
  Sys.getenv_opt "OCAMLORG_PKG_STATE_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(default_cache_dir / "package.state")

(* The doc-modules index (#3982), next to the package state by default: the
   builder downloads it there and the server maps it. *)
let doc_modules =
  Sys.getenv_opt "OCAMLORG_DOC_MODULES_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(parent package_state / "doc-modules.idx")
