open Data_intf.Paper

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
let decode s = Result.map of_metadata (metadata_of_yaml s)

let all () =
  Utils.yaml_sequence_file decode "papers.yml"
  |> List.sort (fun (p1 : t) (p2 : t) ->
         (2 * Int.compare p2.year p1.year) + String.compare p1.title p2.title)

let template () =
  Format.asprintf {|
include Data_intf.Paper
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
