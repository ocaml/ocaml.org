(* This function compares two string and returns true if they are equal *)
val starts_with : string -> string -> bool

(* This function compares two string and returns true if they are equal *)
val is_package : string -> string -> bool

(* This schema allows to query for opam packages from the opam-repository and
   returns graphql data as graphiql playground and grphql json data*)
val schema : Dream.request Graphql_lwt.Schema.schema
