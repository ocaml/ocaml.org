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
[@@deriving
  stable_record ~version:metadata ~remove:[ slug; body_md; body_html ]]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.title)

let decode (head, body_md) =
  let metadata = metadata_of_yaml head in
  let body_html = Omd.of_string body_md |> Omd.to_html in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () = Utils.map_files decode "success_stories"

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
