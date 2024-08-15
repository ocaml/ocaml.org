open Data_intf.Event

let recurring_event_all () : recurring_event list =
  Utils.yaml_sequence_file recurring_event_of_yaml "events/recurring.yml"

type metadata = {
  title : string;
  url : string;
  country : string;
  city : string;
  location : location option;
  submission_deadline : utc_datetime option;
  author_notification_date : utc_datetime option;
  starts : utc_datetime;
  ends : utc_datetime option;
  recurring_event_slug : string option;
  event_type : event_type option;
}
[@@deriving
  of_yaml,
    stable_record ~version:t
      ~add:[ slug; body_md; body_html; recurring_event ]
      ~remove:[ recurring_event_slug ] ~set:[ event_type ],
    show { with_path = false }]

let of_metadata m = metadata_to_t m ~slug:(Utils.slugify m.title)

let decode (recurring_events : recurring_event list) (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    Cmarkit.Doc.of_string body_md |> Cmarkit_html.of_doc ~safe:true
  in
  Result.map
    (fun metadata ->
      let recurring_event =
        Option.map
          (fun recurring_event_slug ->
            List.find
              (fun (recurring_event : recurring_event) ->
                recurring_event_slug = recurring_event.slug)
              recurring_events)
          metadata.recurring_event_slug
      in
      let recurring_event_type =
        Option.map (fun (re : recurring_event) -> re.event_type) recurring_event
      in
      let event_type =
        match (metadata.event_type, recurring_event_type) with
        | None, None ->
            failwith
              (Printf.sprintf
                 "Upcoming event %s (%s) has no specified type and no linked \
                  recurring event"
                 metadata.title metadata.starts.yyyy_mm_dd)
        | Some event_type, None | None, Some event_type -> event_type
        | Some from_upcoming, Some from_recurring
          when from_upcoming <> from_recurring ->
            failwith
              (Printf.sprintf
                 "Upcoming event %s (%s) has type %s but its linked recurring \
                  event %s has type %s"
                 metadata.title metadata.starts.yyyy_mm_dd
                 (show_event_type from_upcoming)
                 (Option.get metadata.recurring_event_slug)
                 (show_event_type from_recurring))
        | Some _, Some from_recurring -> from_recurring
      in
      of_metadata ~body_md ~body_html ~recurring_event ~event_type metadata)
    metadata

let all () =
  Utils.map_md_files (decode (recurring_event_all ())) "events/*.md"
  |> List.sort (fun (e1 : t) (e2 : t) ->
         (* Sort the events by start date. *)
         let t1 =
           e1.starts.yyyy_mm_dd ^ " "
           ^ Option.value ~default:"00:00" e1.starts.utc_hh_mm
         in
         let t2 =
           e2.starts.yyyy_mm_dd ^ " "
           ^ Option.value ~default:"00:00" e2.starts.utc_hh_mm
         in
         String.compare t1 t2)

module EventsFeed = struct
  let create_entry (log : t) =
    let authors = (Syndic.Atom.author "OCaml Events", []) in
    let event_type = show_event_type log.event_type in
    let textual_location = log.city ^ ", " ^ log.country in
    let start_date_str =
      log.starts.yyyy_mm_dd ^ "T"
      ^ Option.value ~default:"00:00" log.starts.utc_hh_mm
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
      Format.sprintf {|%s takes place in %s starting %s.|} log.title
        textual_location human_readable_date
    in
    let id = Uri.of_string (log.slug ^ " " ^ start_date_str) in
    Syndic.Atom.entry ~id ~authors
      ~title:(Syndic.Atom.Text (log.title ^ "  //  " ^ human_readable_date))
      ~updated:start_date
      ~links:[ Syndic.Atom.link (Uri.of_string log.url) ]
      ~categories:[ Syndic.Atom.category event_type ]
      ~content:(Syndic.Atom.Text content) ()

  let create_feed () =
    let open Rss in
    () |> all
    |> create_entries ~create_entry
    |> entries_to_feed ~id:"events.xml" ~title:"OCaml Events"
    |> feed_to_string
end

let template () =
  Format.asprintf
    {|
include Data_intf.Event
let recurring_event_all = %a
let all = %a
|}
    (Fmt.brackets (Fmt.list pp_recurring_event ~sep:Fmt.semi))
    (recurring_event_all ())
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
