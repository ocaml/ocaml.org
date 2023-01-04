type link = { description : string; uri : string } [@@deriving yaml]

type metadata = {
  title : string;
  description : string;
  authors : string list;
  language : string;
  published : string;
  cover : string;
  isbn : string option;
  links : link list;
  rating : int option;
  featured : bool;
}
[@@deriving yaml]

type t = {
  title : string;
  description : string;
  authors : string list;
  language : string;
  published : string;
  cover : string;
  isbn : string option;
  links : link list;
  rating : int option;
  featured : bool;
  body_md : string;
  body_html : string;
}

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      {
        title = metadata.title;
        description = metadata.description;
        authors = metadata.authors;
        language = metadata.language;
        published = metadata.published;
        cover = metadata.cover;
        isbn = metadata.isbn;
        links = metadata.links;
        rating = metadata.rating;
        featured = metadata.featured;
        body_md = String.trim body;
        body_html = Omd.of_string body |> Omd.to_html;
      })
    "books/"

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
  ; rating = %a
  ; featured = %a
  ; body_md = %a
  ; body_html = %a
  }|}
    Pp.string v.title Pp.string (Utils.slugify v.title) Pp.string v.description
    (Pp.list Pp.string) v.authors Pp.string v.language Pp.string v.published
    Pp.string v.cover (Pp.option Pp.string) v.isbn (Pp.list pp_link) v.links
    (Pp.option Pp.int) v.rating Pp.bool v.featured Pp.string v.body_md Pp.string
    v.body_html

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
  ; published : string
  ; cover : string
  ; isbn : string option
  ; links : link list
  ; rating : int option
  ; featured : bool
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    pp_list (all ())
