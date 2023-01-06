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

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("papers", `A xs) ] ->
      Ok
        (List.map
           (fun x -> x |> Utils.decode_or_raise metadata_of_yaml |> of_metadata)
           xs)
  | _ -> Error (`Msg "expected a list of papers")

let all () =
  let content = Data.read "papers.yml" |> Option.get in
  Utils.decode_or_raise decode content
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
