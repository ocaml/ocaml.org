(* News parser - adapted from ood-gen/lib/news.ml *)

open Import

type t = [%import: Data_intf.News.t] [@@deriving show]

type metadata = {
  title : string;
  description : string;
  date : string;
  tags : string list;
  authors : string list option;
}
[@@deriving
  of_yaml, stable_record ~version:t ~add:[ slug; body_html ] ~modify:[ authors ]]

let of_metadata m = metadata_to_t m ~modify_authors:(Option.value ~default:[])

let decode (fpath, (head, body)) =
  let ( let* ) = Result.bind in
  let* metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let slug = Filename.basename fpath |> Filename.remove_extension in
  let body_html =
    Markdown.Content.(of_string body |> render ~syntax_highlighting:true)
  in
  Ok (of_metadata ~slug ~body_html metadata)

let all () =
  Utils.map_md_files decode "news/*/*.md"
  |> List.sort (fun (n1 : t) (n2 : t) ->
         (* Sort by date descending *)
         String.compare n2.date n1.date)
