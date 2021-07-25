type link = { description : string; uri : string } [@@deriving yaml]

type metadata = {
  title : string;
  description : string;
  authors : string list;
  language : string;
  published : string option;
  cover : string option;
  isbn : string option;
  links : link list option;
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
            links = metadata.links;
          };
        body_md = String.trim body;
        body_html = Omd.of_string body |> Omd.to_html;
      })
    "books/en"

let pp_link ppf (v : link) =
  Fmt.pf ppf
    {|
      { description = %a
      ; uri = %a
      }|}
    Pp.string v.description Pp.string v.uri

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; description = %a
  ; authors = %a
  ; language = %a
  ; published = %a
  ; cover = %a
  ; isbn = %a
  ; links = %a
  ; body_md = %a
  ; body_html = %a
  }|}
    Pp.string v.meta.title Pp.string
    (Utils.slugify v.meta.title)
    Pp.string v.meta.description (Pp.list Pp.string) v.meta.authors Pp.string
    v.meta.language (Pp.option Pp.string) v.meta.published (Pp.option Pp.string)
    v.meta.cover (Pp.option Pp.string) v.meta.isbn (Pp.list pp_link)
    (Option.value v.meta.links ~default:[])
    Pp.string v.body_md Pp.string v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type link = { description : string; uri : string }

type t = 
  { title : string
  ; slug : string
  ; description : string
  ; authors : string list
  ; language : string
  ; published : string option
  ; cover : string option
  ; isbn : string option
  ; links : link list
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    pp_list (all ())
