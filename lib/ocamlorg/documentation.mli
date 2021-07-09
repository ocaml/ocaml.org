module Package : sig
  type t

  type status =
    | Built of string
    | Pending
    | Failed
    | Unknown

  val status : t -> status
end

module Universe : sig
  type t

  val deps : t -> OpamPackage.t list

  val hash : t -> string
end

type t

type error = [ `Not_found ]

val make : api:Uri.t -> polling:int -> unit -> t

module Stats : sig
  type status_count =
    { total : int
    ; failed : int
    ; pending : int
    ; success : int
    }

  type t =
    { opam : status_count
    ; versions : status_count
    ; universes : status_count
    }

  val to_string : status_count -> string
end

val stats : t -> Stats.t

val package_info : t -> OpamPackage.t -> Package.t option

val universe_info : t -> string -> Universe.t option

val load
  :  t
  -> string
  -> ([> Html_types.div ] Tyxml.Html.elt, [> error ]) result Lwt.t
