val list_packages : unit -> string list
(** List the packages in the [packages/] directory of the opam repository. *)

val list_package_versions : string -> string list
(** List the versions of the given package by reading the directories in the
    [packages/<package>/] directory *)

val opam_file : string -> string -> OpamFile.OPAM.t
(** Return the opam file structure given a package name and package version. *)
