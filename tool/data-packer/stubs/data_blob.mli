(** Access to embedded binary data blob

    This module provides zero-copy access to binary data that was
    embedded into the executable at build time via the .incbin
    assembly directive.

    The data lives in the binary's read-only section and is available
    for the entire lifetime of the process without any allocation
    or deallocation overhead.

    Typical usage:
    {[
      let () = Data_blob.verify ()  (* fail fast if not initialized *)

      let data =
        let buf = Data_blob.to_bigstring () in
        let pos_ref = ref 0 in
        Types.All_data.bin_read_t buf ~pos_ref
    ]}
*)

(** The type of the embedded blob *)
type t = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

(** Get the embedded data blob as a bigarray.

    This is zero-copy - the returned bigarray directly references
    the data in the binary's read-only section.

    @raise Failure if the blob is not properly initialized *)
val get : unit -> t

(** Get the size of the embedded data in bytes *)
val size : unit -> int

(** Convert the blob to a Bigstringaf.t for use with bin_prot.

    This is zero-copy - Bigstringaf.t has the same underlying
    representation as our bigarray type. *)
val to_bigstring : unit -> Bigstringaf.t

(** Check if the blob is properly initialized.

    Returns [true] if the blob appears valid, [false] otherwise.
    Useful for graceful error handling. *)
val is_valid : unit -> bool

(** Verify the blob and raise an exception if invalid.

    Call this at startup to fail fast if something went wrong
    with the embedding process.

    @raise Failure if the blob is not valid *)
val verify : unit -> unit

(** [sub ~pos ~len] extracts a sub-region of the blob.

    Unlike {!get} and {!to_bigstring}, this allocates a new buffer
    and copies the data. Use sparingly.

    @raise Invalid_argument if the range is out of bounds *)
val sub : pos:int -> len:int -> Bigstringaf.t
