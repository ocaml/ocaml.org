(* Deserialization from binary blob *)

open Types

let unpack_from_buffer buf =
  let pos_ref = ref 0 in
  All_data.bin_read_t buf ~pos_ref

let unpack_from_file path =
  let ic = open_in_bin path in
  let len = in_channel_length ic in
  let buf = Bigstringaf.create len in
  for i = 0 to len - 1 do
    Bigstringaf.set buf i (input_char ic)
  done;
  close_in ic;
  unpack_from_buffer buf

(* For use with embedded blob - takes a bigarray directly *)
let unpack_from_bigarray
    (ba :
      (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t) =
  (* Create a bigstringaf from the bigarray data *)
  let len = Bigarray.Array1.dim ba in
  let buf = Bigstringaf.create len in
  for i = 0 to len - 1 do
    Bigstringaf.set buf i (Bigarray.Array1.get ba i)
  done;
  unpack_from_buffer buf
