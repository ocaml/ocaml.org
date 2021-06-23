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

let decode_or_raise f x =
  match f x with Ok x -> x | Error (`Msg err) -> raise (Exn.Decode_error err)

let decode s =
  let yaml = decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("papers", `A xs) ] -> List.map (decode_or_raise of_yaml) xs
  | _ -> raise (Exn.Decode_error "expected a list of papers")

let all () =
  let content = Data.read "papers.yml" |> Option.get in
  decode content

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
