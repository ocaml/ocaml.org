val load_package : string -> string -> (string, string) Hashtbl.t
(** [load_package package_name package_version] returns a hashtable with the URL
    of the documentation page as keys and the documentation content of the page
    as value. *)

val load_readme : string -> string -> string option
(** [load_content package_name package_version] returns the content of the
    documentation page of the package with the given version. *)
