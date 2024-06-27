type event_type = Meetup | Conference | Seminar | Hackathon | Retreat
[@@deriving show { with_path = false }]

let event_type_of_string = function
  | "meetup" -> Ok Meetup
  | "conference" -> Ok Conference
  | "seminar" -> Ok Seminar
  | "hackathon" -> Ok Hackathon
  | "retreat" -> Ok Retreat
  | s -> Error (`Msg ("Unknown event type: " ^ s))

let event_type_of_yaml = function
  | `String s -> event_type_of_string s
  | _ -> Error (`Msg "Expected a string for difficulty type")

type location = { lat : float; long : float }
[@@deriving of_yaml, show { with_path = false }]

type recurring_event = {
  title : string;
  url : string;
  slug : string;
  textual_location : string;
  location : location option;
  event_type : event_type;
}
[@@deriving of_yaml, show { with_path = false }]

let recurring_event_all () : recurring_event list =
  Utils.yaml_sequence_file recurring_event_of_yaml "events/recurring.yml"

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
  event_type : event_type option;
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
  recurring_event : recurring_event option;
  event_type : event_type;
}
[@@deriving
  stable_record ~version:metadata
    ~remove:[ slug; body_md; body_html; recurring_event ]
    ~add:[ recurring_event_slug ] ~set:[ event_type ],
    show { with_path = false }]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.title)

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

let template () =
  Format.asprintf
    {|
type event_type = Meetup | Conference | Seminar | Hackathon | Retreat
type location = { lat : float; long : float }

  type recurring_event = {
    slug : string
    ; title : string
    ; url : string
    ; textual_location : string
    ; location : location option
    ; event_type : event_type
  }

  let recurring_event_all = %a


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
  ; recurring_event : recurring_event option
  ; event_type : event_type
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp_recurring_event ~sep:Fmt.semi))
    (recurring_event_all ())
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
