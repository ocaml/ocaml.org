---
packages:
- name: "camlzip"
  version: "1.11"
libraries:
- camlzip
discussion: |
  - **About `camlzip`:** `camlzip` is a package that brings 3 modules: `Zip`, `Zlib`, and `Gzip`, which permit compression and decompression. The `Gzip` module has two compression functions, depending on the destination of the compressed stream (file or output channel).
  - **Reference:** The [`Gzip` `.mli` file](https://github.com/xavierleroy/camlzip/blob/master/gzip.mli) is simple and well documented. 
---

(* The `gzip` compression function opens both files (`source` and `dest`) and transfers bytes through a bytes buffer with the appropriate libraries *)

let buffer_size = 4096

let gzip source dest =
  let gz_file = Gzip.open_out ~level:9 dest in
  let buffer = Bytes.make buffer_size '*' in
  let ic = In_channel.open_bin source in
  let rec aux () =
    let len = In_channel.input ic buffer 0 buffer_size in
    if len <> 0 then
      begin
        Gzip.output gz_file buffer 0 len;
        aux ()
      end
  in
  aux ();
  Gzip.close_out gz_file;
  In_channel.close ic
