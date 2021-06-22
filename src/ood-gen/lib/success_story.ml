type metadata = { title : string; image : string option; url : string option }
[@@deriving yaml]

type t = {
  title : string;
  slug : string;
  image : string option;
  url : string option;
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
        image = metadata.image;
        url = metadata.url;
        body_md = body;
        body_html = Omd.of_string body |> Omd.to_html;
      })
    "success_stories/en"

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %S
  ; slug = %S
  ; image = %a
  ; url = %a
  ; body_md = %S
  ; body_html = %S
  }|}
    v.title v.slug
    (Pp.option Pp.quoted_string)
    v.image
    (Pp.option Pp.quoted_string)
    v.url v.body_md v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; image : string option
  ; url : string option
  ; body_md : string
  ; body_html : string
  }
  
let all = %a
|}
    pp_list (all ())
