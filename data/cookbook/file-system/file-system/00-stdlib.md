---
packages: []
sections:
- filename: main.ml
  language: ocaml
  code_blocks:
  - explanation: |
      Testing the presence of a file/directory
    code: |
      let () = if Sys.file_exists "my_file" then
                 print_string "The file/directory exists."
  - explanation: |
      Testing if file or directory which exists is a directory.
    code: |
      let () = if Sys.is_directory "my_file" then
                 print_string "It is a directory."
               else
                 print_string "It is a file (regular or not)."
  - explanation: |
      Deleting a file
    code: |
      let () = Sys.remove "my_file"
  - explanation:
      Renaming a file
    code: |
      let () = Sys.rename "my_file" "new_name"
  - explanation:
      Changing the current directory
    code: |
      let () = Sys.chdir "new_directory_path"
  - explanation:
      Deleting a directory
    code: |
      let () = Sys.rmdir "directory_name"
  - explanation:
      Listing a directory
    code: |
      let () =
        let file_array = Sys.readdir "directory_name" in
        Array.iter (fun filename -> Printf.printf "%s\n" filename) file_array
---

- **Reference:** All the presented functions are available in the [Sys module reference](https://v2.ocaml.org/api/Stdlib.Sys.html)
