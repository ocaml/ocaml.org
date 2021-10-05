
type location = { lat : float; long : float }

type t =
  { title : string
  ; slug : string
  ; url : string
  ; textual_location : string
  ; location : location
  }

let all = 
[
  { title = {js|OCaml users in PariS (OUPS)|js}
  ; slug = {js|ocaml-users-in-paris-oups|js}
  ; url = {js|https://www.meetup.com/ocaml-paris/|js}
  ; textual_location = {js|Paris, France|js}
  ; location = { lat = 48.8566; long = 2.3522 }
  };
 
  { title = {js|NYC OCaml Meetups|js}
  ; slug = {js|nyc-ocaml-meetups|js}
  ; url = {js|https://www.meetup.com/NYC-OCaml|js}
  ; textual_location = {js|New York City, New York, USA|js}
  ; location = { lat = 40.7128; long = 74.006 }
  };
 
  { title = {js|Silicon Valley OCaml meetups|js}
  ; slug = {js|silicon-valley-ocaml-meetups|js}
  ; url = {js|https://www.meetup.com/NYC-OCaml|js}
  ; textual_location = {js|San Francisco, California, USA|js}
  ; location = { lat = 37.7749; long = 122.419 }
  };
 
  { title = {js|Cambridge NonDysFunctional Programmers|js}
  ; slug = {js|cambridge-nondysfunctional-programmers|js}
  ; url = {js|https://www.meetup.com/Cambridge-NonDysFunctional-Programmers/|js}
  ; textual_location = {js|Cambridge, United Kingdom|js}
  ; location = { lat = 52.2053; long = 0.1218 }
  }]

