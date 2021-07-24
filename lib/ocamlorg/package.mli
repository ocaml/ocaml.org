(* This module manages the synchronisation of a local clone of
   opam-monorepository to access the opam packages and their metadata.

   It also uses the output of the occurent documentation pipeline to render
   packages documentation. *)

(** The name of an opam package. *)
module Name : sig
  type t

  val compare : t -> t -> int

  val to_string : t -> string

  val of_string : string -> t
end

(** The version of an opam package. *)
module Version : sig
  type t

  val compare : t -> t -> int

  val to_string : t -> string

  val of_string : string -> t
end

(** The information of a package. Typically, this is read from the opam file in
    the opam-repository. *)
module Info : sig
  type url =
    { uri : string
    ; checksum : string list
    }

  type t =
    { synopsis : string
    ; description : string
    ; authors : string list
    ; license : string
    ; homepage : string list
    ; tags : string list
    ; maintainers : string list
    ; dependencies : (Name.t * string option) list
    ; depopts : (Name.t * string option) list
    ; conflicts : (Name.t * string option) list
    ; url : url option
    }
end

module Documentation : sig
  type toc =
    { title : string
    ; href : string
    ; children : toc list
    }

  type t =
    { toc : toc list
    ; content : string
    }
end

type t

val name : t -> Name.t
(** Get the name of a package. *)

val version : t -> Version.t
(** Get the version of a package. *)

val info : t -> Info.t
(** Get the info of a package. *)

val readme_file : t -> string option
(** Get the readme of a package *)

val license_file : t -> string option
(** Get the license of a package *)

val documentation_page : t -> string -> Documentation.t option
(** Get the rendered content of an HTML page for a package given its URL
    relative to the root page of the documentation. *)

val all_packages_latest : unit -> t list
(** Get the list of the latest version of every opam packages.

    The name and versions of the packages are read from the file system, the
    metadata are loaded lazily to improve performance. *)

val get_packages_with_name : Name.t -> t list option
(** Get the list of packages with the given name. *)

val get_package_versions : Name.t -> Version.t list option
(** Get the list of versions for a package name. *)

val get_package_latest : Name.t -> t option
(** Get the latest version of a package given a package name. *)

val get_package : Name.t -> Version.t -> t option
(** Get a package given its name and version. *)

val search_package : string -> t list
(** Search package names that match the given string. *)
