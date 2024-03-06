---
packages:
- name: "camlzip"
  version: "1.11"
libraries:
- camlzip
discussion: |
  - **About `camlzip`:** `camlzip` is a package that brings 3 modules: `Zip`, `Zlib`, and `Gzip`, which permit compression and decompression. The `Zip` module has several decompression functions dependings on the destination of the uncompressed stream.
  - **Reference:** The [`Zip` `.mli` file](https://github.com/xavierleroy/camlzip/blob/master/zip.mli) is simple and well documented. 
---

(* Unzipping a ZIP file may be tricky if the file to be created should belong to a directory that doesn't exist yet *)

let ensure_directory_existence filename =
  let rec aux_ensure base l =
    if not (Sys.file_exists base) then
      Sys.mkdir base 0o755
    else
      if not (Sys.is_directory base) then
        failwith "Error, file exists instead of a directory";
    match l with
    | [] -> failwith "Should not happen"
    | [ _filename ] -> ()
    | directory :: l' -> aux_ensure (base ^ "/" ^ directory) l'
  in
  match String.split_on_char '/' filename with
  | [ ] -> failwith "Should not happen (null filename)"
  | [ _filename ] -> ()
  | directory :: l -> aux_ensure directory l

(* Opening the ZIP file *)
let unzip zip_filename =
  let zip = Zip.open_in zip_filename in

(* Getting all entries and itering with them *)
  let entries = Zip.entries zip in
  entries
  |> List.iter (fun entry ->
         Printf.printf "%s\n" entry.Zip.filename;
         ensure_directory_existence entry.Zip.filename;
(* If it is a dictionary, just create the dictionary *)
         if entry.Zip.is_directory then
           Sys.mkdir entry.Zip.filename 0o755

(* and if it is a regular file decompress it *)
         else
           Zip.copy_entry_to_file
             zip
             entry
             entry.Zip.filename);
(* And close the ZIP file *)
  Zip.close_in zip
