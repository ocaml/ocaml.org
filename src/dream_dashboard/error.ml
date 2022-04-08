type t = {
  message : string;  (** Error message *)
  name : string;  (** Error name *)
}

exception Exn of t

let of_luv (err : Luv.Error.t) =
  { name = Luv.Error.err_name err; message = Luv.Error.strerror err }
