[@@@ocaml.warning "-66"]

type metadata =
  { title : string
  ; description : string
  ; people : string list
  ; kind : string
  ; tags : string list
  ; paper : string option
  ; link : string
  ; embed : string option
  ; year : int
  }
[@@deriving yaml]

type kind =
  [ `Conference
  | `Mooc
  | `Lecture
  ]

type t = Ood.Videos.Video.t =
  { title : string
  ; description : string
  ; people : string list
  ; kind : kind
  ; tags : string list
  ; paper : string option
  ; link : string
  ; embed : string option
  ; year : int
  }

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("videos", `A xs) ] ->
    List.map
      (fun x ->
        let (metadata : metadata) = Utils.decode_or_raise metadata_of_yaml x in
        let kind =
          match Ood.Videos.Video.kind_of_string metadata.kind with
          | Ok x ->
            x
          | Error (`Msg err) ->
            raise (Exn.Decode_error err)
        in
        ({ title = metadata.title
         ; description = metadata.description
         ; people = metadata.people
         ; kind
         ; tags = metadata.tags
         ; paper = metadata.paper
         ; link = metadata.link
         ; embed = metadata.embed
         ; year = metadata.year
         }
          : t))
      xs
  | _ ->
    raise (Exn.Decode_error "expected a list of videos")

let all () =
  let content = Data.read "videos.yml" |> Option.get in
  decode content

let slug (t : t) = Utils.slugify t.title

let get_by_slug id = all () |> List.find_opt (fun video -> slug video = id)
