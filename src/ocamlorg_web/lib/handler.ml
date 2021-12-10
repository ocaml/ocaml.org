open Import 

let not_found _req = Dream.html ~code:404 (Ocamlorg_frontend.not_found ())

let index _req = Dream.html (Ocamlorg_frontend.home ())

let learn _req =
  let papers =
    Ood.Paper.all |> List.filter (fun (paper : Ood.Paper.t) -> paper.featured)
  in
  let books =
    Ood.Book.all |> List.filter (fun (book : Ood.Book.t) -> book.featured)
  in
  let release = List.hd Ood.Release.all in
  Dream.html (Ocamlorg_frontend.learn ~papers ~books ~release)


let community _req = Dream.html (Ocamlorg_frontend.community ())

let success_stories _req =
  Dream.html (Ocamlorg_frontend.home ())

let success_story _req =
  Dream.html (Ocamlorg_frontend.home ())

let industrial_users _req =
  let users =
    Ood.Industrial_user.all ()
    |> List.filter (fun (item : Ood.Industrial_user.t) -> item.featured)
  in
  Dream.html (Ocamlorg_frontend.industrial_users users)
  
  let academic_users req =
    let search_user pattern t =
      let open Ood.Academic_institution in
      let pattern = String.lowercase_ascii pattern in
      let name_is_s { name; _ } = String.lowercase_ascii name = pattern in
      let name_contains_s { name; _ } =
        String.contains_s (String.lowercase_ascii name) pattern
      in
      let score user =
        if name_is_s user then
          -1
        else if name_contains_s user then
          0
        else
          failwith "impossible user score"
      in
      t
      |> List.filter (fun p -> name_contains_s p)
      |> List.sort (fun user_1 user_2 -> compare (score user_1) (score user_2))
    in
    let users =
      match Dream.query "q" req with
      | None ->
        Ood.Academic_institution.all ()
      | Some search ->
        search_user search (Ood.Academic_institution.all ())
    in
    let users =
      match Dream.query "c" req with
      | None ->
        users
      | Some continent ->
        List.filter
          (fun user -> user.Ood.Academic_institution.continent = continent)
          users
    in
    Dream.html (Ocamlorg_frontend.academic_users users)

let about _req = Dream.html (Ocamlorg_frontend.home ())

let books _req =
  let books =
    Ood.Book.all |> List.filter (fun (item : Ood.Book.t) -> item.featured)
  in
  Dream.html (Ocamlorg_frontend.books books)

let releases _req =
  Dream.html (Ocamlorg_frontend.home ())

let release _req =
  Dream.html (Ocamlorg_frontend.home ())

  let events _req =
    let workshops = Ood.Workshop.all in
    let meetups = Ood.Meetup.all in
    Dream.html (Ocamlorg_frontend.events ~workshops ~meetups)  

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
  Dream.html (Ocamlorg_frontend.best_practices Ood.Workflow.all)
  

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