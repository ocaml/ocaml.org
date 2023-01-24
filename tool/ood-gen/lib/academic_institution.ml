type location = { lat : float; long : float } [@@deriving of_yaml]

type course = {
  name : string;
  acronym : string option;
  online_resource : string option;
}
[@@deriving of_yaml]

type metadata = {
  name : string;
  description : string;
  url : string;
  logo : string option;
  continent : string;
  courses : course list;
  location : location option;
}
[@@deriving of_yaml]

type t = {
  name : string;
  slug : string;
  description : string;
  url : string;
  logo : string option;
  continent : string;
  courses : course list;
  location : location option;
  body_md : string;
  body_html : string;
}

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      {
        name = metadata.name;
        slug = Utils.slugify metadata.name;
        description = metadata.description;
        url = metadata.url;
        logo = metadata.logo;
        continent = metadata.continent;
        courses = metadata.courses;
        location = metadata.location;
        body_md = body;
        body_html = Omd.of_string body |> Omd.to_html;
      })
    "academic_institutions"

let pp_course ppf (v : course) =
  Fmt.pf ppf {|
  { name = %a
  ; acronym = %a
  ; online_resource  = %a
  }|}
    Pp.string v.name (Pp.option Pp.string) v.acronym (Pp.option Pp.string)
    v.online_resource

let pp_location ppf v =
  Fmt.pf ppf {|
  { long = %f
  ; lat = %f
  }
  |} v.long v.lat

let pp ppf v =
  Fmt.pf ppf
    {|
  { name = %a
  ; slug = %a
  ; description = %a
  ; url = %a
  ; logo = %a
  ; continent = %a
  ; courses = %a
  ; location = %a
  ; body_md = %a
  ; body_html = %a
  }|}
    Pp.string v.name Pp.string v.slug Pp.string v.description Pp.string v.url
    (Pp.option Pp.string) v.logo Pp.string v.continent (Pp.list pp_course)
    v.courses (Pp.option pp_location) v.location Pp.string v.body_md Pp.string
    v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type location = { lat : float; long : float }

type course =
  { name : string
  ; acronym : string option
  ; online_resource : string option
  }

type t =
  { name : string
  ; slug : string
  ; description : string
  ; url : string
  ; logo : string option
  ; continent : string
  ; courses : course list
  ; location : location option
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    pp_list (all ())
