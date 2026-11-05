(** Where the package state and the opam-repository clone live. *)

val opam_repository : Fpath.t
(** The opam-repository clone: [OCAMLORG_REPO_PATH], by default
    [~/.cache/ocamlorg/opam-repository]. *)

val package_state : Fpath.t
(** The package state file: [OCAMLORG_PKG_STATE_PATH], by default
    [~/.cache/ocamlorg/package.state]. *)
