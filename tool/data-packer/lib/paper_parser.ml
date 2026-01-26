(* Paper parser - adapted from ood-gen/lib/paper.ml *)

open Import

type link = [%import: Data_intf.Paper.link] [@@deriving of_yaml, show]
type t = [%import: Data_intf.Paper.t] [@@deriving show]

type metadata = {
  title : string;
  publication : string;
  authors : string list;
  abstract : string;
  tags : string list;
  year : int;
  links : link list;
  featured : bool;
}
[@@deriving of_yaml, stable_record ~version:t ~add:[ slug ]]

let of_metadata m = metadata_to_t m ~slug:(Utils.slugify m.title)

let all () =
  Utils.yaml_sequence_file
    (fun yaml -> Result.map of_metadata (metadata_of_yaml yaml))
    "papers.yml"
  |> List.sort (fun (p1 : t) (p2 : t) ->
         (* Sort primarily by year (descending), then by title *)
         let year_cmp = Int.compare p2.year p1.year in
         if year_cmp <> 0 then year_cmp else String.compare p1.title p2.title)

let featured () = all () |> List.filter (fun (p : t) -> p.featured)
