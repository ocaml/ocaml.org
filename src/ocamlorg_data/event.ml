
type t =
  { title : string
  ; slug : string
  ; description : string
  ; url : string
  ; date : string
  ; tags : string list
  ; online : bool
  ; textual_location : string option
  ; location : string option
  }

let all = 
[
  { title = {js|OCaml Users and Developers Workshop 2021|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2021|js}
  ; description = {js|The OCaml Workshop 2021 as part of ICFP|js}
  ; url = {js|https://icfp21.sigplan.org/home/ocaml-2021|js}
  ; date = {js|2021-08-27T09:00:40.154Z|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; online = true
  ; textual_location = None
  ; location = None
  };
 
  { title = {js|OCaml Users and Developers Workshop 2020|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2020|js}
  ; description = {js|The OCaml Workshop 2020 as part of ICFP|js}
  ; url = {js|https://icfp20.sigplan.org/home/ocaml-2020|js}
  ; date = {js|2020-08-20T09:00:42.358Z|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; online = true
  ; textual_location = Some {js|Jersey City|js}
  ; location = Some {js|{"type":"Point","coordinates":[-74.0739787,40.7262413]}|js}
  };
 
  { title = {js|OCaml User and Developer Workshop 2019|js}
  ; slug = {js|ocaml-user-and-developer-workshop-2019|js}
  ; description = {js|The OCaml Workshop 2019 as part of ICFP|js}
  ; url = {js|https://icfp19.sigplan.org/home/ocaml-2019#Call-for-Presentations|js}
  ; date = {js|2019-08-23T00:00:00.000Z|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; online = false
  ; textual_location = Some {js|Berlin|js}
  ; location = Some {js|{"type":"Point","coordinates":[13.4163451,52.4861467]}|js}
  }]

