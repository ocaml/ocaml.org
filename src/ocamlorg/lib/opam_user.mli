type t =
  { name : string
  ; handle : string option
  ; image : string option
  }

val all : t list

val make : name:string -> ?handle:string -> ?image:string -> unit -> t

val find_by_name : string -> t option
