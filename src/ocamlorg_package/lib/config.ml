let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let opam_polling =
  env_with_default "OCAMLORG_OPAM_POLLING" "3600" |> int_of_string

let documentation_url =
  Sys.getenv_opt "OCAMLORG_DOC_URL"
  |> Option.value ~default:"https://dill.caelum.ci.dev/profiles/full/docs/"

let documentation_status_url =
  Sys.getenv_opt "OCAMLORG_DOC_STATUS_URL"
  |> Option.value ~default:"https://dill.caelum.ci.dev/profiles/full/"

let package_caches_ttl =
  env_with_default "OCAMLORG_PACKAGE_CACHES_TTL" "3600" |> float_of_string

(* Maximum number of entries in each of the bounded docs-ci caches (sidebars and
   rendered doc pages). Bounds memory under a wide spread of packages/versions;
   entries expire after [package_caches_ttl]. *)
let doc_cache_max =
  env_with_default "OCAMLORG_DOC_CACHE_MAX" "1000" |> int_of_string

(* Upper bound on the size (in bytes) of a single response fetched from the
   documentation backend. Prevents a pathologically large artifact (e.g. a
   multi-hundred-MB odoc search index) from being buffered into memory and
   OOM-killing the server. See ocaml/ocaml.org#3765. Default: 50 MB. *)
let max_doc_fetch_bytes =
  env_with_default "OCAMLORG_MAX_DOC_FETCH_BYTES" "52428800" |> int_of_string

(* Wall-clock budget (in seconds) for a single fetch from the documentation
   backend (connect + response + body streaming). cohttp-lwt-unix applies no
   timeout of its own, so a backend that accepts the connection and then stalls
   would pin the request's socket and buffers for the life of the process (the
   same fd-exhaustion class as ocaml/ocaml.org#3765, reached through a hung
   rather than an over-large response). See ocaml/ocaml.org#3887. Default:
   30s. *)
let doc_fetch_timeout =
  env_with_default "OCAMLORG_DOC_FETCH_TIMEOUT" "30" |> float_of_string

let default_cache_dir =
  match Sys.os_type with
  | "Unix" -> Fpath.(v (Sys.getenv "HOME") / ".cache" / "ocamlorg")
  | _ -> Fpath.(v (Sys.getenv "APPDATA") / "ocamlorg" / "cache")

let opam_repository_path =
  Sys.getenv_opt "OCAMLORG_REPO_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(default_cache_dir / "opam-repository")

let package_state_path =
  Sys.getenv_opt "OCAMLORG_PKG_STATE_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(default_cache_dir / "package.state")
