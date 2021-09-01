module StringMap : Map.S with type key = string

type kind =
  | Module
  | Page
  | LeafPage
  | ModuleType
  | Argument
  | Class
  | ClassType
  | File

module Module : sig
  type t

  val name : t -> string

  val parent : t -> t option

  val submodules : t -> t StringMap.t

  val kind : t -> kind

  val path : t -> string
end

type library =
  { name : string
  ; dependencies : string list
  ; modules : Module.t StringMap.t
  }

type t = { libraries : library StringMap.t }

val of_yojson : Yojson.Safe.t -> t
