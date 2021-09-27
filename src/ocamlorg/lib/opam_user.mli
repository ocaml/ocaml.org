type t = Ood.Opam_user.t =
  { name : string
  ; email : string option
  ; github_username : string option
  ; avatar : string option
  }

val all : t list

val make
  :  name:string
  -> ?email:string
  -> ?github_username:string
  -> ?avatar:string
  -> unit
  -> t

val find_by_name : string -> t option
