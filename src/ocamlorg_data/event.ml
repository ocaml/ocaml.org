
type t =
  { title : string
  ; slug : string
  ; description : string option
  ; organiser : string option
  ; url : string
  ; date : string
  ; tags : string list
  ; online : bool
  ; location : string option
  }

let all = 
[
  { title = {js|Rencontre d'été|js}
  ; slug = {js|rencontre-dt|js}
  ; description = None
  ; organiser = Some {js|OCaml Users in PariS|js}
  ; url = {js|https://www.meetup.com/ocaml-paris/events/188634632/|js}
  ; date = {js|2014-07-08T19:00:00Z|js}
  ; tags = 
 [{js|oups|js}]
  ; online = false
  ; location = Some {js|Mozilla Paris, 16 boulevard Montmartre 75009 Paris|js}
  };
 
  { title = {js|Rencontre de Printemps|js}
  ; slug = {js|rencontre-de-printemps|js}
  ; description = None
  ; organiser = Some {js|OCaml Users in PariS|js}
  ; url = {js|https://www.meetup.com/ocaml-paris/events/181647232/|js}
  ; date = {js|2014-05-22T19:00:00Z|js}
  ; tags = 
 [{js|oups|js}]
  ; online = false
  ; location = Some {js|IRILL 23, avenue d'Italie 75013 Paris|js}
  };
 
  { title = {js|Rencontre de Mai|js}
  ; slug = {js|rencontre-de-mai|js}
  ; description = None
  ; organiser = Some {js|OCaml Users in PariS|js}
  ; url = {js|https://www.meetup.com/ocaml-paris/events/116100692/|js}
  ; date = {js|2013-05-21T19:30:00Z|js}
  ; tags = 
 [{js|oups|js}]
  ; online = false
  ; location = Some {js|IRILL 23, avenue d'Italie 75013 Paris|js}
  };
 
  { title = {js|First OPAM party|js}
  ; slug = {js|first-opam-party|js}
  ; description = None
  ; organiser = Some {js|OCaml Users in PariS|js}
  ; url = {js|https://www.meetup.com/ocaml-paris/events/99222322/|js}
  ; date = {js|2013-01-29T20:00:00Z|js}
  ; tags = 
 [{js|oups|js}]
  ; online = false
  ; location = Some {js|IRILL 23, avenue d'Italie 75013 Paris|js}
  };
 
  { title = {js|OCaml Meeting 2013 in Nagoya|js}
  ; slug = {js|ocaml-meeting-2013-in-nagoya|js}
  ; description = None
  ; organiser = None
  ; url = {js|http://ocaml.jp/um2013|js}
  ; date = {js|2013-8-24T00:00:00Z|js}
  ; tags = 
 [{js|nagoya|js}]
  ; online = false
  ; location = Some {js|Nagoya University, Japan|js}
  };
 
  { title = {js|OCaml Meeting 2010 in Nagoya|js}
  ; slug = {js|ocaml-meeting-2010-in-nagoya|js}
  ; description = None
  ; organiser = None
  ; url = {js|http://ocaml.jp/um2010|js}
  ; date = {js|2013-8-24T00:00:00Z|js}
  ; tags = 
 [{js|nagoya|js}]
  ; online = false
  ; location = Some {js|Nagoya University, Japan|js}
  }]

