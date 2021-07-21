val load_package : string -> string -> (string, string) Hashtbl.t
(** [load_package package_name package_version] returns a hashtable with the URL
    of the documentation page as keys and the documentation content of the page
    as value. *)
