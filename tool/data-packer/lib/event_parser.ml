(* Event parser - adapted from ood-gen/lib/event.ml *)

open Import

type event_type = [%import: Data_intf.Event.event_type] [@@deriving show]

let event_type_of_string = function
  | "meetup" -> Ok Meetup
  | "conference" -> Ok Conference
  | "seminar" -> Ok Seminar
  | "hackathon" -> Ok Hackathon
  | "retreat" -> Ok Retreat
  | s -> Error (`Msg ("Unknown event type: " ^ s))

let event_type_of_yaml = function
  | `String s -> event_type_of_string s
  | _ -> Error (`Msg "Expected a string for event type")

type location = [%import: Data_intf.Event.location] [@@deriving of_yaml, show]

type recurring_event = [%import: Data_intf.Event.recurring_event]
[@@deriving of_yaml, show]

type utc_datetime = [%import: Data_intf.Event.utc_datetime]
[@@deriving of_yaml, show]

type t = [%import: Data_intf.Event.t] [@@deriving show]

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
            Stdlib.List.find
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
                 "Event %s (%s) has no specified type and no linked recurring \
                  event"
                 metadata.title metadata.starts.yyyy_mm_dd)
        | Some event_type, None | None, Some event_type -> event_type
        | Some from_upcoming, Some from_recurring
          when from_upcoming <> from_recurring ->
            failwith
              (Printf.sprintf
                 "Event %s (%s) has type %s but its linked recurring event %s \
                  has type %s"
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
  |> Stdlib.List.sort (fun (e1 : t) (e2 : t) ->
         let t1 =
           e1.starts.yyyy_mm_dd ^ " "
           ^ Option.value ~default:"00:00" e1.starts.utc_hh_mm
         in
         let t2 =
           e2.starts.yyyy_mm_dd ^ " "
           ^ Option.value ~default:"00:00" e2.starts.utc_hh_mm
         in
         String.compare t1 t2)
