(* Deserialization from binary blob (PROTOTYPE: Marshal instead of bin_prot) *)

open Types

let unpack_from_bytes (b : bytes) : All_data.t = Marshal.from_bytes b 0

let unpack_from_file path =
  let ic = open_in_bin path in
  let len = in_channel_length ic in
  let b = Bytes.create len in
  really_input ic b 0 len;
  close_in ic;
  unpack_from_bytes b

(* For use with the embedded blob - copies a bigarray into bytes first. *)
let unpack_from_bigarray
    (ba :
      (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t) =
  let len = Bigarray.Array1.dim ba in
  let b = Bytes.create len in
  for i = 0 to len - 1 do
    Bytes.unsafe_set b i (Bigarray.Array1.unsafe_get ba i)
  done;
  unpack_from_bytes b
