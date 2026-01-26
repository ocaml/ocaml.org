(* Book parser - adapted from ood-gen/lib/book.ml *)

open Import
open Types.Book

let difficulty_of_string = function
  | "beginner" -> Ok Beginner
  | "intermediate" -> Ok Intermediate
  | "advanced" -> Ok Advanced
  | s -> Error (`Msg ("Unknown difficulty type: " ^ s))

let difficulty_of_yaml = function
  | `String s -> difficulty_of_string s
  | _ -> Error (`Msg "Expected a string for difficulty type")

type metadata = {
  title : string;
  slug : string;
  description : string;
  recommendation : string option;
  authors : string list;
  language : string list;
  published : string;
  cover : string;
  isbn : string option;
  links : link list;
  difficulty : difficulty;
  pricing : string;
}
[@@deriving of_yaml, stable_record ~version:t ~add:[ body_md; body_html ]]

let of_metadata m = metadata_to_t m

let decode (fpath, (head, body)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_md = String.trim body in
  let body_html =
    Cmarkit.Doc.of_string ~strict:true body_md |> Cmarkit_html.of_doc ~safe:true
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () =
  Utils.map_md_files decode "books/*.md"
  |> Stdlib.List.sort (fun (b1 : t) (b2 : t) ->
         (* Sort the books by reversed publication date. *)
         Stdlib.String.compare b2.published b1.published)
