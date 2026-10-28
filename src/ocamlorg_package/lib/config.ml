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

(* Short time-to-live (in seconds) for negatively cached docs-ci outcomes:
   missing/empty sidebars and missing/unparseable doc pages. Long enough to
   absorb a retry storm from retry-happy agents hitting /mcp, short enough not
   to mask a documentation rebuild. See ocaml/ocaml.org#3888. Default: 60 s. *)
let doc_negative_ttl =
  env_with_default "OCAMLORG_DOC_NEGATIVE_TTL" "60" |> float_of_string

(* Upper bound on how many versions [latest_documented_version] probes, newest
   first, before giving up. On a cold cache each probe is one sequential
   status.json GET against the docs backend, so an old package with many
   undocumented versions would otherwise cost 100+ upstream fetches per call
   (the MCP docs tools invoke this for every request without an explicit
   version). Capping the walk bounds that fan-out. See ocaml/ocaml.org#3888. *)
let latest_documented_version_depth =
  env_with_default "OCAMLORG_LATEST_DOC_VERSION_DEPTH" "25" |> int_of_string

(* Upper bound on the size (in bytes) of a single response fetched from the
   documentation backend. Prevents a pathologically large artifact (e.g. a
   multi-hundred-MB odoc search index) from being buffered into memory and
   OOM-killing the server. See ocaml/ocaml.org#3765. Default: 50 MB. *)
let max_doc_fetch_bytes =
  env_with_default "OCAMLORG_MAX_DOC_FETCH_BYTES" "52428800" |> int_of_string

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
