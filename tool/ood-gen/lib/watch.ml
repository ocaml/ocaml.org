[@@@ocaml.warning "-66"]

type metadata = {
  name : string;
  embed_path : string;
  thumbnail_path : string;
  description : string option;
  published_at : string;
  updated_at : string;
  language : string;
  category : string;
}
[@@deriving yaml]

let path = Fpath.v "data/watch.yml"
let parse content = Result.map metadata_of_yaml @@ Yaml.of_string content

type t = {
  name : string;
  embed_path : string;
  thumbnail_path : string;
  description : string option;
  published_at : string;
  updated_at : string;
  language : string;
  category : string;
}

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("watch", `A xs) ] ->
      List.map
        (fun x ->
          let (metadata : metadata) =
            Utils.decode_or_raise metadata_of_yaml x
          in
          ({
             name = metadata.name;
             description = metadata.description;
             embed_path = metadata.embed_path;
             thumbnail_path = metadata.thumbnail_path;
             published_at = metadata.published_at;
             updated_at = metadata.updated_at;
             language = metadata.language;
             category = metadata.category;
           }
            : t))
        xs
  | _ -> raise (Exn.Decode_error "expected a list of videos")

let all () =
  let content = Data.read "watch.yml" |> Option.get in
  decode content

let pp ppf v =
  Fmt.pf ppf
    {|
  { name = %a
  ; embed_path = %a
  ; thumbnail_path = %a
  ; description = %a
  ; published_at = %a
  ; updated_at = %a
  ; language = %a
  ; category = %a
  }|}
    Pp.string v.name Pp.string v.embed_path Pp.string v.thumbnail_path
    Pp.(option string)
    v.description Pp.string v.published_at Pp.string v.updated_at Pp.string
    v.language Pp.string v.category

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|

  type t =
  { name: string;
    embed_path : string;
    thumbnail_path : string;
    description : string option;
    published_at : string;
    updated_at : string;
    language : string;
    category : string;
  }
  
let all = %a
|}
    pp_list (all ())
