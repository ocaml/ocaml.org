module Package = Ocamlorg.Package

type package_info =
  { name : string
  ; constraints : string option
  }

type packages_success =
  { total_packages : int
  ; packages : Package.t list
  }

type packages_result = (packages_success, [ `Msg of string ]) result

type package_success = { package : Package.t }

type package_result = (package_success, [ `Msg of string ]) result

val get_info : (Package.Name.t * string option) list -> package_info list
(** [get_info] function loops through the list part of Package.Info such as
    Package.Info.dependencies and returns a list of name and constraints record
    Package.Info record *)

val is_in_range : 'a -> 'a -> 'a -> bool
(** [is_in_range] function takes [current_version] [from_version] [upto_version]
    and checks that current_version is between the range of from_version and
    upto_version *)

val is_valid_params : int -> int -> int -> string
(** [is_valid_params] function is a sub function of [all_packages_result] that
    takes [offset] [limit] [all_packages] and retruns an error message if limit
    or ossfest is less than 0 or gretaer than [all_packages]*)

val packages_list
  :  string option
  -> int
  -> int
  -> Package.t list
  -> Package.state
  -> Package.t list
(** [packages_list] function is a sub function of [all_packages_result] that
    takes [contains] [offset] [limit] [all_packages] [state] and returns a list
    of all packages within the [limit] and [offset] options *)

val all_packages_result
  :  string option
  -> int
  -> int option
  -> Package.t list
  -> Package.state
  -> (packages_success, string) result
(** [packages_list] function takes [contains] [offset] [limit] [all_packages]
    [state] and returns a list of the latest version of all packages with
    [limit] and [offset] options which is used to cut out some parts of the
    [packages_result] list. It also takes a [contains] option which will search
    the list of packages looking for the package with a name that has [contains]
    in it *)

val package_result
  :  string
  -> string option
  -> Package.state
  -> (Package.t, string) result
(** [package_result] function takes [name] [version] [state] and returns the
    latest version of the package with a name that matches [name] if no version
    is specified else it returns the package with name and version that match
    with [name] and [version]. An error message is returned if no package was
    found. *)

val package_versions_result
  :  string
  -> string option
  -> string option
  -> Package.state
  -> (packages_success, string) result
(** [package_versions_result] function takes [name] [from] [upto] [state] and
    returns the all versions of the package with a name that matches [name] if
    no [from] or [upto] version is specified else it returns the package [from]
    to [upto] versions specified. An error message is returned if no package or
    versions was found. *)

val schema : Package.state -> Dream.request Graphql_lwt.Schema.schema
(** This schema allows to query for opam packages from the opam-repository as
    graphql api data *)
