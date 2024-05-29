module EventType = struct
  type t = Meetup | Conference | Seminar | Hackathon | Retreat
  [@@deriving show { with_path = false }]

  let of_string = function
    | "meetup" -> Ok Meetup
    | "conference" -> Ok Conference
    | "seminar" -> Ok Seminar
    | "hackathon" -> Ok Hackathon
    | "retreat" -> Ok Retreat
    | s -> Error (`Msg ("Unknown event type: " ^ s))

  let of_yaml = Utils.of_yaml of_string "Expected a string for difficulty type"
end

type location = { lat : float; long : float }
[@@deriving of_yaml, show { with_path = false }]

module RecurringEvent = struct
  type metadata = {
    slug : string;
    title : string;
    url : string;
    textual_location : string;
    location : location option;
    event_type : EventType.t;
  }
  [@@deriving of_yaml, show { with_path = false }]

  type t = {
    title : string;
    url : string;
    slug : string;
    textual_location : string;
    location : location option;
    event_type : EventType.t;
  }
  [@@deriving stable_record ~version:metadata, show { with_path = false }]

  let decode s =
    let metadata = metadata_of_yaml s in
    Result.map of_metadata metadata

  let all () : t list = Utils.yaml_sequence_file decode "events/recurring.yml"
end

type utc_datetime = { yyyy_mm_dd : string; utc_hh_mm : string option }
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  title : string;
  url : string;
  textual_location : string;
  location : location option;
  starts : utc_datetime;
  ends : utc_datetime option;
  recurring_event_slug : string option;
  event_type : EventType.t option;
}
[@@deriving of_yaml, show { with_path = false }]

type t = {
  title : string;
  url : string;
  slug : string;
  textual_location : string;
  location : location option;
  starts : utc_datetime;
  ends : utc_datetime option;
  body_md : string;
  body_html : string;
  recurring_event : RecurringEvent.t option;
  event_type : EventType.t;
}
[@@deriving
  stable_record ~version:metadata
    ~remove:[ slug; body_md; body_html; recurring_event ]
    ~add:[ recurring_event_slug ] ~set:[ event_type ],
    show { with_path = false }]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.title)

let decode (recurring_events : RecurringEvent.t list) (fpath, (head, body_md)) =
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
              (fun (recurring_event : RecurringEvent.t) ->
                recurring_event_slug = recurring_event.slug)
              recurring_events)
          metadata.recurring_event_slug
      in
      let recurring_event_type =
        Option.map
          (fun (re : RecurringEvent.t) -> re.event_type)
          recurring_event
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
                 (EventType.show from_upcoming)
                 (Option.get metadata.recurring_event_slug)
                 (EventType.show from_recurring))
        | Some _, Some from_recurring -> from_recurring
      in
      of_metadata ~body_md ~body_html ~recurring_event ~event_type metadata)
    metadata

let all () =
  Utils.map_files (decode (RecurringEvent.all ())) "events/*.md"
  |> List.sort (fun e1 e2 ->
         (* Sort the events by reversed start date. *)
         let t1 =
           e1.starts.yyyy_mm_dd ^ " "
           ^ Option.value ~default:"00:00" e1.starts.utc_hh_mm
         in
         let t2 =
           e2.starts.yyyy_mm_dd ^ " "
           ^ Option.value ~default:"00:00" e2.starts.utc_hh_mm
         in
         String.compare t2 t1)

module EventsFeed = struct
  let create_changelog_feed () =
    let id = Uri.of_string "https://ocaml.org/events.xml" in
    let title : Syndic.Atom.title = Text "OCaml Events" in
    let now = Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get in
    let cutoff_date =
      Ptime.sub_span now (Ptime.Span.v (365, 0L)) |> Option.get
    in

    let entries =
      all ()
      |> List.map (fun (log : t) ->
             let authors = (Syndic.Atom.author "Ocaml.org", []) in
             let event_type = EventType.show log.event_type in
             let textual_location = log.textual_location in
             let start_date =
               Syndic.Date.of_rfc3339
                 (log.starts.yyyy_mm_dd ^ "T"
                 ^ Option.value ~default:"00:00" log.starts.utc_hh_mm
                 ^ ":00Z")
             in
             let start_date_str = Syndic.Date.to_rfc3339 start_date in
             let id = Uri.of_string (log.slug ^ " " ^ start_date_str) in
             let location_summary =
               match log.location with
               | Some { lat; long } ->
                   Printf.sprintf "%s (lat: %f, long: %f)" textual_location lat
                     long
               | None -> textual_location
             in
             Syndic.Atom.entry ~id ~authors
               ~title:(Syndic.Atom.Text (log.title ^ " " ^ start_date_str))
               ~updated:start_date
               ~links:[ Syndic.Atom.link (Uri.of_string log.url) ]
               ~categories:[ Syndic.Atom.category event_type ]
               ~content:(Syndic.Atom.Text location_summary) ())
      |> List.filter (fun (entry : Syndic.Atom.entry) ->
             Ptime.is_later entry.updated ~than:cutoff_date)
      |> List.sort Syndic.Atom.descending
    in

    let updated = (List.hd entries).updated in
    Syndic.Atom.feed ~id ~title ~updated entries

  let create_feed () =
    create_changelog_feed () |> Syndic.Atom.to_xml
    |> Syndic.XML.to_string ~ns_prefix:(fun s ->
           match s with "http://www.w3.org/2005/Atom" -> Some "" | _ -> None)
end

let template () =
  Format.asprintf
    {|
type event_type = Meetup | Conference | Seminar | Hackathon | Retreat
type location = { lat : float; long : float }

module RecurringEvent = struct
  type t = {
    slug : string
    ; title : string
    ; url : string
    ; textual_location : string
    ; location : location option
    ; event_type : event_type
  }

  let all = %a
end

type utc_datetime = {
  yyyy_mm_dd: string;
  utc_hh_mm: string option;
}

type t =
  { title : string
  ; url : string
  ; slug : string
  ; textual_location : string
  ; location : location option
  ; starts : utc_datetime
  ; ends : utc_datetime option
  ; body_md : string
  ; body_html : string
  ; recurring_event : RecurringEvent.t option
  ; event_type : event_type
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list RecurringEvent.pp ~sep:Fmt.semi))
    (RecurringEvent.all ())
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
