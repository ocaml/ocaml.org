type location = Ood.Academic_institution.location =
  { lat : float
  ; long : float
  }
[@@deriving yaml]

type course = Ood.Academic_institution.course =
  { name : string
  ; acronym : string option
  ; online_resource : string option
  }
[@@deriving yaml]

type metadata = Ood.Academic_institution.t =
  { name : string
  ; description : string
  ; url : string
  ; logo : string option
  ; continent : string
  ; courses : course list
  ; location : location option
  }
[@@deriving yaml]

type t =
  { name : string
  ; description : string
  ; url : string
  ; logo : string option
  ; continent : string
  ; courses : course list
  ; location : location option
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
      ; url = metadata.url
      ; logo = metadata.logo
      ; continent = metadata.continent
      ; courses = metadata.courses
      ; location = metadata.location
      ; body
      })
    "academic_institutions/en"

let slug (t : t) = Utils.slugify t.name

let get_by_slug id = all () |> List.find_opt (fun t -> slug t = id)
