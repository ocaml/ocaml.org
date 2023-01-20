type metadata = {
  title : string;
  logo : string;
  background : string;
  theme : string;
  synopsis : string;
  url : string;
}
[@@deriving of_yaml]

type t = {
  title : string;
  slug : string;
  logo : string;
  background : string;
  theme : string;
  synopsis : string;
  url : string;
  body_md : string;
  body_html : string;
}

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      {
        title = metadata.title;
        slug = Utils.slugify metadata.title;
        logo = metadata.logo;
        background = metadata.background;
        theme = metadata.theme;
        synopsis = metadata.synopsis;
        url = metadata.url;
        body_md = body;
        body_html = Omd.of_string body |> Omd.to_html;
      })
    "success_stories"

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; logo = %a
  ; background = %a
  ; theme = %a
  ; synopsis = %a
  ; url = %a
  ; body_md = %a
  ; body_html = %a
  }|}
    Pp.string v.title Pp.string v.slug Pp.string v.logo Pp.string v.background
    Pp.string v.theme Pp.string v.synopsis Pp.string v.url Pp.string v.body_md
    Pp.string v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; logo : string
  ; background : string
  ; theme : string
  ; synopsis : string
  ; url : string
  ; body_md : string
  ; body_html : string
  }
  
let all = %a
|}
    pp_list (all ())
