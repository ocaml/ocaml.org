(* OCaml interface to the embedded data blob
 *
 * This module provides access to binary data that was embedded
 * into the executable via .incbin assembly directive.
 *
 * The data is in the binary's read-only section and lives for
 * the lifetime of the process - no allocation or deallocation needed.
 *)

external get_blob_raw :
  unit ->
  (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  = "caml_ocamlorg_data_blob"
(** External C functions *)

external get_size : unit -> int = "caml_ocamlorg_data_blob_size"
external _get_ptr : unit -> nativeint = "caml_ocamlorg_data_blob_ptr"
external check : unit -> bool = "caml_ocamlorg_data_blob_check"

type t = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
(** The type of the embedded blob - a bigarray of bytes *)

(** Get the embedded data blob as a bigarray.

    This is zero-copy - the returned bigarray directly references the data in
    the binary's read-only section.

    The data is immutable and lives for the entire program lifetime. *)
let get () : t = get_blob_raw ()

(** Get the size of the embedded data in bytes *)
let size () : int = get_size ()

(** Convert the blob to a Bigstringaf.t for use with bin_prot.

    Bigstringaf.t is the same underlying type as our bigarray, so this is also
    zero-copy. *)
let to_bigstring () : Bigstringaf.t =
  let ba = get_blob_raw () in
  (* Bigstringaf.t is (char, int8_unsigned_elt, c_layout) Bigarray.Array1.t
     which is exactly what we have *)
  ba

(** Check if the blob is properly initialized.

    Call this at startup to fail fast if something went wrong with the embedding
    process. *)
let is_valid () : bool = check ()

(** Verify the blob and raise an exception if invalid *)
let verify () : unit =
  if not (is_valid ()) then failwith "Data blob is not properly initialized"

(** Get a sub-region of the blob as a new bigstring.

    Unlike {!get} and {!to_bigstring}, this allocates a new buffer and copies
    the data. Use sparingly. *)
let sub ~pos ~len : Bigstringaf.t =
  let ba = get_blob_raw () in
  let total = Bigarray.Array1.dim ba in
  if pos < 0 || len < 0 || pos + len > total then
    invalid_arg
      (Printf.sprintf "Data_blob.sub: invalid range pos=%d len=%d total=%d" pos
         len total);
  let result = Bigstringaf.create len in
  for i = 0 to len - 1 do
    Bigstringaf.set result i (Bigarray.Array1.get ba (pos + i))
  done;
  result
