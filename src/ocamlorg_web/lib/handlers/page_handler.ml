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
  (* In order for the toplevel to work when revisiting a page, for now we force
     a full reload when navigating back to the index page *)
    ~turbo_full_reload:true
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

let around_web _req =
  Page_layout_template.render
    ~title:"OCaml Around the Web"
    ~description:
      "Looking to interact with people who are also interested in OCaml? Find \
       out about upcoming events, read up on blogs from the community, sign up \
       for OCaml mailing lists, and discover even more places to engage with \
       people from the community!"
    (Around_web_template.render ())
  |> Dream.html

let events _req =
  Page_layout_template.render
    ~title:"Events"
    ~description:
      "Several events take place in the OCaml community over the course of \
       each year, in countries all over the world. This calendar will help you \
       stay up to date on what is coming up in the OCaml sphere."
    (Events_template.render ())
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

let events_workshop req =
  let slug = Dream.param "id" req in
  match
    List.find_opt (fun x -> x.Ood.Workshop.slug = slug) Ood.Workshop.all
  with
  | Some workshop ->
    Page_layout_template.render
      ~title:(Printf.sprintf "%s · OCaml Tutorials" workshop.Ood.Workshop.title)
      ~description:workshop.Ood.Workshop.title
      (Events_workshop_template.render watch_ocamlorg_embed workshop)
    |> Dream.html
  | None ->
    not_found req

let media_archive _req =
  Page_layout_template.render
    ~title:"Media Archive"
    ~description:
      "This is where you can find archived videos, slides from talks, and \
       other media produced by people in the OCaml Community."
    (Media_archive_template.render ())
  |> Dream.html

let news _req =
  Page_layout_template.render
    ~title:"OCaml News"
    ~description:
      "This is where you'll find the latest stories from the OCaml Community!"
    (Blog_template.render ())
  |> Dream.html

let opportunities _req =
  Page_layout_template.render
    ~title:"Opportunities"
    ~description:
      "This is a space where groups, companies, and organisations can \
       advertise their projects directly to the OCaml community."
    (Opportunities_template.render Ood.Job.all_not_fullfilled)
  |> Dream.html

let opportunity req =
  let id = Dream.param "id" req in
  match Option.bind (int_of_string_opt id) Ood.Job.get_by_id with
  | Some job ->
    Page_layout_template.render
      ~title:(Printf.sprintf "%s · OCaml Opportunity" job.Ood.Job.title)
      ~description:"???"
      (Opportunity_template.render job)
    |> Dream.html
  | None ->
    not_found req

let successes req =
  let stories = with_lang req Ood.Success_story.all () in
  Page_layout_template.render
    ~title:"Success Stories · Read what our users are saying"
    ~description:
      "Read our success stories to learn how OCaml helped our users achieve \
       their goals."
    (Successes_template.render stories)
  |> Dream.html

let success req =
  let slug = Dream.param "id" req in
  let story = with_lang req Ood.Success_story.get_by_slug slug in
  match story with
  | Some story ->
    Page_layout_template.render
      ~title:
        (Printf.sprintf "%s · Success Stories" story.Ood.Success_story.title)
      ~description:"synopsys"
      (Success_template.render story)
    |> Dream.html
  | None ->
    not_found req

let industrial_users req =
  let users = with_lang req Ood.Industrial_user.all () in
  Page_layout_template.render
    ~title:"Industrial Users of OCaml"
    ~description:
      "With its strong security features and high performance, several \
       companies rely on OCaml to keep their data operating both safely and \
       efficiently. On this page, you can get an overview of the companies in \
       the community and learn more about how they use OCaml."
    (Industrial_users_template.render users)
  |> Dream.html

let academic req =
  let users = with_lang req Ood.Academic_institution.all () in
  Page_layout_template.render
    ~title:"Academic Users of OCaml"
    ~description:"OCaml usage in the academic world."
    (Academic_template.render users)
  |> Dream.html

let what_is_ocaml _req =
  Page_layout_template.render
    ~title:"What is OCaml?"
    ~description:"A description of OCaml's features."
    (What_is_ocaml_template.render ())
  |> Dream.html

let carbon_footprint _req =
  Page_layout_template.render
    ~title:"Carbon Footprint"
    ~description:
      "Over the years, the OCaml community has become more and more proactive \
       when it comes to reducing its environmental impact. As part of this \
       journey we have documented our efforts towards becoming Carbon Zero."
    (Carbon_footprint_template.render ())
  |> Dream.html

let privacy _req =
  Page_layout_template.render
    ~title:"Privacy Policy"
    ~description:"???"
    (Privacy_template.render ())
  |> Dream.html

let terms _req =
  Page_layout_template.render
    ~title:"Terms and Conditions"
    ~description:"???"
    (Terms_template.render ())
  |> Dream.html

let applications _req =
  Page_layout_template.render
    ~title:"Using OCaml"
    ~description:
      "Besides developing in the language and making your own applications, \
       there are many useful tools that already exist in OCaml for you to use."
    (Applications_template.render ())
  |> Dream.html

let archive _req =
  Page_layout_template.render
    ~title:"Archive"
    ~description:"???"
    (Archive_template.render ())
  |> Dream.html

let best_practices _req =
  Page_layout_template.render
    ~title:"Best Practices"
    ~description:
      "Some guides to commonly used tools in OCaml development workflows."
    (Best_practices_template.render Ood.Workflow.all)
  |> Dream.html

let language _req =
  Page_layout_template.render
    ~title:"The OCaml Language"
    ~description:
      "This is the home of learning and tutorials. Whether you're a beginner, \
       a teacher, or a seasoned researcher, this is where you can find the \
       resources you need to accomplish your goals in OCaml."
    (Language_template.render ())
  |> Dream.html

let papers _req =
  Page_layout_template.render
    ~title:"Papers"
    ~description:"A selection of papers grouped by popular categories."
    (Papers_template.render ())
  |> Dream.html

let books _req =
  Page_layout_template.render
    ~title:"Books"
    ~description:"A selection of books to learn OCaml."
    (Books_template.render Ood.Book.all)
  |> Dream.html

let platform _req =
  Page_layout_template.render
    ~title:"Platform"
    ~description:
      "The OCaml Platform represents the best way for developers, both new and \
       old, to write software in OCaml."
    (Platform_template.render Ood.Tool.all)
  |> Dream.html

let problems _req =
  Page_layout_template.render
    ~title:"Problems"
    ~description:"???"
    (Problems_template.render Ood.Problem.all)
  |> Dream.html

let releases _req =
  Page_layout_template.render
    ~title:"Releases"
    ~description:"???"
    (Releases_template.render Ood.Release.all)
  |> Dream.html

let release req =
  let version = Dream.param "id" req in
  match Ood.Release.get_by_version version with
  | Some release ->
    Page_layout_template.render
      ~title:"Release"
      ~description:"???"
      (Release_template.render release)
    |> Dream.html
  | None ->
    not_found req

let tutorials _req =
  Page_layout_template.render
    ~title:"OCaml Tutorials · Learn OCaml by topic"
    ~description:
      "Start learning the OCaml language by topic with out official tutorial."
    (Tutorials_template.render ())
  |> Dream.html

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let tutorial req =
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
      (Tutorial_template.render
         (fun x -> slugify x.Ood.Tutorial.title)
         Ood.Tutorial.all
         tutorial)
    |> Dream.html
  | None ->
    not_found req
