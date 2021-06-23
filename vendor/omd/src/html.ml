open Ast

type element_type = Inline | Block

type t =
  | Element of element_type * string * attributes * t option
  | Text of string
  | Raw of string
  | Null
  | Concat of t * t

let elt etype name attrs childs = Element (etype, name, attrs, childs)

let text s = Text s

let raw s = Raw s

let concat t1 t2 =
  match (t1, t2) with Null, t | t, Null -> t | _ -> Concat (t1, t2)

let concat_map f l = List.fold_left (fun accu x -> concat accu (f x)) Null l

(* only convert when "necessary" *)
let htmlentities s =
  let b = Buffer.create (String.length s) in
  let rec loop i =
    if i >= String.length s then Buffer.contents b
    else (
      ( match s.[i] with
      | '"' -> Buffer.add_string b "&quot;"
      | '&' -> Buffer.add_string b "&amp;"
      | '<' -> Buffer.add_string b "&lt;"
      | '>' -> Buffer.add_string b "&gt;"
      | c -> Buffer.add_char b c );
      loop (succ i) )
  in
  loop 0

let add_attrs_to_buffer buf attrs =
  let f (k, v) = Printf.bprintf buf " %s=\"%s\"" k (htmlentities v) in
  List.iter f attrs

let rec add_to_buffer buf = function
  | Element (eltype, name, attrs, None) ->
      Printf.bprintf buf "<%s%a />" name add_attrs_to_buffer attrs;
      if eltype = Block then Buffer.add_char buf '\n'
  | Element (eltype, name, attrs, Some c) ->
      Printf.bprintf buf "<%s%a>%a</%s>" name add_attrs_to_buffer attrs
        add_to_buffer c name;
      if eltype = Block then Buffer.add_char buf '\n'
  | Text s -> Buffer.add_string buf (htmlentities s)
  | Raw s -> Buffer.add_string buf s
  | Null -> ()
  | Concat (t1, t2) ->
      add_to_buffer buf t1;
      add_to_buffer buf t2

let escape_uri s =
  let b = Buffer.create (String.length s) in
  String.iter
    (function
      | ( '!' | '*' | '\'' | '(' | ')' | ';' | ':' | '@' | '=' | '+' | '$' | ','
        | '/' | '?' | '%' | '#'
        | 'A' .. 'Z'
        | 'a' .. 'z'
        | '0' .. '9'
        | '-' | '_' | '.' | '~' | '&' ) as c ->
          Buffer.add_char b c
      | _ as c -> Printf.bprintf b "%%%2X" (Char.code c))
    s;
  Buffer.contents b

let to_plain_text t =
  let buf = Buffer.create 1024 in
  let rec go : _ inline -> unit = function
    | Concat (_, l) -> List.iter go l
    | Text (_, t) | Code (_, t) -> Buffer.add_string buf t
    | Emph (_, i)
    | Strong (_, i)
    | Link (_, { label = i; _ })
    | Image (_, { label = i; _ }) ->
        go i
    | Hard_break _ | Soft_break _ -> Buffer.add_char buf ' '
    | Html _ -> ()
  in
  go t;
  Buffer.contents buf

let nl = Raw "\n"

let rec url label destination title attrs =
  let attrs =
    match title with None -> attrs | Some title -> ("title", title) :: attrs
  in
  let attrs = ("href", escape_uri destination) :: attrs in
  elt Inline "a" attrs (Some (inline label))

and img label destination title attrs =
  let attrs =
    match title with None -> attrs | Some title -> ("title", title) :: attrs
  in
  let attrs =
    ("src", escape_uri destination) :: ("alt", to_plain_text label) :: attrs
  in
  elt Inline "img" attrs None

and inline = function
  | Ast.Concat (_, l) -> concat_map inline l
  | Text (_, t) -> text t
  | Emph (attr, il) -> elt Inline "em" attr (Some (inline il))
  | Strong (attr, il) -> elt Inline "strong" attr (Some (inline il))
  | Code (attr, s) -> elt Inline "code" attr (Some (text s))
  | Hard_break attr -> concat (elt Inline "br" attr None) nl
  | Soft_break _ -> nl
  | Html (_, body) -> raw body
  | Link (attr, { label; destination; title }) ->
      url label destination title attr
  | Image (attr, { label; destination; title }) ->
      img label destination title attr

let rec block = function
  | Blockquote (attr, q) ->
      elt Block "blockquote" attr (Some (concat nl (concat_map block q)))
  | Paragraph (attr, md) -> elt Block "p" attr (Some (inline md))
  | List (attr, ty, sp, bl) ->
      let name = match ty with Ordered _ -> "ol" | Bullet _ -> "ul" in
      let attr =
        match ty with
        | Ordered (n, _) when n <> 1 -> ("start", string_of_int n) :: attr
        | _ -> attr
      in
      let li t =
        let block' t =
          match (t, sp) with
          | Paragraph (_, t), Tight -> concat (inline t) nl
          | _ -> block t
        in
        let nl = if sp = Tight then Null else nl in
        elt Block "li" [] (Some (concat nl (concat_map block' t)))
      in
      elt Block name attr (Some (concat nl (concat_map li bl)))
  | Code_block (attr, label, code) ->
      let code_attr =
        if String.trim label = "" then []
        else [ ("class", "language-" ^ label) ]
      in
      let c = text code in
      elt Block "pre" attr (Some (elt Inline "code" code_attr (Some c)))
  | Thematic_break attr -> elt Block "hr" attr None
  | Html_block (_, body) -> raw body
  | Heading (attr, level, text) ->
      let name =
        match level with
        | 1 -> "h1"
        | 2 -> "h2"
        | 3 -> "h3"
        | 4 -> "h4"
        | 5 -> "h5"
        | 6 -> "h6"
        | _ -> "p"
      in
      elt Block name attr (Some (inline text))
  | Definition_list (attr, l) ->
      let f { term; defs } =
        concat
          (elt Block "dt" [] (Some (inline term)))
          (concat_map (fun s -> elt Block "dd" [] (Some (inline s))) defs)
      in
      elt Block "dl" attr (Some (concat_map f l))

let of_doc doc = concat_map block doc

let to_string t =
  let buf = Buffer.create 1024 in
  add_to_buffer buf t;
  Buffer.contents buf
