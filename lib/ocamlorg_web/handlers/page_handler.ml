let index site_dir = Dream.static site_dir

let get_language req =
  match Dream_accept.accepted_languages req |> List.hd with
  | Dream_accept.Language "" ->
    "en"
  | Dream_accept.Language s ->
    (* We're only interested in the "en" in "en-US" *)
    String.split_on_char '-' s |> List.hd
  | Dream_accept.Any ->
    "en"

let success_stories req =
  let language = get_language req in
  let stories =
    match language with
    | "fr" ->
      Ood.Success_story.all_fr
    | _ ->
      Ood.Success_story.all_en
  in
  Page_layout_template.render
    ~title:"Success Stories · Read what our users are saying"
    ~description:
      "Read our success stories to learn how OCaml helped our users achieve \
       their goals."
    (Success_stories_template.render stories)
  |> Dream.html

let success_story req =
  let slug = Dream.param "id" req in
  let language = get_language req in
  let stories =
    match language with
    | "fr" ->
      Ood.Success_story.all_fr
    | _ ->
      Ood.Success_story.all_en
  in
  match List.find_opt (fun x -> x.Ood.Success_story.slug = slug) stories with
  | Some story ->
    Page_layout_template.render
      ~title:
        (Printf.sprintf "%s · Success Stories" story.Ood.Success_story.title)
      ~description:"synopsys"
      (Success_story_template.render story)
    |> Dream.html
  | None ->
    Dream.not_found req

let not_found _req =
  Page_layout_template.render
    ~title:"Page not found · OCaml"
    ~description:Config.meta_description
    (Not_found_template.render ())
  |> Dream.html ~status:`Not_Found
