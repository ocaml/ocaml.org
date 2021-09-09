type metadata = { title : string; image : string option; url : string option }
[@@deriving yaml]

let path = Fpath.v "data/success_stories/en"

let parse content =
  let metadata, _ = Utils.extract_metadata_body content in
  metadata_of_yaml metadata

type t = {
  title : string;
  slug : string;
  image : string option;
  url : string option;
  body_md : string;
  body_html : string;
}

let all =
  Utils.map_files (fun content ->
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

let all_en () = all "success_stories/en"

let all_fr () = all "success_stories/fr"

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; image = %a
  ; url = %a
  ; body_md = %a
  ; body_html = %a
  }|}
    Pp.string v.title Pp.string v.slug (Pp.option Pp.string) v.image
    (Pp.option Pp.string) v.url Pp.string v.body_md Pp.string v.body_html

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
  
let all_en = %a

let all_fr = %a
|}
    pp_list (all_en ()) pp_list (all_fr ())
