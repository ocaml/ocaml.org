module Info : sig
  type t =
    { synopsis : string
    ; description : string
    ; authors : string list
    ; license : string
    ; publication_date : string
    ; homepage : string list
    ; tags : string list
    ; maintainers : string list
    ; dependencies : (OpamPackage.Name.t * string option) list
    ; depopts : (OpamPackage.Name.t * string option) list
    ; conflicts : (OpamPackage.Name.t * string option) list
    }

  val of_opamfile : OpamFile.OPAM.t -> t
end

type t =
  { name : OpamPackage.Name.t
  ; version : OpamPackage.Version.t
  ; info : Info.t
  }

val of_opamfile : OpamFile.OPAM.t -> t
