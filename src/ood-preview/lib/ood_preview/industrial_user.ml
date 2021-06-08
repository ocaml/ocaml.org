type metadata = Ood.Industrial_user.t =
  { name : string
  ; description : string
  ; image : string option
  ; site : string
  ; locations : string list
  ; consortium : bool
  }
[@@deriving yaml]

type t =
  { name : string
  ; description : string
  ; image : string option
  ; site : string
  ; locations : string list
  ; consortium : bool
  ; body : string
  }

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      let body = Omd.of_string body |> Omd.to_html in
      { name = metadata.name
      ; description = metadata.description
      ; image = metadata.image
      ; site = metadata.site
      ; consortium = metadata.consortium
      ; locations = metadata.locations
      ; body
      })
    "industrial_users/en"

let get_consortium () = List.filter (fun (x : t) -> x.consortium) (all ())

let slug (t : t) = Utils.slugify t.name

let get_by_slug id =
  all () |> List.find_opt (fun success_story -> slug success_story = id)
