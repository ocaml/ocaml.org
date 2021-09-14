type t = {
  title : string;
  publication : string;
  authors : string list;
  abstract : string;
  tags : string list;
  year : int;
  links : string list;
}
[@@deriving yaml]

type metadata = t

let path = Fpath.v "data/papers.yml"

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("papers", `A xs) ] -> Ok (List.map (Utils.decode_or_raise of_yaml) xs)
  | _ -> Error (`Msg "expected a list of papers")

let parse = decode

let all () =
  let content = Data.read "papers.yml" |> Option.get in
  Utils.decode_or_raise decode content

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; publication = %a
  ; authors = %a
  ; abstract = %a
  ; tags = %a
  ; year = %i
  ; links = %a
  }|}
    Pp.string v.title Pp.string (Utils.slugify v.title) Pp.string v.publication
    (Pp.list Pp.string) v.authors Pp.string v.abstract (Pp.list Pp.string)
    v.tags v.year (Pp.list Pp.string) v.links

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; publication : string
  ; authors : string list
  ; abstract : string
  ; tags : string list
  ; year : int
  ; links : string list
  }
  
let all = %a
|}
    pp_list (all ())
