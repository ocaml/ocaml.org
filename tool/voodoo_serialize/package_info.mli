module Kind : sig
  type t =
    [ `Module
    | `Page
    | `LeafPage
    | `ModuleType
    | `Parameter of int
    | `Class
    | `ClassType
    | `File ]

  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
  val of_yojson : t Conv.of_yojson
  val to_yojson : t Conv.to_yojson
end

module Module : sig
  type t = { name : string; submodules : t list; kind : Kind.t }

  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
  val of_yojson : t Conv.of_yojson
  val to_yojson : t Conv.to_yojson
end

module Library : sig
  type 'a t = { name : string; modules : 'a list; dependencies : string list }

  val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
  val pp : (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a t -> unit
  val of_yojson : 'a Conv.of_yojson -> 'a t Conv.of_yojson
  val to_yojson : 'a Conv.to_yojson -> 'a t Conv.to_yojson
end

type 'a t = { libraries : 'a Library.t list }

val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
val pp : (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a t -> unit
val of_yojson : 'a Conv.of_yojson -> 'a t Conv.of_yojson
val to_yojson : 'a Conv.to_yojson -> 'a t Conv.to_yojson
