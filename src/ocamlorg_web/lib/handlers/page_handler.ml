let with_lang req (f : ?lang:[> `English | `French ] -> 'a -> 'b) (x : 'a) =
  let language =
    match Dream_accept.accepted_languages req |> List.hd with
    | Dream_accept.Language "" ->
      "en"
    | Dream_accept.Language s ->
      (* We're only interested in the "en" in "en-US" *)
      String.split_on_char '-' s |> List.hd
    | Dream_accept.Any ->
      "en"
  in
  match language with "fr" -> f ~lang:`French x | _ -> f ~lang:`English x

let not_found _req =
  Page_layout_template.render
    ~title:"Page not found · OCaml"
    ~description:Config.meta_description
    (Not_found_template.render ())
  |> Dream.html ~code:404

let index _req =
  Page_layout_template.render
    ~title:"Welcome to a World of OCaml"
    ~description:
      "OCaml is a general purpose industrial-strength programming language \
       with an emphasis on expressiveness and safety."
    (Index_template.render ())
  |> Dream.html

let history _req =
  Page_layout_template.render
    ~title:"OCaml History"
    ~description:"A history of ocaml.org."
    (History_template.render ())
  |> Dream.html

let community_around_web _req =
  Page_layout_template.render
    ~title:"OCaml Around the Web"
    ~description:
      "Looking to interact with people who are also interested in OCaml? Find \
       out about upcoming events, read up on blogs from the community, sign up \
       for OCaml mailing lists, and discover even more places to engage with \
       people from the community!"
    (Community_around_web_template.render ())
  |> Dream.html

let community_events _req =
  Page_layout_template.render
    ~title:"Events"
    ~description:
      "Several events take place in the OCaml community over the course of \
       each year, in countries all over the world. This calendar will help you \
       stay up to date on what is coming up in the OCaml sphere."
    (Community_events_template.render ())
  |> Dream.html

let watch_ocamlorg_embed =
  let presentations =
    List.concat_map
      (fun (w : Ood.Workshop.t) -> w.presentations)
      Ood.Workshop.all
  in
  let rec get_last = function
    | [] ->
      ""
    | [ x ] ->
      x
    | _ :: xs ->
      get_last xs
  in
  let watch =
    List.map
      (fun (w : Ood.Watch.t) ->
        String.split_on_char '/' w.embed_path |> get_last |> fun v -> v, w)
      Ood.Watch.all
  in
  let tbl = Hashtbl.create 100 in
  let add_video (p : Ood.Workshop.presentation) =
    match p.video with
    | Some video ->
      let uuid = String.split_on_char '/' video |> get_last in
      let find (v, w) = if String.equal uuid v then Some w else None in
      let w = List.find_map find watch in
      Option.iter (fun w -> Hashtbl.add tbl p.title w) w
    | None ->
      ()
  in
  List.iter add_video presentations;
  tbl

let community_events_workshop req =
  let slug = Dream.param "id" req in
  match
    List.find_opt (fun x -> x.Ood.Workshop.slug = slug) Ood.Workshop.all
  with
  | Some workshop ->
    Page_layout_template.render
      ~title:(Printf.sprintf "%s · OCaml Tutorials" workshop.Ood.Workshop.title)
      ~description:workshop.Ood.Workshop.title
      (Community_events_workshop_template.render watch_ocamlorg_embed workshop)
    |> Dream.html
  | None ->
    not_found req

let community_media_archive _req =
  Page_layout_template.render
    ~title:"Media Archive"
    ~description:
      "This is where you can find archived videos, slides from talks, and \
       other media produced by people in the OCaml Community."
    (Community_media_archive_template.render ())
  |> Dream.html

let community_news _req =
  Page_layout_template.render
    ~title:"OCaml News"
    ~description:
      "This is where you'll find the latest stories from the OCaml Community!"
    (Community_blog_template.render ())
  |> Dream.html

let community_news_archive _req =
  Page_layout_template.render
    ~title:"News Archive"
    ~description:"Archive of news presented in the News page."
    (Community_news_archive_template.render ())
  |> Dream.html

let community_opportunities _req =
  Page_layout_template.render
    ~title:"Opportunities"
    ~description:
      "This is a space where groups, companies, and organisations can \
       advertise their projects directly to the OCaml community."
    (Community_opportunities_template.render ())
  |> Dream.html

let principles_successes req =
  let stories = with_lang req Ood.Success_story.all () in
  Page_layout_template.render
    ~title:"Success Stories · Read what our users are saying"
    ~description:
      "Read our success stories to learn how OCaml helped our users achieve \
       their goals."
    (Principles_successes_template.render stories)
  |> Dream.html

let principles_success req =
  let slug = Dream.param "id" req in
  let story = with_lang req Ood.Success_story.get_by_slug slug in
  match story with
  | Some story ->
    Page_layout_template.render
      ~title:
        (Printf.sprintf "%s · Success Stories" story.Ood.Success_story.title)
      ~description:"synopsys"
      (Principles_success_template.render story)
    |> Dream.html
  | None ->
    not_found req

let principles_industrial_users req =
  let users = with_lang req Ood.Industrial_user.all () in
  Page_layout_template.render
    ~title:"Industrial Users of OCaml"
    ~description:
      "With its strong security features and high performance, several \
       companies rely on OCaml to keep their data operating both safely and \
       efficiently. On this page, you can get an overview of the companies in \
       the community and learn more about how they use OCaml."
    (Principles_industrial_users_template.render users)
  |> Dream.html

let principles_academic _req =
  Page_layout_template.render
    ~title:"Academic Users of OCaml"
    ~description:"OCaml usage in the academic world."
    (Principles_academic_template.render Ood.Academic_institution.all)
  |> Dream.html

let principles_what_is_ocaml _req =
  Page_layout_template.render
    ~title:"What is OCaml?"
    ~description:"A description of OCaml's features."
    (Principles_what_is_ocaml_template.render ())
  |> Dream.html

let legal_carbon_footprint _req =
  Page_layout_template.render
    ~title:"Carbon Footprint"
    ~description:
      "Over the years, the OCaml community has become more and more proactive \
       when it comes to reducing its environmental impact. As part of this \
       journey we have documented our efforts towards becoming Carbon Zero."
    (Legal_carbon_footprint_template.render ())
  |> Dream.html

let legal_privacy _req =
  Page_layout_template.render
    ~title:"Privacy Policy"
    ~description:"???"
    (Legal_privacy_template.render ())
  |> Dream.html

let legal_terms _req =
  Page_layout_template.render
    ~title:"Terms and Conditions"
    ~description:"???"
    (Legal_terms_template.render ())
  |> Dream.html

let resources_applications _req =
  Page_layout_template.render
    ~title:"Using OCaml"
    ~description:
      "Besides developing in the language and making your own applications, \
       there are many useful tools that already exist in OCaml for you to use."
    (Resources_applications_template.render ())
  |> Dream.html

let resources_archive _req =
  Page_layout_template.render
    ~title:"Archive"
    ~description:"???"
    (Resources_archive_template.render ())
  |> Dream.html

let resources_best_practices _req =
  Page_layout_template.render
    ~title:"Best Practices"
    ~description:
      "Some guides to commonly used tools in OCaml development workflows."
    (Resources_best_practices_template.render Ood.Workflow.all)
  |> Dream.html

let resources_developing_in_ocaml _req =
  Page_layout_template.render
    ~title:"Developing in OCaml"
    ~description:"Workflows for application developers and library authors."
    (Resources_developing_in_ocaml_template.render ())
  |> Dream.html

let resources_language _req =
  Page_layout_template.render
    ~title:"The OCaml Language"
    ~description:
      "This is the home of learning and tutorials. Whether you're a beginner, \
       a teacher, or a seasoned researcher, this is where you can find the \
       resources you need to accomplish your goals in OCaml."
    (Resources_language_template.render ())
  |> Dream.html

let resources_papers _req =
  Page_layout_template.render
    ~title:"Papers"
    ~description:"A selection of papers grouped by popular categories."
    (Resources_papers_template.render ())
  |> Dream.html

let resources_papers_archive _req =
  Page_layout_template.render
    ~title:"Papers Archive"
    ~description:
      "A selection of OCaml papers through the ages. Filter by the tags or do \
       a search over all of the text."
    (Resources_papers_archive_template.render ())
  |> Dream.html

let resources_platform _req =
  Page_layout_template.render
    ~title:"Platform"
    ~description:
      "The OCaml Platform represents the best way for developers, both new and \
       old, to write software in OCaml."
    (Resources_platform_template.render ())
  |> Dream.html

let resources_releases _req =
  Page_layout_template.render
    ~title:"Releases"
    ~description:"???"
    (Resources_releases_template.render ())
  |> Dream.html

let resources_tutorials _req =
  Page_layout_template.render
    ~title:"OCaml Tutorials · Learn OCaml by topic"
    ~description:
      "Start learning the OCaml language by topic with out official tutorial."
    (Resources_tutorials_template.render ())
  |> Dream.html

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let resources_tutorial req =
  let slug = Dream.param "id" req in
  match
    List.find_opt
      (fun x -> slugify x.Ood.Tutorial.title = slug)
      Ood.Tutorial.all
  with
  | Some tutorial ->
    Page_layout_template.render
      ~title:(Printf.sprintf "%s · OCaml Tutorials" tutorial.Ood.Tutorial.title)
      ~description:tutorial.Ood.Tutorial.description
      (Resources_tutorial_template.render
         (fun x -> slugify x.Ood.Tutorial.title)
         Ood.Tutorial.all
         tutorial)
    |> Dream.html
  | None ->
    not_found req

let resources_using_ocaml _req =
  Page_layout_template.render
    ~title:"Using OCaml"
    ~description:
      "Besides developing in the language and making your own applications, \
       there are many useful tools that already exist in OCaml for you to use."
    (Resources_using_ocaml_template.render ())
  |> Dream.html
