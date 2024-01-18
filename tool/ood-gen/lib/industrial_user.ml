type metadata = {
  name : string;
  description : string;
  logo : string option;
  url : string;
  locations : string list;
  consortium : bool;
  featured : bool;
}
[@@deriving of_yaml]

type t = {
  name : string;
  slug : string;
  description : string;
  logo : string option;
  url : string;
  locations : string list;
  consortium : bool;
  featured : bool;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ slug; body_md; body_html ],
    show { with_path = false }]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.name)

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    Cmarkit.Doc.of_string ~strict:true body_md |> Cmarkit_html.of_doc ~safe:true
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () = Utils.map_files decode "industrial_users"

let template () =
  Format.asprintf
    {|
type t =
  { name : string
  ; slug : string
  ; description : string
  ; logo : string option
  ; url : string
  ; locations : string list
  ; consortium : bool
  ; featured : bool
  ; body_md : string
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
