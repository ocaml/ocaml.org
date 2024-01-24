module type DB = sig
  val read : string -> string option
  val file_list : string list
end

let dbs : (_ * (module DB)) list =
  [
    ("academic_institutions", (module Data_academic_institutions));
    ("books", (module Data_books));
    ("changelog", (module Data_changelog));
    ("code_examples", (module Data_code_examples));
    ("events", (module Data_events));
    ("exercises", (module Data_exercises));
    ("industrial_users", (module Data_industrial_users));
    ("is_ocaml_yet", (module Data_is_ocaml_yet));
    ("media", (module Data_media));
    ("news", (module Data_news));
    ("pages", (module Data_pages));
    ("planet-local-blogs", (module Data_planet_local_blogs));
    ("planet", (module Data_planet));
    ("releases", (module Data_releases));
    ("success_stories", (module Data_success_stories));
    ("tutorials", (module Data_tutorials));
    ("workshops", (module Data_workshops));
  ]

let file_list =
  Data_root.file_list
  @ List.concat_map
      (fun (name, (module M : DB)) ->
        List.map (fun path -> Filename.concat name path) M.file_list)
      dbs

let db_of_string s =
  match List.assoc_opt s dbs with
  | Some db -> db
  | None -> Printf.ksprintf failwith "db_of_string: unknown db %s" s

let split_dir s =
  match Astring.String.cut s ~sep:"/" with
  | None -> ((module Data_root : DB), s)
  | Some (db_name, f) -> (db_of_string db_name, f)

let read s =
  let (module M : DB), path = split_dir s in
  M.read path
