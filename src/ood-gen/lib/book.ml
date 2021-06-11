type metadata = {
  title : string;
  description : string;
  authors : string list;
  language : string;
  published : string option;
  cover : string option;
  isbn : string option;
}
[@@deriving yaml]

type t = { meta : metadata; body_md : string; body_html : string }

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      {
        meta =
          {
            title = metadata.title;
            description = metadata.description;
            authors = metadata.authors;
            language = metadata.language;
            published = metadata.published;
            cover = metadata.cover;
            isbn = metadata.isbn;
          };
        body_md = String.trim body;
        body_html = Omd.of_string body |> Omd.to_html;
      })
    "books/en"

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %S
  ; description = %S
  ; authors = %a
  ; language = %S
  ; published = %a
  ; cover = %a
  ; isbn = %a
  ; body_md = %S
  ; body_html = %S
  }|}
    v.meta.title v.meta.description (Pp.list Pp.quoted_string) v.meta.authors
    v.meta.language
    (Pp.option Pp.quoted_string)
    v.meta.published
    (Pp.option Pp.quoted_string)
    v.meta.cover
    (Pp.option Pp.quoted_string)
    v.meta.isbn v.body_md v.body_html

let pp_list = Pp.list pp

let template =
  Format.asprintf
    {|
type t = 
  { title : string
  ; description : string
  ; authors : string list
  ; language : string
  ; published : string option
  ; cover : string option
  ; isbn : string option
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    pp_list (all ())
