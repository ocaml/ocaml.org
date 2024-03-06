---
packages:
- name: "camlzip"
  version: "1.11"
libraries:
- camlzip
discussion: |
  - **About `camlzip`:** `camlzip` is a package that brings 3 modules: `Zip`, `Zlib`, and `Gzip`, which permit compression and decompression. The `Gzip` module has two decompression functions, depending on the origin of the compressed stream (file or output channel).
  - **Reference:** The [`Gzip` `.mli` file](https://github.com/xavierleroy/camlzip/blob/master/gzip.mli) is simple and well documented.
---

(* The `gunzip` compression function opens both files (`source` and `dest`) and transfers bytes through a bytes buffer with the appropriate libraries *)

let buffer_size = 4096

let gunzip source dest =
  let gz_file = Gzip.open_in source in
  let buffer = Bytes.make buffer_size '*' in
  let oc = Out_channel.open_bin dest in
  let rec aux () =
    let len = Gzip.input gz_file buffer 0 buffer_size in
    if len <> 0 then
      begin
        Out_channel.output oc buffer 0 len;
        aux ()
      end
  in
  aux ();
  Gzip.close_in gz_file;
  Out_channel.close oc
