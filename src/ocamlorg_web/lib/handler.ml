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

let opportunities req =
  let search_job pattern t =
    let open Ood.Job in
    let pattern = String.lowercase_ascii pattern in
    let title_is_s { title; _ } = String.lowercase_ascii title = pattern in
    let title_contains_s { title; _ } =
      String.contains_s (String.lowercase_ascii title) pattern
    in
    let score job =
      if title_is_s job then
        -1
      else if title_contains_s job then
        0
      else
        failwith "impossible job score"
    in
    t
    |> List.filter (fun p -> title_contains_s p)
    |> List.sort (fun job_1 job_2 -> compare (score job_1) (score job_2))
  in
  let search = Dream.query "q" req in
  let jobs =
    match search with
    | None ->
      Ood.Job.all_not_fullfilled
    | Some search ->
      search_job search Ood.Job.all_not_fullfilled
  in
  let country = Dream.query "c" req in
  let jobs =
    match country with
    | None | Some "All" ->
      jobs
    | Some country ->
      List.filter (fun job -> job.Ood.Job.country = country) jobs
  in
  Dream.html (Ocamlorg_frontend.opportunities ?search ?country jobs)

let opportunity req =
  let id = Dream.param "id" req in
  match Option.bind (int_of_string_opt id) Ood.Job.get_by_id with
  | Some job ->
    Dream.html (Ocamlorg_frontend.opportunity job)
  | None ->
    not_found req

let carbon_footprint _req = Dream.html (Ocamlorg_frontend.carbon_footprint ())

let privacy _req = Dream.html (Ocamlorg_frontend.privacy ())

let terms _req = Dream.html (Ocamlorg_frontend.terms ())

let papers req =
  let search_paper pattern t =
    let open Ood.Paper in
    let pattern = String.lowercase_ascii pattern in
    let title_is_s { title; _ } = String.lowercase_ascii title = pattern in
    let title_contains_s { title; _ } =
      String.contains_s (String.lowercase_ascii title) pattern
    in
    let abstract_contains_s { abstract; _ } =
      String.contains_s (String.lowercase_ascii abstract) pattern
    in
    let has_tag_s { tags; _ } =
      List.exists
        (fun tag -> String.contains_s (String.lowercase_ascii tag) pattern)
        tags
    in
    let score paper =
      if title_is_s paper then
        -1
      else if title_contains_s paper then
        0
      else if has_tag_s paper then
        1
      else if abstract_contains_s paper then
        2
      else
        failwith "impossible paper score"
    in
    t
    |> List.filter (fun p -> title_contains_s p)
    |> List.sort (fun paper_1 paper_2 ->
           compare (score paper_1) (score paper_2))
  in
  let search = Dream.query "q" req in
  let papers =
    match search with
    | None ->
      Ood.Paper.all
    | Some search ->
      search_paper search Ood.Paper.all
  in
  let recommended_papers =
    Ood.Paper.all |> List.filter (fun (paper : Ood.Paper.t) -> paper.featured)
  in
  Dream.html (Ocamlorg_frontend.papers ?search ~recommended_papers papers)

let tutorial _req =
  Dream.html (Ocamlorg_frontend.home ())

let best_practices _req =
  Dream.html (Ocamlorg_frontend.best_practices Ood.Workflow.all)
  

let problems _req = Dream.html (Ocamlorg_frontend.problems Ood.Problem.all)

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