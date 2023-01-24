type metadata = { title : string } [@@deriving of_yaml]
type t = { title : string; body_md : string; body_html : string }

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      {
        title = metadata.title;
        body_md = body;
        body_html = Omd.of_string body |> Hilite.Md.transform |> Omd.to_html;
      })
    "workflows/*.md"

let pp ppf v =
  Fmt.pf ppf {|
  { title = %S
  ; body_md = %S
  ; body_html = %S
  }|} v.title
    v.body_md v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    pp_list (all ())
