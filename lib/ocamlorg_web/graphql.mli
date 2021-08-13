module Package = Ocamlorg.Package

type package_info =
  { name : string
  ; constraints : string option
  }

type packages_result =
  { total_packages : int
  ; packages : Package.t list
  }

val starts_with : string -> string -> bool
(** [starts_with] function compares two strings and returns true if the first
    string is equal to the beginning of the second string up to capitalization *)

val is_package : string -> string -> bool
(** [is_package] function compares two strings and returns true if they are
    equal up to capitalization *)

val get_packages_result
  :  int
  -> int
  -> int
  -> string option
  -> Package.t list
  -> packages_result
(** [get_packages_result total_packages offset limit startswith packages]
    returns a list of the latest version of all packages with [limit] and
    [offset] options which is used to cut out some parts of the
    [packages_result] list. It also takes a [startswith] option which will
    search the list of packages looking for the package with a name that begins
    with [startswith] *)

val get_single_package : Package.t list -> string -> Package.t option
(** [get_single_package packages name] will search the list of packages looking
    for the package with a name that matches [name], [None] is returned if no
    package can be found. *)

val get_info : (Package.Name.t * string option) list -> package_info list
(** [get_info] function loops through the list part of Package.Info such as
    Package.Info.dependencies and returns a list of name and constraints record *)

val schema : Package.state -> Dream.request Graphql_lwt.Schema.schema
(** This schema allows to query for opam packages from the opam-repository as
    graphql api data *)
