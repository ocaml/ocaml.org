(* Feed generators for RSS/Atom feeds *)

open Data_intf

(* Helper to parse date - handles both YYYY-MM-DD and full RFC3339 formats *)
let parse_date date =
  let date_str =
    if String.contains date 'T' then date else date ^ "T00:00:00Z"
  in
  Syndic.Date.of_rfc3339 date_str

(* Helper to convert authors to Syndic format *)
let feed_authors authors =
  match List.map Syndic.Atom.author authors with
  | x :: xs -> (x, xs)
  | [] -> (Syndic.Atom.author "OCaml", [])

(* News feed *)
module News = struct
  let create_entry (post : News.t) =
    let content = Syndic.Atom.Html (None, post.body_html) in
    let id = Uri.of_string ("https://ocaml.org/news/" ^ post.slug) in
    let authors = feed_authors post.authors in
    let updated = parse_date post.date in
    Syndic.Atom.entry ~content ~id ~authors ~title:(Syndic.Atom.Text post.title)
      ~updated
      ~links:[ Syndic.Atom.link id ]
      ()

  let create_feed (all : News.t list) =
    Rss.create_entries ~create_entry ~days:90 all
    |> Rss.entries_to_feed ~id:"news.xml" ~title:"OCaml News @ OCaml.org"
    |> Rss.feed_to_string
end

(* Changelog feed *)
module Changelog = struct
  let create_entry (entry : Changelog.t) =
    match entry with
    | Release release ->
        let content = Syndic.Atom.Html (None, release.body_html) in
        let id =
          Uri.of_string ("https://ocaml.org/changelog/" ^ release.slug)
        in
        let updated = parse_date release.date in
        let authors = (Syndic.Atom.author "OCaml Changelog", []) in
        Syndic.Atom.entry ~content ~id ~authors
          ~title:(Syndic.Atom.Text release.title) ~updated
          ~links:[ Syndic.Atom.link id ]
          ()
    | Post post ->
        let content = Syndic.Atom.Html (None, post.body_html) in
        let id = Uri.of_string ("https://ocaml.org/changelog/" ^ post.slug) in
        let updated = parse_date post.date in
        let authors = feed_authors post.authors in
        Syndic.Atom.entry ~content ~id ~authors
          ~title:(Syndic.Atom.Text post.title) ~updated
          ~links:[ Syndic.Atom.link id ]
          ()

  let create_feed (all : Changelog.t list) =
    Rss.create_entries ~create_entry ~days:90 all
    |> Rss.entries_to_feed ~id:"changelog.xml" ~title:"OCaml Changelog"
    |> Rss.feed_to_string
end

(* Backstage feed *)
module Backstage = struct
  let create_entry (entry : Backstage.t) =
    match entry with
    | Release release ->
        let content = Syndic.Atom.Html (None, release.body_html) in
        let id =
          Uri.of_string ("https://ocaml.org/backstage/" ^ release.slug)
        in
        let updated = parse_date release.date in
        let authors = (Syndic.Atom.author "OCaml Backstage", []) in
        Syndic.Atom.entry ~content ~id ~authors
          ~title:(Syndic.Atom.Text release.title) ~updated
          ~links:[ Syndic.Atom.link id ]
          ()
    | Post post ->
        let content = Syndic.Atom.Html (None, post.body_html) in
        let id = Uri.of_string ("https://ocaml.org/backstage/" ^ post.slug) in
        let updated = parse_date post.date in
        let authors = feed_authors post.authors in
        Syndic.Atom.entry ~content ~id ~authors
          ~title:(Syndic.Atom.Text post.title) ~updated
          ~links:[ Syndic.Atom.link id ]
          ()

  let create_feed (all : Backstage.t list) =
    Rss.create_entries ~create_entry ~days:90 all
    |> Rss.entries_to_feed ~id:"backstage.xml" ~title:"OCaml Backstage"
    |> Rss.feed_to_string
end

