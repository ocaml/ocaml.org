(* Custom bin_prot serialization for Ptime.t We create a Ptime module that
   shadows the original and adds bin_io support. This way, when ppx_import
   brings in types with Ptime.t, they get bin_io for free. *)

open Bin_prot.Std

(* Shadow the Ptime module to add bin_io support *)
module Ptime = struct
  include Ptime

  (* bin_prot serialization - we serialize as RFC3339 string *)
  let bin_shape_t =
    Bin_prot.Shape.basetype (Bin_prot.Shape.Uuid.of_string "ptime") []

  let bin_size_t t =
    let s = to_rfc3339 t in
    bin_size_string s

  let bin_write_t buf ~pos t =
    let s = to_rfc3339 t in
    bin_write_string buf ~pos s

  let bin_read_t buf ~pos_ref =
    let s = bin_read_string buf ~pos_ref in
    match of_rfc3339 s with
    | Ok (t, _, _) -> t
    | Error _ -> failwith ("Invalid ptime RFC3339: " ^ s)

  let __bin_read_t__ _buf ~pos_ref _n =
    Bin_prot.Common.raise_variant_wrong_type "ptime" !pos_ref

  let bin_writer_t =
    { Bin_prot.Type_class.size = bin_size_t; write = bin_write_t }

  let bin_reader_t =
    { Bin_prot.Type_class.read = bin_read_t; vtag_read = __bin_read_t__ }

  let bin_t =
    {
      Bin_prot.Type_class.shape = bin_shape_t;
      writer = bin_writer_t;
      reader = bin_reader_t;
    }
end
