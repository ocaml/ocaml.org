type metadata = {
  title : string;
  description : string;
  meta_title : string;
  meta_description : string;
}
[@@deriving of_yaml]

type t = {
  slug : string;
  title : string;
  description : string;
  meta_title : string;
  meta_description : string;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ slug; body_md; body_html ]]

let decode (file, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let omd = Omd.of_string body_md in
  let body_html = Omd.to_html (Hilite.Md.transform omd) in
  let slug =
    file |> Filename.basename |> Filename.remove_extension
    |> String.map (function '_' -> '-' | c -> c)
  in
  Result.map (of_metadata ~slug ~body_md ~body_html) metadata

let all () = Utils.map_files decode "pages/*.md"

let pp ppf v =
  Fmt.pf ppf
    {|
  { slug = %a
  ; title = %a
  ; description = %a
  ; meta_title = %a
  ; meta_description = %a
  ; body_md = %a
  ; body_html = %a
  }
|}
    Pp.string v.slug Pp.string v.title Pp.string v.description Pp.string
    v.meta_title Pp.string v.meta_description Pp.string v.body_md Pp.string
    v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|

type t =
  { slug : string
  ; title : string
  ; description : string
  ; meta_title : string
  ; meta_description : string
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    pp_list (all ())
