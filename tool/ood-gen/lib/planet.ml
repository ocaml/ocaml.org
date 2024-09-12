open Ocamlorg.Import
open Data_intf.Planet

let all () =
  let external_posts =
    Blog.Post.all () |> List.map (fun (p : Data_intf.Blog.Post.t) -> BlogPost p)
  in
  let videos =
    Video.all () |> List.map (fun (v : Data_intf.Video.t) -> Video v)
  in
  external_posts @ videos
  |> List.sort (fun (a : entry) (b : entry) ->
         String.compare (date_of_post b) (date_of_post a))

let template () =
  Format.asprintf {ocaml|
include Data_intf.Planet
let all = %a
|ocaml}
    (Fmt.brackets (Fmt.list pp_entry ~sep:Fmt.semi))
    (all ())

module GlobalFeed = struct
  let feed_authors (source : Data_intf.Blog.source) authors =
    match List.map Syndic.Atom.author authors with
    | x :: xs -> (x, xs)
    | [] -> (Syndic.Atom.author source.name, [])

  let create_events_announcement_entry () =
    let now = Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get in
    let year, month, day = now |> Ptime.to_date in

    let start =
      Ptime.of_date (year, month, min 22 ((day / 7 * 7) + 1)) |> Option.get
      (* choose a day between 1, 8, 15, 22 so that reminders are sent out four
         times a month*)
    in
    let start_rfc3999 = start |> Ptime.to_rfc3339 in

    let events =
      let cutoff =
        Ptime.add_span start (Ptime.Span.v (90, 0L))
        |> Option.get |> Ptime.to_rfc3339
      in
      Event.all ()
      |> List.filter (fun (e : Data_intf.Event.t) ->
             String.compare e.starts.yyyy_mm_dd start_rfc3999 > 0
             && String.compare e.starts.yyyy_mm_dd cutoff < 0)
    in

    match events with
    | [] -> None
    | _ ->
        let human_readable_date =
          Format.sprintf "%s %d, %d"
            (Syndic.Date.month start |> Syndic.Date.string_of_month)
            (Syndic.Date.day start) (Syndic.Date.year start)
        in
        let authors = (Syndic.Atom.author "OCaml Events", []) in
        let render_single_event (event : Data_intf.Event.t) =
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
            Format.sprintf {|<li><a href="%s">%s // %s // %s</a></li>
|}
              event.url event.title textual_location human_readable_date
          in
          content
        in

        let content =
          events
          |> List.map render_single_event
          |> String.concat "\n"
          |> Format.sprintf {|<ul>%s</ul>|}
        in

        let id =
          let id_date_str =
            Format.sprintf "%s-%d-%d"
              (Syndic.Date.month start |> Syndic.Date.string_of_month)
              (Syndic.Date.day start) (Syndic.Date.year start)
          in

          Uri.of_string ("https://ocaml.org/events#" ^ id_date_str)
        in
        Some
          (Syndic.Atom.entry ~id ~authors
             ~title:
               (Syndic.Atom.Text
                  ("Upcoming OCaml Events (" ^ human_readable_date
                 ^ " and onwards)"))
             ~updated:start
             ~links:
               [ Syndic.Atom.link (Uri.of_string "https://ocaml.org/events") ]
             ~categories:[ Syndic.Atom.category "events" ]
             ~content:(Syndic.Atom.Html (None, content))
             ())

  let entry_of_post (post : Data_intf.Blog.Post.t) =
    let content = Syndic.Atom.Html (None, post.body_html) in
    let url = Uri.of_string post.source.url in
    let source : Syndic.Atom.source =
      Syndic.Atom.source ~authors:[] ~id:url
        ~title:(Syndic.Atom.Text post.source.name)
        ~links:[ Syndic.Atom.link url ]
        ?updated:None ?categories:None ?contributors:None ?generator:None
        ?icon:None ?logo:None ?rights:None ?subtitle:None
    in
    let id = Uri.of_string post.url in
    let authors = feed_authors post.source post.authors in
    let updated = Syndic.Date.of_rfc3339 post.date in
    Syndic.Atom.entry ~content ~source ~id ~authors
      ~title:(Syndic.Atom.Text post.title) ~updated
      ~links:[ Syndic.Atom.link id ]
      ()

  let entry_of_video (video : Data_intf.Video.t) =
    let url = Uri.of_string video.url in
    let source : Syndic.Atom.source =
      Syndic.Atom.source ~authors:[]
        ~id:(Uri.of_string video.source_link)
        ~title:(Syndic.Atom.Text video.source_title)
        ~links:[ Syndic.Atom.link (Uri.of_string video.source_link) ]
        ?updated:None ?categories:None ?contributors:None ?generator:None
        ?icon:None ?logo:None ?rights:None ?subtitle:None
    in
    let content = Syndic.Atom.Text video.description in
    let id = url in
    let authors =
      ( Syndic.Atom.author
          ~uri:(Uri.of_string video.author_uri)
          video.author_name,
        [] )
    in
    let updated = Syndic.Date.of_rfc3339 video.published in
    Syndic.Atom.entry ~content ~source ~id ~authors
      ~title:(Syndic.Atom.Text video.title) ~updated
      ~links:[ Syndic.Atom.link id ]
      ()

  let create_entry (post : entry) =
    match post with
    | BlogPost post -> entry_of_post post
    | Video video -> entry_of_video video

  let create_feed () =
    let open Rss in
    let entries = all () |> create_entries ~create_entry ~days:90 in

    match create_events_announcement_entry () with
    | None ->
        entries
        |> entries_to_feed ~id:"planet.xml" ~title:"The OCaml Planet"
        |> feed_to_string
    | Some event_announcements ->
        entries @ [ event_announcements ]
        |> entries_to_feed ~id:"planet.xml" ~title:"The OCaml Planet"
        |> feed_to_string
end
