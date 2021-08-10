module Package = Ocamlorg.Package

type package_info =
  { name : string
  ; constraints : string option
  }

type packages_result =
  { total_packages : int
  ; packages : Package.t list
  }

val get_info : (Package.Name.t * string option) list -> package_info list
(** This function returns the list part of Package.Info such as
    Package.Info.dependencies *)

val schema : t:Package.state -> Dream.request Graphql_lwt.Schema.schema
(** This schema allows to query for opam packages from the opam-repository as
    graphql api data *)
