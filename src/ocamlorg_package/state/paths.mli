(** Where the package state and the opam-repository clone live. *)

val opam_repository : Fpath.t
(** The opam-repository clone: [OCAMLORG_REPO_PATH], by default
    [~/.cache/ocamlorg/opam-repository]. *)

val package_state : Fpath.t
(** The package state file: [OCAMLORG_PKG_STATE_PATH], by default
    [~/.cache/ocamlorg/package.state]. *)

val doc_modules : Fpath.t
(** The doc-modules index (#3982), downloaded by the builder and mapped by the
    server: [OCAMLORG_DOC_MODULES_PATH], by default [doc-modules.idx] next to
    {!package_state}. *)
