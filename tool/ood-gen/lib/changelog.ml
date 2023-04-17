type metadata = {
  title : string;
  date : string;
  tags : string list;
  authors : string list option;
  description : string option;
  changelog : string option;
}
[@@deriving of_yaml]

type t = {
  title : string;
  date : string;
  slug : string;
  tags : string list;
  changelog_html : string option;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata
    ~add:[ authors; changelog; description ]
    ~remove:[ slug; changelog_html; body_html ],
    show { with_path = false }]

let decode (fname, (head, body)) =
  let slug = Filename.basename (Filename.remove_extension fname) in
  let metadata = metadata_of_yaml head in
  let body_html =
    Omd.to_html (Hilite.Md.transform (Omd.of_string (String.trim body)))
  in

  Result.map
    (fun metadata ->
      let changelog_html =
        match metadata.changelog with
        | None -> None
        | Some changelog ->
            Some
              (Omd.to_html
                 (Hilite.Md.transform (Omd.of_string (String.trim changelog))))
      in
      of_metadata ~slug ~changelog_html ~body_html metadata)
    metadata

let all () =
  Utils.map_files decode "changelog/*/*.md"
  |> List.sort (fun a b -> String.compare b.date a.date)

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; date : string
  ; tags : string list
  ; changelog_html : string option
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
