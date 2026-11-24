(** Where the package state and the opam-repository clone live. *)

val opam_repository : Fpath.t
(** The opam-repository clone: [OCAMLORG_REPO_PATH], by default
    [~/.cache/ocamlorg/opam-repository]. *)

val package_state : Fpath.t
(** The package state file: [OCAMLORG_PKG_STATE_PATH], by default
    [~/.cache/ocamlorg/package.state]. *)

val doc_modules_for : state:Fpath.t -> Fpath.t
(** The doc-modules index (#3982) that goes with the package state file [state]:
    [OCAMLORG_DOC_MODULES_PATH], by default [doc-modules.idx] next to [state].
    The builder, which is given its state file on the command line, uses this so
    that the index always lands next to that file. *)

val doc_modules : Fpath.t
(** The doc-modules index the server maps:
    [doc_modules_for ~state:package_state]. *)
