type metadata = {
  title : string;
  description : string;
  date : string;
  tags : string list;
  authors : string list option;
}
[@@deriving of_yaml]

type t = {
  title : string;
  description : string;
  date : string;
  slug : string;
  tags : string list;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~add:[ authors ] ~remove:[ slug; body_html ]]

let decode (file, (head, body)) =
  let slug = Filename.basename (Filename.remove_extension file) in
  let metadata = metadata_of_yaml head in
  let body_html =
    Omd.to_html (Hilite.Md.transform (Omd.of_string (String.trim body)))
  in
  Result.map (of_metadata ~slug ~body_html) metadata

let all () =
  Utils.map_files decode "news/*/*.md"
  |> List.sort (fun a b -> String.compare b.date a.date)

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; description = %a
  ; date = %a
  ; tags = %a
  ; body_html = %a
  }|}
    Pp.string v.title Pp.string v.slug Pp.string v.description Pp.string v.date
    (Pp.list Pp.string) v.tags Pp.string v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; description : string
  ; date : string
  ; tags : string list
  ; body_html : string
  }
  
let all = %a
|}
    pp_list (all ())
