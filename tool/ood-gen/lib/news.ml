open Data_intf.News

type metadata = {
  title : string;
  description : string;
  date : string;
  tags : string list;
  authors : string list option;
}
[@@deriving
  of_yaml, stable_record ~version:t ~modify:[ authors ] ~add:[ slug; body_html ]]

let of_metadata m = metadata_to_t m ~modify_authors:(Option.value ~default:[])

let decode (fname, (head, body)) =
  let slug = Filename.basename (Filename.remove_extension fname) in
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fname)
  in
  let body_html =
    body |> Markdown.Content.of_string
    |> Markdown.Content.render ~syntax_highlighting:true
  in
  Result.map (of_metadata ~slug ~body_html) metadata

let all () =
  Utils.map_md_files decode "news/*/*.md"
  |> List.sort (fun (a : t) (b : t) -> String.compare b.date a.date)

let template () =
  Format.asprintf {|
include Data_intf.News
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
