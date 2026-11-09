(* Conference parser - adapted from ood-gen/lib/conference.ml *)

open Import
open Data_intf.Conference

type role = Data_intf.Conference.role

let role_of_string = function
  | "chair" -> Ok `Chair
  | "co-chair" -> Ok `Co_chair
  | s -> Error (`Msg ("Unknown role: " ^ s))

let role_of_yaml = function
  | `String s -> role_of_string s
  | _ -> Error (`Msg "Expected string for role")

type important_date = [%import: Data_intf.Conference.important_date]
[@@deriving of_yaml]

type committee_member = [%import: Data_intf.Conference.committee_member]
[@@deriving of_yaml]

type presentation = Data_intf.Conference.presentation

(* Intermediate type for parsing presentations *)
type presentation_metadata = {
  title : string;
  authors : string list;
  link : string option;
  watch_ocamlorg_video : string option;
  youtube_video : string option;
  slides : string option;
  poster : bool; [@default false]
  additional_links : string list; [@default []]
}
[@@deriving of_yaml]

let presentation_of_yaml yaml =
  let ( let* ) = Result.bind in
  let* m = presentation_metadata_of_yaml yaml in
  Ok
    {
      Data_intf.Conference.title = m.title;
      authors = m.authors;
      link = m.link;
      watch_ocamlorg_video = m.watch_ocamlorg_video;
      youtube_video = m.youtube_video;
      slides = m.slides;
      poster = m.poster;
      additional_links = m.additional_links;
    }

type t = Data_intf.Conference.t

type metadata = {
  title : string;
  location : string;
  date : string;
  important_dates : important_date list;
  presentations : presentation list;
  program_committee : committee_member list;
  organising_committee : committee_member list;
}
[@@deriving of_yaml]

let of_metadata ~body_md ~body_html
    ({
       title;
       location;
       date;
       important_dates;
       presentations;
       program_committee;
       organising_committee;
     } :
      metadata) : t =
  {
    title;
    slug = Utils.slugify title;
    location;
    date;
    important_dates;
    presentations;
    program_committee;
    organising_committee;
    body_md;
    body_html;
  }

let decode (fpath, (head, body)) =
  let ( let* ) = Result.bind in
  let* metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_md = String.trim body in
  let body_html = Markdown.Content.(of_string body_md |> render) in
  Ok (of_metadata ~body_md ~body_html metadata)

let all () =
  Utils.map_md_files decode "conferences/*.md"
  |> List.sort (fun (c1 : t) (c2 : t) ->
         (* Sort by date descending *)
         String.compare c2.date c1.date)
