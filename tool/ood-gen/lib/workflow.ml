type metadata = { title : string } [@@deriving of_yaml]

type t = { title : string; body_md : string; body_html : string }
[@@deriving stable_record ~version:metadata ~remove:[ body_md; body_html ]]

let decode (_, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let body_html = Omd.of_string body_md |> Hilite.Md.transform |> Omd.to_html in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () = Utils.map_files decode "workflows/*.md"

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
