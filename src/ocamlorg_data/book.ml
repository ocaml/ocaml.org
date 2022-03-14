
type link = { description : string; uri : string }

type t = 
  { title : string
  ; slug : string
  ; description : string
  ; authors : string list
  ; language : string
  ; published : string
  ; cover : string
  ; isbn : string option
  ; links : link list
  ; rating : int option
  ; featured : bool
  ; body_md : string
  ; body_html : string
  }

let all = 
[]

