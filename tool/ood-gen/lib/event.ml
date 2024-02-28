type location = { lat : float; long : float }
[@@deriving of_yaml, show { with_path = false }]

module RecurringEvent = struct
  type metadata = {
    slug : string;
    title : string;
    url : string;
    textual_location : string;
    location : location option;
  }
  [@@deriving of_yaml, show { with_path = false }]

  type t = {
    title : string;
    url : string;
    slug : string;
    textual_location : string;
    location : location option;
  }
  [@@deriving stable_record ~version:metadata, show { with_path = false }]

  let decode s =
    let metadata = metadata_of_yaml s in
    Result.map of_metadata metadata

  let all () : t list = Utils.yaml_sequence_file decode "events/recurring.yml"
end

type metadata = {
  title : string;
  url : string;
  textual_location : string;
  location : location option;
  starts : string;
  ends : string option;
  recurring_event_slug : string option;
}
[@@deriving of_yaml, show { with_path = false }]

type t = {
  title : string;
  url : string;
  slug : string;
  textual_location : string;
  location : location option;
  starts : string;
  ends : string option;
  body_md : string;
  body_html : string;
  recurring_event : RecurringEvent.t option;
}
[@@deriving
  stable_record ~version:metadata
    ~remove:[ slug; body_md; body_html; recurring_event ]
    ~add:[ recurring_event_slug ],
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

      of_metadata ~body_md ~body_html ~recurring_event metadata)
    metadata

let all () =
  Utils.map_files (decode (RecurringEvent.all ())) "events/*.md"
  |> List.sort (fun e1 e2 ->
         (* Sort the events by reversed start date. *)
         String.compare e2.starts e1.starts)

let template () =
  Format.asprintf
    {|
type location = { lat : float; long : float }

module RecurringEvent = struct
  type t = {
    slug : string
    ; title : string
    ; url : string
    ; textual_location : string
    ; location : location option
  }

  let all = %a
end

type t =
  { title : string
  ; url : string
  ; slug : string
  ; textual_location : string
  ; location : location option
  ; starts : string
  ; ends : string option
  ; body_md : string
  ; body_html : string
  ; recurring_event : RecurringEvent.t option
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list RecurringEvent.pp ~sep:Fmt.semi))
    (RecurringEvent.all ())
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
