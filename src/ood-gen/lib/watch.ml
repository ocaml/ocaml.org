[@@@ocaml.warning "-66"]

type metadata = {
  name : string;
  embedPath : string;
  thumbnailPath : string;
  description : string option;
  date : string;
  language : string;
  category : string;
}
[@@deriving yaml]

let path = Fpath.v "data/watch.yml"

let parse content = Result.map metadata_of_yaml @@ Yaml.of_string content

type t = {
  name : string;
  embedPath : string;
  thumbnailPath : string;
  description : string option;
  date : string;
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
             embedPath = metadata.embedPath;
             thumbnailPath = metadata.thumbnailPath;
             date = metadata.date;
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
  ; embedPath = %a
  ; thumbnailPath = %a
  ; description = %a
  ; date = %a
  ; language = %a
  ; category = %a
  }|}
    Pp.string v.name Pp.string v.embedPath Pp.string v.thumbnailPath
    Pp.(option string)
    v.description Pp.string v.date Pp.string v.language Pp.string v.category

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|

  type t =
  { name: string;
    embedPath : string;
    thumbnailPath : string;
    description : string option;
    date : string;
    language : string;
    category : string;
  }
  
let all = %a
|}
    pp_list (all ())
