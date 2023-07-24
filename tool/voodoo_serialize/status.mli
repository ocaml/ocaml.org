module Otherdocs : sig
  type t = {
    readme : Fpath.t list;
    license : Fpath.t list;
    changes : Fpath.t list;
    others : Fpath.t list;
  }

  val empty : t
  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
  val of_yojson : t Conv.of_yojson
  val to_yojson : t Conv.to_yojson
end

type t = { failed : bool; otherdocs : Otherdocs.t }

val equal : t -> t -> bool
val pp : Format.formatter -> t -> unit
val of_yojson : t Conv.of_yojson
val to_yojson : t Conv.to_yojson
