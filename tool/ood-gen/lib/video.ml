[@@@ocaml.warning "-66"]

type metadata = {
  title : string;
  description : string;
  people : string list;
  kind : string;
  tags : string list;
  paper : string option;
  link : string;
  embed : string option;
  year : int;
}
[@@deriving yaml]

module Kind = struct
  type t = [ `Conference | `Mooc | `Lecture ]

  let of_string = function
    | "conference" -> Ok `Conference
    | "mooc" -> Ok `Mooc
    | "lecture" -> Ok `Lecture
    | _ -> Error (`Msg "Unknown video kind")

  let to_string = function
    | `Conference -> "conference"
    | `Mooc -> "mooc"
    | `Lecture -> "lecture"
end

type t = {
  title : string;
  slug : string;
  description : string;
  people : string list;
  kind : Kind.t;
  tags : string list;
  paper : string option;
  link : string;
  embed : string option;
  year : int;
}

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("videos", `A xs) ] ->
      Ok
        (List.map
           (fun x ->
             let (metadata : metadata) =
               Utils.decode_or_raise metadata_of_yaml x
             in
             let kind =
               match Kind.of_string metadata.kind with
               | Ok x -> x
               | Error (`Msg err) -> raise (Exn.Decode_error err)
             in
             ({
                title = metadata.title;
                slug = Utils.slugify metadata.title;
                description = metadata.description;
                people = metadata.people;
                kind;
                tags = metadata.tags;
                paper = metadata.paper;
                link = metadata.link;
                embed = metadata.embed;
                year = metadata.year;
              }
               : t))
           xs)
  | _ -> Error (`Msg "expected a list of videos")

let all () =
  let content = Data.read "videos.yml" |> Option.get in
  Utils.decode_or_raise decode content

let pp_kind ppf v =
  Fmt.pf ppf "%s"
    (match v with
    | `Conference -> "`Conference"
    | `Mooc -> "`Mooc"
    | `Lecture -> "`Lecture")

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; description = %a
  ; people = %a
  ; kind = %a
  ; tags = %a
  ; paper = %a
  ; link = %a
  ; embed = %a
  ; year = %i
  }|}
    Pp.string v.title Pp.string v.slug Pp.string v.description Pp.string_list
    v.people pp_kind v.kind Pp.string_list v.tags (Pp.option Pp.string) v.paper
    Pp.string v.link (Pp.option Pp.string) v.embed v.year

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type kind =
  [ `Conference
  | `Mooc
  | `Lecture
  ]

type t =
  { title : string
  ; slug : string
  ; description : string
  ; people : string list
  ; kind : kind
  ; tags : string list
  ; paper : string option
  ; link : string
  ; embed : string option
  ; year : int
  }
  
let all = %a
|}
    pp_list (all ())
