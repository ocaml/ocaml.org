(* This module manages the synchronisation of a local clone of
   opam-monorepository to access the opam packages and their metadata. It also
   uses the output of the occurent documentation pipeline to render packages
   documentation. *)

(** The name of an opam package. *)
module Name : sig
  type t

  val compare : t -> t -> int

  val to_string : t -> string

  val of_string : string -> t

  module Map : OpamStd.MAP with type key := t
end

(** The version of an opam package. *)
module Version : sig
  type t

  val compare : t -> t -> int

  val to_string : t -> string

  val of_string : string -> t

  module Map : OpamStd.MAP with type key := t
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
    ; authors : Ood.Opam_user.t list
    ; maintainers : Ood.Opam_user.t list
    ; license : string
    ; homepage : string list
    ; tags : string list
    ; dependencies : (Name.t * string option) list
    ; rev_deps : (Name.t * string option * Version.t) list
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

  type item =
    | Module of string
    | ModuleType of string
    | FunctorArgument of int * string

  type t =
    { toc : toc list
    ; module_path : item list
    ; content : string
    }
end

module Module_map = Module_map

type state

type t

val state_of_package_list : t list -> state
(** [state_of_package_list ts] produces the opam-repository state from a list of
    packages *)

val name : t -> Name.t
(** Get the name of a package. *)

val version : t -> Version.t
(** Get the version of a package. *)

val info : t -> Info.t
(** Get the info of a package. *)

val create : name:Name.t -> version:Version.t -> Info.t -> t
(** This is added to enable demo test package to use Package.t with abstraction *)

val readme_file
  :  kind:[< `Package | `Universe of string ]
  -> t
  -> string option Lwt.t
(** Get the readme of a package *)

val license_file
  :  kind:[< `Package | `Universe of string ]
  -> t
  -> string option Lwt.t
(** Get the license of a package *)

val documentation_status
  :  kind:[< `Package | `Universe of string ]
  -> t
  -> [ `Success | `Failure | `Unknown ] Lwt.t
(** Get the build status of the documentation of a package *)

val toplevel_status
  :  kind:[< `Package | `Universe of string ]
  -> t
  -> [ `Success | `Failure | `Unknown ] Lwt.t
(** Get the build status of the toplevel of a package *)

val module_map
  :  kind:[< `Package | `Universe of string ]
  -> t
  -> Module_map.t Lwt.t

val documentation_page
  :  kind:[< `Package | `Universe of string ]
  -> t
  -> string
  -> Documentation.t option Lwt.t
(** Get the rendered content of an HTML page for a package given its URL
    relative to the root page of the documentation. *)

val init : ?disable_polling:bool -> unit -> state
(** [init ()] initialises the opam-repository state. By default
    [disable_polling] is set to [false], but can be disabled for tests. *)

val toplevel : t -> string option
(** Get the URL of the toplevel script for the given package. *)

val all_packages_latest : state -> t list
(** Get the list of the latest version of every opam packages. The name and
    versions of the packages are read from the file system, the metadata are
    loaded lazily to improve performance. *)

val get_packages_with_name : state -> Name.t -> t list option
(** Get the list of packages with the given name. *)

val get_package_versions : state -> Name.t -> Version.t list option
(** Get the list of versions for a package name. *)

val get_package_latest : state -> Name.t -> t option
(** Get the latest version of a package given a package name. *)

val get_package : state -> Name.t -> Version.t -> t option
(** Get a package given its name and version. *)

val search_package : state -> string -> t list
(** Search package that match the given string.

    Packages returned contain the string either in the name, tags, synopsis or
    description. They are ordered in the following way:

    - Packages whose name is exactly the given string
    - packages whose name contain the given string
    - packages having the given string as a tag
    - packages whose synopsis contain the given string
    - packages whose description contain the given string.

    A call to this function call Lazy.force on every package info. *)

val toplevels_path : Fpath.t
