
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
  { title = "OCaml Users and Developers Workshop 2021"
  ; slug = "ocaml-users-and-developers-workshop-2021"
  ; description = "The OCaml Workshop 2021 as part of ICFP"
  ; url = "https://icfp21.sigplan.org/home/ocaml-2021"
  ; date = "2021-08-27T09:00:40.154Z"
  ; tags = 
 ["ocaml-workshop"]
  ; online = true
  ; textual_location = None
  ; location = None
  };
 
  { title = "OCaml Users and Developers Workshop 2020"
  ; slug = "ocaml-users-and-developers-workshop-2020"
  ; description = "The OCaml Workshop 2020 as part of ICFP"
  ; url = "https://icfp20.sigplan.org/home/ocaml-2020"
  ; date = "2020-08-20T09:00:42.358Z"
  ; tags = 
 ["ocaml-workshop"]
  ; online = true
  ; textual_location = Some "Jersey City"
  ; location = Some 
 "{\"type\":\"Point\",\"coordinates\":[-74.0739787,40.7262413]}"
  };
 
  { title = "OCaml User and Developer Workshop 2019"
  ; slug = "ocaml-user-and-developer-workshop-2019"
  ; description = "The OCaml Workshop 2019 as part of ICFP"
  ; url = "https://icfp19.sigplan.org/home/ocaml-2019#Call-for-Presentations"
  ; date = "2019-08-23T00:00:00.000Z"
  ; tags = 
 ["ocaml-workshop"]
  ; online = false
  ; textual_location = Some "Berlin"
  ; location = Some 
 "{\"type\":\"Point\",\"coordinates\":[13.4163451,52.4861467]}"
  }]

