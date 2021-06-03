type proficiency =
  [ `Beginner
  | `Intermediate
  | `Advanced
  ]

type metadata =
  { title : string
  ; description : string
  ; date : string
  ; tags : string list
  ; users : string list
  }
[@@deriving yaml]

type t =
  { title : string
  ; description : string
  ; date : string
  ; tags : string list
  ; users : proficiency list
  ; body : string
  }

let proficiency_list_of_string_list =
  List.map (fun x ->
      match Ood.Meta.Proficiency.of_string x with
      | Ok x ->
        x
      | Error (`Msg err) ->
        raise (Exn.Decode_error err))

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      let body = Omd.of_string body |> Omd.to_html in
      { title = metadata.title
      ; description = metadata.description
      ; date = metadata.date
      ; tags = metadata.tags
      ; users = proficiency_list_of_string_list metadata.users
      ; body
      })
    "tutorials/en/*.md"

let slug (t : t) = Utils.slugify t.title

let get_by_slug id =
  all () |> List.find_opt (fun success_story -> slug success_story = id)

let filter_by_tag ~tag tutorials =
  List.filter (fun (x : t) -> List.mem tag x.tags) tutorials
