type role = [ `Chair | `Co_chair ]

let role_to_string = function `Chair -> "chair" | `Co_chair -> "co-chair"

let role_of_string = function
  | "chair" -> Ok `Chair
  | "co-chair" -> Ok `Co_chair
  | _ -> Error (`Msg "Unknown role type")

let role_of_yaml = function
  | `String s -> Result.bind (role_of_string s) (fun t -> Ok t)
  | _ -> Error (`Msg "Expected a string for a role type")

let role_to_yaml t = `String (role_to_string t)

type important_date = { date : string; info : string } [@@deriving of_yaml]

type committee_member = {
  name : string;
  role : role option;
  affiliation : string option;
  picture : string option;
}
[@@deriving of_yaml]

type presentation = {
  title : string;
  authors : string list;
  link : string option;
  video : string option;
  slides : string option;
  poster : bool option;
  additional_links : string list option;
}
[@@deriving of_yaml]

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

type t = {
  title : string;
  slug : string;
  location : string;
  date : string;
  important_dates : important_date list;
  presentations : presentation list;
  program_committee : committee_member list;
  organising_committee : committee_member list;
  toc_html : string;
  body_md : string;
  body_html : string;
}

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      let omd = Omd.of_string body in
      {
        title = metadata.title;
        slug = Utils.slugify metadata.title;
        location = metadata.location;
        date = metadata.date;
        important_dates = metadata.important_dates;
        presentations = metadata.presentations;
        program_committee = metadata.program_committee;
        organising_committee = metadata.organising_committee;
        toc_html = Omd.to_html (Omd.toc ~depth:4 omd);
        body_md = body;
        body_html = Omd.to_html omd;
      })
    "workshops/*.md"
  |> List.sort (fun w1 w2 -> String.compare w2.date w1.date)

let pp_role ppf = function
  | `Chair -> Fmt.string ppf "`Chair"
  | `Co_chair -> Fmt.string ppf "`Co_chair"

let pp_important_date ppf (v : important_date) =
  Fmt.pf ppf
    {|
  { date = %a;
    info = %a;
  }|}
    Pp.string v.date Pp.string v.info

let pp_committee_member ppf (v : committee_member) =
  Fmt.pf ppf
    {|
  { name = %a;
    role = %a;
    affiliation = %a;
    picture = %a;
  }|}
    Pp.string v.name
    Pp.(option pp_role)
    v.role
    Pp.(option string)
    v.affiliation
    Pp.(option string)
    v.picture

let pp_presentation ppf (v : presentation) =
  Fmt.pf ppf
    {|
  { title = %a;
    authors = %a;
    link = %a;
    video = %a;
    slides = %a;
    poster = %a;
    additional_links = %a;
  }|}
    Pp.string v.title Pp.string_list v.authors
    Pp.(option string)
    v.link
    Pp.(option string)
    v.video
    Pp.(option string)
    v.slides
    Pp.(option Fmt.bool)
    v.poster
    Pp.(option string_list)
    v.additional_links

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; location = %a
  ; date = %a
  ; important_dates = %a
  ; presentations = %a
  ; program_committee = %a
  ; organising_committee = %a
  ; body_md = %a
  ; toc_html = %a
  ; body_html = %a
  }|}
    Pp.string v.title Pp.string v.slug
    Pp.(string)
    v.location Pp.string v.date
    Pp.(list pp_important_date)
    v.important_dates
    Pp.(list pp_presentation)
    v.presentations
    Pp.(list pp_committee_member)
    v.program_committee
    Pp.(list pp_committee_member)
    v.organising_committee Pp.string v.body_md Pp.string v.toc_html Pp.string
    v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type role =
  [ `Chair
  | `Co_chair
  ]

type important_date = { date : string; info : string }

type committee_member = {
  name : string;
  role : role option;
  affiliation : string option;
  picture : string option;
}

type presentation = {
  title : string;
  authors : string list;
  link : string option;
  video : string option;
  slides : string option;
  poster : bool option;
  additional_links : string list option;
}

type t = {
  title : string;
  slug : string;
  location : string;
  date : string;
  important_dates : important_date list;
  presentations : presentation list;
  program_committee : committee_member list;
  organising_committee : committee_member list;
  toc_html : string;
  body_md : string;
  body_html : string;
}
  
let all = %a
|}
    pp_list (all ())
