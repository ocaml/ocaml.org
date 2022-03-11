
type kind = [ `Compiler ]

type t =
  { kind : kind
  ; version : string
  ; date : string
  ; intro_md : string
  ; intro_html : string
  ; highlights_md : string
  ; highlights_html : string
  ; body_md : string
  ; body_html : string
  }
  
let all = 
[]

