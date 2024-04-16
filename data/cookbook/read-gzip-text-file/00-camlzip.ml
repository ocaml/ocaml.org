---
packages:
- name: camlzip
  tested_version: "1.11"
  used_libraries:
  - zip
---

(* The `zip` library does not have `with_open_text`. We copy what's needed to have it from the OCaml's standard library.
  See [`ocaml/stdlib/in_channel.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/in_channel.ml#L105) *)
let read_upto ic buf ofs len =
  let rec loop ofs len =
    if len = 0 then ofs
    else begin
      let r = Gzip.input ic buf ofs len in
      if r = 0 then
        ofs
      else
        loop (ofs + r) (len - r)
    end
  in
  loop ofs len - ofs

(* [`ocaml/stdlib/in_channel.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/in_channel.ml#L130) *)
let ensure buf ofs n =
  let len = Bytes.length buf in
  if len >= ofs + n then buf
  else begin
    let new_len = ref len in
    while !new_len < ofs + n do
        new_len := 2 * !new_len + 1
    done;
    let new_len = !new_len in
    let new_len =
        if new_len <= Sys.max_string_length then
        new_len
        else if ofs < Sys.max_string_length then
        Sys.max_string_length
        else
        failwith "In_channel.input_all: channel content \
                    is larger than maximum string length"
    in
    let new_buf = Bytes.create new_len in
    Bytes.blit buf 0 new_buf 0 ofs;
    new_buf
  end

(* [`ocaml/stdlib/in_channel.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/in_channel.ml#L153) *)
let input_all ic =
  let chunk_size = 65536 in
  let initial_size = chunk_size in
  let initial_size =
    if initial_size <= Sys.max_string_length then
      initial_size
    else
      Sys.max_string_length
  in
  let buf = Bytes.create initial_size in
  let nread = read_upto ic buf 0 initial_size in
  if nread < initial_size then
    Bytes.sub_string buf 0 nread
  else begin
    match Gzip.input_char ic with
    | exception End_of_file ->
        Bytes.unsafe_to_string buf
    | c ->
        let rec loop buf ofs =
          let buf = ensure buf ofs chunk_size in
          let rem = Bytes.length buf - ofs in
          let r = read_upto ic buf ofs rem in
          if r < rem then
            Bytes.sub_string buf 0 (ofs + r)
          else
            loop buf (ofs + rem)
        in
        let buf = ensure buf nread (chunk_size + 1) in
        Bytes.set buf nread c;
        loop buf (nread + 1)
  end

(* [`ocaml/stdlib/stdlib.ml`]https://github.com/ocaml/ocaml/blob/trunk/stdlib/stdlib.ml#L480) *)
let close_in_noerr ic = Gzip.(try close_in ic with _ -> ())

(* [`ocaml/stdlib/in_channel.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/in_channel.ml#L34) *)
let with_open openfun s f =
  let ic = openfun s in
  Fun.protect ~finally:(fun () -> close_in_noerr ic)
    (fun () -> f ic)

(* [`ocaml/stdlib/in_channel.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/in_channel.ml#L45) *)
let with_open_text s f =
  with_open Gzip.open_in s f

(* Read the compressed text file. *)
let text = with_open_text "" input_all
