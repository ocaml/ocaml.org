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
