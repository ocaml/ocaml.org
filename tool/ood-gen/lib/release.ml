type kind = [ `Compiler ]

let kind_of_string = function
  | "compiler" ->
    `Compiler
  | _ ->
    raise (Exn.Decode_error "Unknown release kind")

let kind_to_string = function `Compiler -> "compiler"

type metadata =
  { kind : string
  ; version : string
  ; date : string
  ; intro : string
  ; highlights : string
  }
[@@deriving yaml]

let path = Fpath.v "data/releases/en"

let parse content =
  let metadata, _ = Utils.extract_metadata_body content in
  metadata_of_yaml metadata

type t =
  { kind : kind
  ; version : string
  ; date : string
  ; intro_md : string
  ; intro_html : string
  ; highlights_md : string
  ; highlights_html : string
  ; body_md : string
  ; body_html : string
  }

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata =
        try Utils.decode_or_raise metadata_of_yaml metadata with
        | _ ->
          failwith content
      in
      { kind = kind_of_string metadata.kind
      ; version = metadata.version
      ; date = metadata.date
      ; intro_md = metadata.intro
      ; intro_html = Omd.of_string metadata.intro |> Omd.to_html
      ; highlights_md = metadata.highlights
      ; highlights_html =
          Omd.of_string metadata.highlights
          |> Hilite.Md.transform
          |> Omd.to_html
      ; body_md = body
      ; body_html = Omd.of_string body |> Hilite.Md.transform |> Omd.to_html
      })
    "releases/en"
  |> List.sort (fun a b -> String.compare a.date b.date)
  |> List.rev

let pp_kind ppf v = Fmt.pf ppf "%s" (match v with `Compiler -> "`Compiler")

let pp ppf v =
  Fmt.pf
    ppf
    {|
  { kind = %a
  ; version = %a
  ; date = %a
  ; intro_md = %a
  ; intro_html = %a
  ; highlights_md = %a
  ; highlights_html = %a
  ; body_md = %a
  ; body_html = %a
  }|}
    pp_kind
    v.kind
    Pp.string
    v.version
    Pp.string
    v.date
    Pp.string
    v.intro_md
    Pp.string
    v.intro_html
    Pp.string
    v.highlights_md
    Pp.string
    v.highlights_html
    Pp.string
    v.body_md
    Pp.string
    v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type kind = [ `Compiler ]

type t =
  { kind : kind
  ; version : string
  ; date : string
  ; intro_md : string
  ; intro_html : string
  ; highlights_md : string
  ; highlights_html : string
  ; body_md : string
  ; body_html : string
  }
  
let all = %a
|}
    pp_list
    (all ())
