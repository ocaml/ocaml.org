(* OCaml interface for accessing the embedded data blob *)

(* External functions defined in data_blob_stubs.c *)
external get_blob_size : unit -> int = "caml_ocamlorg_data_blob_size"
external get_blob_bigarray : unit -> (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t = "caml_ocamlorg_data_blob"
external get_blob_ptr : unit -> nativeint = "caml_ocamlorg_data_blob_ptr"

(* Convert the bigarray to bigstringaf for bin_prot compatibility *)
let get_blob () : Bigstringaf.t =
  let ba = get_blob_bigarray () in
  Bigstringaf.of_bigarray ba

(* Lazy initialization - data is only deserialized once on first access *)
let data : Types.All_data.t Lazy.t = lazy (
  let buf = get_blob () in
  Unpacker.unpack_from_buffer buf
)

let get_data () = Lazy.force data

(* Accessors for individual data types *)
let testimonials () = (get_data ()).testimonials
let jobs () = (get_data ()).jobs
let code_examples () = (get_data ()).code_examples
let opam_users () = (get_data ()).opam_users
let resources () = (get_data ()).resources
