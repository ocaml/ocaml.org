---
packages: []
discussion: |
  - All presented functions are available in the [Sys module reference](https://ocaml.org/api/Stdlib.Sys.html).
---

(* Checks if a file or directory exists by testing
   the filename. *)
let file_exists filename =
  if Sys.file_exists filename then
    Printf.printf "The file/directory '%s' exists.\n"
      filename
  else
    Printf.printf "The file/directory '%s' does not \
      exist.\n" filename

(* Checks if the given path is a directory or a file. *)
let check_if_directory path =
  if Sys.file_exists path then
    (if Sys.is_directory path then
       Printf.printf "'%s' is a directory.\n" path
     else
       Printf.printf "'%s' is a file.\n" path)
  else
    Printf.printf "'%s' does not exist.\n" path

(* Copies the content of a source file to a destination
   file. *)
let copy_file src dst =
  let content =
    In_channel.with_open_text src In_channel.input_all
  in
  Out_channel.with_open_text dst (fun out_channel ->
      Out_channel.output_string out_channel content);
  Printf.printf "Copied '%s' to '%s'.\n" src dst

(* Moves (renames) a file to a new location or name. *)
let move_file src dst =
  if Sys.file_exists src then (
    Sys.rename src dst;
    Printf.printf "Moved '%s' to '%s'.\n" src dst
  ) else
    Printf.printf "File '%s' does not exist.\n" src

(* Deletes a specified file if it exists and is not
   a directory. *)
let delete_file filename =
  if Sys.file_exists filename &&
     not (Sys.is_directory filename) then (
    Sys.remove filename;
    Printf.printf "Deleted file '%s'.\n" filename
  ) else
    Printf.printf "File '%s' does not exist or is \
      a directory.\n" filename

(* Changes the current working directory to the
   specified directory path. *)
let change_directory dir =
  if Sys.file_exists dir && Sys.is_directory dir then (
    Sys.chdir dir;
    Printf.printf "Changed current directory to '%s'.\n"
      dir
  ) else
    Printf.printf "'%s' does not exist or is not \
      a directory.\n" dir

(* Deletes a specified directory if it exists. *)
let delete_directory dir =
  if Sys.file_exists dir && Sys.is_directory dir then (
    Sys.rmdir dir;
    Printf.printf "Deleted directory '%s'.\n" dir
  ) else
    Printf.printf "'%s' does not exist or is not \
      a directory.\n" dir

(* Lists all files and directories within a specified
   directory. Prints the names of the contents or an
   error if the path does not exist or is not a
   directory. *)
let list_directory dir =
  if Sys.file_exists dir && Sys.is_directory dir then (
    let file_array = Sys.readdir dir in
    Printf.printf "Contents of directory '%s':\n" dir;
    Array.iter (fun filename ->
      Printf.printf "  %s\n" filename) file_array
  ) else
    Printf.printf "'%s' does not exist or is not \
      a directory.\n" dir