(* Events feed *)
module Events = struct
  let create_entry (event : Event.t) =
    let textual_location = event.city ^ ", " ^ event.country in
    let start_date_str =
      event.starts.yyyy_mm_dd ^ "T"
      ^ Option.value ~default:"00:00" event.starts.utc_hh_mm
      ^ ":00Z"
    in
    let start_date = Syndic.Date.of_rfc3339 start_date_str in
    let human_readable_date =
      Format.sprintf "%s %d, %d"
        (Syndic.Date.month start_date |> Syndic.Date.string_of_month)
        (Syndic.Date.day start_date)
        (Syndic.Date.year start_date)
    in
    let content =
      Syndic.Atom.Text
        (Format.sprintf "%s takes place in %s starting %s." event.title
           textual_location human_readable_date)
    in
    let id = Uri.of_string (event.slug ^ " " ^ start_date_str) in
    let authors = (Syndic.Atom.author "OCaml Events", []) in
    Syndic.Atom.entry ~content ~id ~authors
      ~title:(Syndic.Atom.Text (event.title ^ "  //  " ^ human_readable_date))
      ~updated:start_date
      ~links:[ Syndic.Atom.link (Uri.of_string event.url) ]
      ()

  let create_feed (all : Event.t list) =
    Rss.create_entries ~create_entry ~days:365 all
    |> Rss.entries_to_feed ~id:"events.xml" ~title:"OCaml Events"
    |> Rss.feed_to_string
end

(* Job feed *)
module Job = struct
  let create_entry (job : Job.t) =
    let locations = String.concat ", " job.locations in
    let content =
      Syndic.Atom.Html
        ( None,
          Printf.sprintf "<p>%s at %s</p><p>Location: %s</p>" job.title
            job.company locations )
    in
    let id = Uri.of_string job.link in
    let updated =
      match job.publication_date with
      | Some date -> parse_date date
      | None ->
          Syndic.Date.of_rfc3339
            (Ptime.to_rfc3339
               (Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get))
    in
    let authors = (Syndic.Atom.author job.company, []) in
    Syndic.Atom.entry ~content ~id ~authors
      ~title:(Syndic.Atom.Text (job.title ^ " at " ^ job.company))
      ~updated
      ~links:[ Syndic.Atom.link (Uri.of_string job.link) ]
      ()

  let create_feed (all : Job.t list) =
    Rss.create_entries ~create_entry ~days:90 all
    |> Rss.entries_to_feed ~id:"jobs.xml" ~title:"OCaml Jobs"
    |> Rss.feed_to_string
end

(* Planet feed - aggregates blog posts and videos *)
module Planet = struct
  let create_entry (entry : Planet.entry) =
    match entry with
    | BlogPost post ->
        let content =
          Syndic.Atom.Text (Option.value ~default:"" post.description)
        in
        let id = Uri.of_string post.url in
        let authors =
          match List.map Syndic.Atom.author post.authors with
          | x :: xs -> (x, xs)
          | [] -> (Syndic.Atom.author post.source.name, [])
        in
        let updated = parse_date post.date in
        Syndic.Atom.entry ~content ~id ~authors
          ~title:(Syndic.Atom.Text post.title) ~updated
          ~links:[ Syndic.Atom.link id ]
          ()
    | Video video ->
        let content =
          Syndic.Atom.Html
            ( None,
              Printf.sprintf {|<p>%s</p><p><a href="%s">Watch video</a></p>|}
                video.description video.url )
        in
        let id = Uri.of_string video.url in
        let authors =
          if video.author_name <> "" then
            (Syndic.Atom.author video.author_name, [])
          else (Syndic.Atom.author "OCaml", [])
        in
        let updated = Syndic.Date.of_rfc3339 video.published in
        Syndic.Atom.entry ~content ~id ~authors
          ~title:(Syndic.Atom.Text video.title) ~updated
          ~links:[ Syndic.Atom.link id ]
          ()

  let create_feed (all : Planet.entry list) =
    Rss.create_entries ~create_entry ~days:90 all
    |> Rss.entries_to_feed ~id:"planet.xml" ~title:"OCaml Planet"
    |> Rss.feed_to_string
end
