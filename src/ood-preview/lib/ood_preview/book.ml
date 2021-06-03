type metadata = Ood.Book.t =
  { title : string
  ; description : string
  ; authors : string list
  ; language : string
  ; published : string option
  ; cover : string option
  ; isbn : string option
  }
[@@deriving yaml]

type t =
  { title : string
  ; description : string
  ; authors : string list
  ; language : string
  ; published : string option
  ; cover : string option
  ; isbn : string option
  ; body : string
  }

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      let body = Omd.of_string body |> Omd.to_html in
      { title = metadata.title
      ; description = metadata.description
      ; authors = metadata.authors
      ; language = metadata.language
      ; published = metadata.published
      ; cover = metadata.cover
      ; isbn = metadata.isbn
      ; body
      })
    "books/en"

let slug (t : t) = Utils.slugify t.title

let get_by_slug id = all () |> List.find_opt (fun book -> slug book = id)
