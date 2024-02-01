type metadata = {
  title : string;
  problem : string;
  category : string;
  packages : string list;
}
[@@deriving of_yaml]

type t = {
  group_id : string;
  slug : string;
  title : string;
  problem : string;
  category : string;
  packages : string list;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ slug; group_id; body_html ],
    show { with_path = false }]

let decode (fname, (head, body)) =
  let group_id = Filename.basename (Filename.dirname fname) in
  let name = Filename.basename (Filename.remove_extension fname) in
  let id = String.sub name 3 (String.length name - 3) in
  let slug = group_id ^ "-" ^ id in
  let metadata = metadata_of_yaml head in
  let body_html =
    Cmarkit_html.of_doc ~safe:false
      (Hilite.Md.transform
         (Cmarkit.Doc.of_string ~strict:true (String.trim body)))
  in
  Result.map
    (fun metadata -> of_metadata ~slug ~group_id ~body_html metadata)
    metadata

let all () =
  Utils.map_files decode "cookbook/*/*.md"
  |> List.sort (fun a b -> String.compare b.slug a.slug)

let template () =
  Format.asprintf
    {|
type t =
  { slug: string
  ; group_id: string
  ; title : string
  ; problem : string
  ; category : string
  ; packages : string list
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
