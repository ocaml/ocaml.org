type link =
  { description : string
  ; uri : string
  }
[@@deriving yaml]

type t =
  { title : string
  ; publication : string
  ; authors : string list
  ; abstract : string
  ; tags : string list
  ; year : int
  ; links : link list
  ; featured : bool
  }
[@@deriving yaml]

type metadata = t

let path = Fpath.v "data/papers.yml"

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("papers", `A xs) ] ->
    Ok (List.map (Utils.decode_or_raise of_yaml) xs)
  | _ ->
    Error (`Msg "expected a list of papers")

let parse = decode

let all () =
  let content = Data.read "papers.yml" |> Option.get in
  Utils.decode_or_raise decode content
  |> List.sort (fun p1 p2 ->
         (2 * Int.compare p1.year p2.year) + String.compare p1.title p2.title)

let pp_link ppf (v : link) =
  Fmt.pf
    ppf
    {|
        { description = %a
        ; uri = %a
        }|}
    Pp.string
    v.description
    Pp.string
    v.uri

let pp ppf v =
  Fmt.pf
    ppf
    {|
  { title = %a
  ; slug = %a
  ; publication = %a
  ; authors = %a
  ; abstract = %a
  ; tags = %a
  ; year = %i
  ; links = %a
  ; featured = %a
  }|}
    Pp.string
    v.title
    Pp.string
    (Utils.slugify v.title)
    Pp.string
    v.publication
    (Pp.list Pp.string)
    v.authors
    Pp.string
    v.abstract
    (Pp.list Pp.string)
    v.tags
    v.year
    (Pp.list pp_link)
    v.links
    Pp.bool
    v.featured

let pp_list = Pp.list pp

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
    pp_list
    (all ())
