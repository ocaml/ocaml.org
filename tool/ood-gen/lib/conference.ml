type role = [%import: Data_intf.Conference.role] [@@deriving show]

let role_of_string = function
  | "chair" -> Ok `Chair
  | "co-chair" -> Ok `Co_chair
  | s -> Error (`Msg ("Unknown role type: " ^ s))

let role_of_yaml = function
  | `String s -> role_of_string s
  | _ -> Error (`Msg "Expected a string for role type")

type important_date = [%import: Data_intf.Conference.important_date]
[@@deriving of_yaml, show]

type committee_member = [%import: Data_intf.Conference.committee_member]
[@@deriving of_yaml, show]

type presentation = [%import: Data_intf.Conference.presentation]
[@@deriving of_yaml, show]

type t = [%import: Data_intf.Conference.t] [@@deriving of_yaml, show]

type presentation_metadata = {
  title : string;
  authors : string list;
  link : string option;
  watch_ocamlorg_video : string option;
  youtube_video : string option;
  slides : string option;
  poster : bool option;
  additional_links : string list option;
}
[@@deriving
  of_yaml,
    stable_record ~version:presentation ~modify:[ poster; additional_links ]]

type metadata = {
  title : string;
  location : string;
  date : string;
  important_dates : important_date list;
  presentations : presentation_metadata list;
  program_committee : committee_member list;
  organising_committee : committee_member list;
}
[@@deriving
  of_yaml,
    stable_record ~version:t
      ~add:[ slug; body_md; body_html ]
      ~modify:[ presentations ]]

let of_presentation_metadata pm =
  presentation_metadata_to_presentation pm
    ~modify_poster:(Option.value ~default:false)
    ~modify_additional_links:(Option.value ~default:[])

let of_metadata m =
  metadata_to_t m ~slug:(Utils.slugify m.title)
    ~modify_presentations:(List.map of_presentation_metadata)

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    body_md |> Markdown.Content.of_string |> Markdown.Content.render
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () =
  Utils.map_md_files decode "conferences/*.md"
  |> List.sort (fun (w1 : t) (w2 : t) -> String.compare w2.date w1.date)

let template () =
  Format.asprintf {|
include Data_intf.Conference
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
