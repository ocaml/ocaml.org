type link = { description : string; uri : string }
[@@deriving of_yaml, show { with_path = false }]

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
[@@deriving of_yaml]

type t = {
  title : string;
  slug : string;
  publication : string;
  authors : string list;
  abstract : string;
  tags : string list;
  year : int;
  links : link list;
  featured : bool;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ slug ], show { with_path = false }]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.title)
let decode s = Import.Result.apply (Ok of_metadata) (metadata_of_yaml s)

let all () =
  Utils.yaml_sequence_file decode "papers.yml"
  |> List.sort (fun p1 p2 ->
         (2 * Int.compare p2.year p1.year) + String.compare p1.title p2.title)

let template () =
  Format.asprintf
    {|
  type link = { description : string; uri : string }

type t =
  { title : string
  ; slug : string
  ; publication : string
  ; authors : string list
  ; abstract : string
  ; tags : string list
  ; year : int
  ; links : link list
  ; featured : bool
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
