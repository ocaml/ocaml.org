---
packages:
- name: "camlzip"
  version: "1.11"
libraries:
- camlzip
discussion: |
  - **About `camlzip`:** `camlzip` is a package that brings 3 modules: `Zip`, `Zlib`, and `Gzip`, which permit compression and decompression. The `Zip` module has several compression functions dependings on the origin of the uncompressed stream. Note: There are no proposed functions for storing directories in the archive. The decompression process should detect missing directories and create them before the decompression of files.
  - **Reference:** The [`Zip` `.mli` file](https://github.com/xavierleroy/camlzip/blob/master/zip.mli) is simple and well documented. 
---

(* A file-system traversal function. Here the given procedure is call for each regular file with its name as a parameter. Note: the Zip module doesn't provides function that would register a directory. *)

let rec traverse procedure directory =
  if Sys.is_directory directory then
    Sys.readdir directory
    |> Array.iter
         (fun entry ->
            traverse
              procedure
              (directory ^ "/" ^ entry))
  else
    procedure directory

(* Opening the ZIP file *)
let zip zip_filename directory_name =
  let zip = Zip.open_out zip_filename in

(* Process the compression of each file from the directory *)
  traverse
    (fun name ->
      Zip.copy_file_to_entry name zip name)
    directory_name;
(* Closing the file *)
  Zip.close_out zip

