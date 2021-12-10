let not_found _req = Dream.html ~code:404 (Ocamlorg_frontend.not_found ())

let index _req = Dream.html (Ocamlorg_frontend.home ())

let learn _req =
  Dream.html (Ocamlorg_frontend.home ())

let community _req = Dream.html (Ocamlorg_frontend.community ())

let success_stories _req =
  Dream.html (Ocamlorg_frontend.home ())

let success_story _req =
  Dream.html (Ocamlorg_frontend.home ())

let industrial_users _req =
  Dream.html (Ocamlorg_frontend.home ())

let academic_users _req =
  Dream.html (Ocamlorg_frontend.home ())

let about _req = Dream.html (Ocamlorg_frontend.home ())

let books _req =
  Dream.html (Ocamlorg_frontend.home ())

let releases _req =
  Dream.html (Ocamlorg_frontend.home ())

let release _req =
  Dream.html (Ocamlorg_frontend.home ())

let events _req =
  Dream.html (Ocamlorg_frontend.home ())

let workshop _req =
  Dream.html (Ocamlorg_frontend.home ())

let blog _req = Dream.html (Ocamlorg_frontend.blog ())

let opportunities _req =
  Dream.html (Ocamlorg_frontend.home ())

let opportunity _req =
  Dream.html (Ocamlorg_frontend.home ())

let carbon_footprint _req = Dream.html (Ocamlorg_frontend.carbon_footprint ())

let privacy _req = Dream.html (Ocamlorg_frontend.privacy ())

let terms _req = Dream.html (Ocamlorg_frontend.terms ())

let papers _req =
  Dream.html (Ocamlorg_frontend.home ())

let tutorial _req =
  Dream.html (Ocamlorg_frontend.home ())

let best_practices _req =
  Dream.html (Ocamlorg_frontend.home ())

let problems _req = Dream.html (Ocamlorg_frontend.home ())

type package_kind =
  | Package
  | Universe

let packages _req = Dream.html (Ocamlorg_frontend.home ())

let packages_search _t _req =
  Dream.html (Ocamlorg_frontend.home ())

let package _t _req =
  Dream.html (Ocamlorg_frontend.home ())

let package_versioned _t _kind _req =
  Dream.html (Ocamlorg_frontend.home ())

let package_doc _t _kind _req =
  Dream.html (Ocamlorg_frontend.home ())

let package_toplevel _t _kind _req =
  Dream.html (Ocamlorg_frontend.home ())