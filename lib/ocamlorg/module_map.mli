module String_map : Map.S with type key = string

type kind =
  | Module
  | Page
  | Leaf_page
  | Module_type
  | Argument
  | Class
  | Class_type
  | File

module Module : sig
  type t

  val name : t -> string

  val parent : t -> t option

  val submodules : t -> t String_map.t

  val kind : t -> kind

  val path : t -> string
end

type library =
  { name : string
  ; dependencies : string list
  ; modules : Module.t String_map.t
  }

type t = { libraries : library String_map.t }

val of_yojson : Yojson.Safe.t -> t
