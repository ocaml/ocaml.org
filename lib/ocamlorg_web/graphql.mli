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
    Package.Info.dependencies and returns a list of name and constraints record *)

val is_in_range : 'a -> 'a -> 'a -> bool
(** [is_in_range] function takes [current_version] [from_version] [upto_version]
    and compares the from_version upto_version with current_version and returns
    a boolean *)

val is_valid_params : int -> int -> int -> string

val packages_list
  :  string option
  -> int
  -> int
  -> Package.t list
  -> Package.state
  -> Package.t list

val all_packages_result
  :  string option
  -> int
  -> int option
  -> Package.t list
  -> Package.state
  -> (packages_success, string) result

val package_result
  :  string
  -> string option
  -> Package.state
  -> (Package.t, string) result

val package_versions_result
  :  string
  -> string option
  -> string option
  -> Package.state
  -> (packages_success, string) result

val schema : Package.state -> Dream.request Graphql_lwt.Schema.schema
(** This schema allows to query for opam packages from the opam-repository as
    graphql api data *)
