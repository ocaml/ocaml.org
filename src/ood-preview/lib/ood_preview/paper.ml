type t = Ood.Papers.Paper.t =
  { title : string
  ; publication : string
  ; authors : string list
  ; abstract : string
  ; tags : string list
  ; year : int
  ; links : string list
  }
[@@deriving yaml]

let decode_or_raise f x =
  match f x with Ok x -> x | Error (`Msg err) -> raise (Exn.Decode_error err)

let decode s =
  let yaml = decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("papers", `A xs) ] ->
    List.map (decode_or_raise of_yaml) xs
  | _ ->
    raise (Exn.Decode_error "expected a list of papers")

let all () =
  let content = Data.read "papers.yml" |> Option.get in
  decode content

let slug (t : t) = Utils.slugify t.title

let get_by_slug id = all () |> List.find_opt (fun paper -> slug paper = id)
