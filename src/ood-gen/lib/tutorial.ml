type proficiency = [ `Beginner | `Intermediate | `Advanced ]

type metadata = {
  title : string;
  description : string;
  date : string;
  tags : string list;
  users : string list;
}
[@@deriving yaml]

type t = {
  title : string;
  description : string;
  date : string;
  tags : string list;
  users : proficiency list;
  body_md : string;
  body_html : string;
}

let proficiency_list_of_string_list =
  List.map (fun x ->
      match Meta.Proficiency.of_string x with
      | Ok x -> x
      | Error (`Msg err) -> raise (Exn.Decode_error err))

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      {
        title = metadata.title;
        description = metadata.description;
        date = metadata.date;
        tags = metadata.tags;
        users = proficiency_list_of_string_list metadata.users;
        body_md = body;
        body_html = Omd.of_string body |> Omd.to_html;
      })
    "tutorials/en/*.md"

let pp_proficiency ppf v =
  Fmt.pf ppf "%s"
    ( match v with
    | `Beginner -> "`Beginner"
    | `Intermediate -> "`Intermediate"
    | `Advanced -> "`Advanced" )

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %S
  ; description = %S
  ; date = %S
  ; tags = %a
  ; users = %a
  ; body_md = %S
  ; body_html = %S
  }|}
    v.title v.description v.date Pp.string_list v.tags (Pp.list pp_proficiency)
    v.users v.body_md v.body_html

let pp_list = Pp.list pp

let template =
  Format.asprintf
    {|
type difficulty =
  [ `Beginner
  | `Intermediate
  | `Advanced
  ]

type t =
  { title : string
  ; description : string
  ; date : string
  ; tags : string list
  ; users : difficulty list
  ; body_md : string
  ; body_html : string
  }
  
let all = %a
|}
    pp_list (all ())
