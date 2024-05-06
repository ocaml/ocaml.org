---
packages: []
discussion: |
  - **Reference:** All the presented functions are available in the [Sys module reference](https://v2.ocaml.org/api/Stdlib.Sys.html)
---
(* Testing the presence of a file/directory *)
let () = if Sys.file_exists "my_file" then
                 print_string "The file/directory exists."
(* Testing if file or directory which exists is a directory. *)
let () = if Sys.is_directory "my_file" then
                 print_string "It is a directory."
               else
                 print_string "It is a file (regular or not)."
(* Deleting a file *)
let () = Sys.remove "my_file"
(* Renaming a file *)
      let () = Sys.rename "my_file" "new_name"
(* Changing the current directory *)
      let () = Sys.chdir "new_directory_path"
(* Deleting a directory *)
      let () = Sys.rmdir "directory_name"
(* Listing a directory *)
      let () =
        let file_array = Sys.readdir "directory_name" in
        Array.iter (fun filename -> Printf.printf "%s\n" filename) file_array

