type packages_result =
  { total_packages : int
  ; packages : Ocamlorg.Package.t list
  }

val starts_with : string -> string -> bool

val is_package : string -> string -> bool

(* This schema allows to query for opam packages from the opam-repository and *)
val schema : Dream.request Graphql_lwt.Schema.schema
