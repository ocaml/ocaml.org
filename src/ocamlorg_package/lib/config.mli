(** Configurations used in the ocaml.org backend. *)

val opam_polling : int
val documentation_url : string
val documentation_status_url : string
val package_caches_ttl : float

val max_doc_fetch_bytes : int
(** Upper bound (bytes) on a single response fetched from the documentation
    backend, to avoid buffering a pathologically large artifact into memory.
    Overridable via [OCAMLORG_MAX_DOC_FETCH_BYTES]. *)

val opam_repository_path : Fpath.t
val package_state_path : Fpath.t
