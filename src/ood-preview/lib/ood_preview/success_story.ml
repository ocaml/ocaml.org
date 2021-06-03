type metadata = Ood.Success_story.t =
  { title : string
  ; image : string option
  ; url : string option
  }
[@@deriving yaml]

type t =
  { title : string
  ; image : string option
  ; url : string option
  ; body : string
  }

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      let body = Omd.of_string body |> Omd.to_html in
      { title = metadata.title
      ; image = metadata.image
      ; url = metadata.url
      ; body
      })
    "success_stories/en"

let slug (t : t) = Utils.slugify t.title

let get_by_slug id =
  all () |> List.find_opt (fun success_story -> slug success_story = id)
