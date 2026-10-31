(* Markdown utilities - copied from ood-gen/lib/markdown.ml *)

open Import

module Toc = struct
  type t = { title : string; href : string; children : t list }
  [@@deriving of_yaml, show]

  let id_to_href id =
    match id with
    | None -> "#"
    | Some (`Auto id) -> "#" ^ id
    | Some (`Id id) -> "#" ^ id

  let rec create_toc ~max_level level
      (headings : Cmarkit.Block.Heading.t Cmarkit.node list) : t list =
    match headings with
    | [] -> []
    | (h, _) :: rest when Cmarkit.Block.Heading.level h > max_level ->
        create_toc ~max_level level rest
    | (h, _) :: rest when Cmarkit.Block.Heading.level h = level ->
        let l = Cmarkit.Block.Heading.level h in
        let child_headings, remaining_headings =
          collect_children ~max_level (l + 1) rest []
        in
        let children = create_toc ~max_level (l + 1) child_headings in
        let title =
          Cmarkit.Inline.to_plain_text ~break_on_soft:false
            (Cmarkit.Block.Heading.inline h)
        in
        {
          title = String.concat "\n" (List.map (String.concat "") title);
          href = id_to_href (Cmarkit.Block.Heading.id h);
          children;
        }
        :: create_toc ~max_level level remaining_headings
    | (h, _) :: _ when Cmarkit.Block.Heading.level h > level ->
        create_toc ~max_level (level + 1) headings
    | _ :: rest -> create_toc ~max_level level rest

  and collect_children ~max_level level
      (headings : Cmarkit.Block.Heading.t Cmarkit.node list) acc =
    match headings with
    | [] -> (acc, [])
    | (h, _) :: rest when Cmarkit.Block.Heading.level h > max_level ->
        collect_children ~max_level level rest acc
    | (h, _) :: _ when Cmarkit.Block.Heading.level h < level -> (acc, headings)
    | heading :: rest ->
        collect_children level ~max_level rest (acc @ [ heading ])

  let headers (doc : Cmarkit.Doc.t) : Cmarkit.Block.Heading.t Cmarkit.node list
      =
    let rec headers_from_block (block : Cmarkit.Block.t) =
      match block with
      | Cmarkit.Block.Heading h -> [ h ]
      | Cmarkit.Block.Blocks (blocks, _) ->
          List.map headers_from_block blocks |> List.concat
      | _ -> []
    in
    Cmarkit.Doc.block doc |> headers_from_block

  let generate ?(start_level = 1) ?(max_level = 2) doc =
    if max_level <= start_level then
      invalid_arg "t: ~max_level must be >= ~start_level";
    create_toc ~max_level start_level (headers doc)
end

module Content = struct
  let of_string content =
    Cmarkit.Doc.of_string ~strict:true ~heading_auto_ids:true content

  let options = Hilite_markdown.Options.(set_ocaml_mdx_syntax true default)

  let render ?(syntax_highlighting = false) ?(options = options) doc =
    if syntax_highlighting then
      Hilite_markdown.transform ~options doc |> Cmarkit_html.of_doc ~safe:false
    else doc |> Cmarkit_html.of_doc ~safe:false
end

module Excerpt = struct
  open Cmarkit

  type source = Paragraph of Inline.t | Html of string

  (* The paragraphs and HTML blocks of a block, in document order. Headings such
     as "## TL;DR" are skipped. *)
  let rec sources (b : Block.t) =
    match b with
    | Block.Paragraph (p, _) -> [ Paragraph (Block.Paragraph.inline p) ]
    | Block.Html_block (lines, _) ->
        [ Html (List.map Block_line.to_string lines |> String.concat "\n") ]
    | Block.Blocks (bs, _) -> List.concat_map sources bs
    | Block.Block_quote (q, _) -> sources (Block.Block_quote.block q)
    | Block.List (l, _) ->
        Block.List'.items l
        |> List.concat_map (fun (item, _) ->
               sources (Block.List_item.block item))
    | _ -> []

  (* Decode the character references that occur in scraped release notes. Others
     are left as they are. *)
  let decode_entity name =
    match name with
    | "amp" -> Some "&"
    | "lt" -> Some "<"
    | "gt" -> Some ">"
    | "quot" -> Some "\""
    | "apos" -> Some "'"
    | "nbsp" -> Some " "
    | _ -> (
        let code =
          if String.length name > 2 && (name.[1] = 'x' || name.[1] = 'X') then
            int_of_string_opt ("0x" ^ String.sub name 2 (String.length name - 2))
          else if String.length name > 1 && name.[0] = '#' then
            int_of_string_opt (String.sub name 1 (String.length name - 1))
          else None
        in
        match code with
        | Some c when name.[0] = '#' && Uchar.is_valid c ->
            let b = Buffer.create 4 in
            Buffer.add_utf_8_uchar b (Uchar.of_int c);
            Some (Buffer.contents b)
        | _ -> None)

  (* The text of an HTML fragment: tags removed, character references
     decoded. *)
  let text_of_html s =
    let b = Buffer.create (String.length s) in
    let len = String.length s in
    let rec text i =
      if i < len then
        match s.[i] with
        | '<' -> (
            Buffer.add_char b ' ';
            match String.index_from_opt s i '>' with
            | Some j -> text (j + 1)
            | None -> ())
        | '&' -> (
            match String.index_from_opt s i ';' with
            | Some j when j - i <= 10 -> (
                match decode_entity (String.sub s (i + 1) (j - i - 1)) with
                | Some d ->
                    Buffer.add_string b d;
                    text (j + 1)
                | None ->
                    Buffer.add_char b '&';
                    text (i + 1))
            | _ ->
                Buffer.add_char b '&';
                text (i + 1))
        | c ->
            Buffer.add_char b c;
            text (i + 1)
    in
    text 0;
    Buffer.contents b

  let collapse_spaces s =
    String.split_on_char ' ' s
    |> List.concat_map (String.split_on_char '\n')
    |> List.concat_map (String.split_on_char '\t')
    |> List.filter (( <> ) "")
    |> String.concat " "

  (* [cut ~max_bytes s] is [s] if it fits in [max_bytes], otherwise a prefix
     that ends on a character boundary, preferably between words, followed by an
     ellipsis. *)
  let cut ~max_bytes s =
    if String.length s <= max_bytes then s
    else
      let prefix = Ocamlorg.Import.String.utf_8_prefix s max_bytes in
      let prefix =
        match String.rindex_opt prefix ' ' with
        | Some i when i >= max_bytes / 2 -> String.sub prefix 0 i
        | _ -> prefix
      in
      prefix ^ "\xe2\x80\xa6"

  (* Stripping tags leaves a space wherever a tag was, as in "#1426 , which".
     Remove the spaces that end up before closing punctuation or after an
     opening parenthesis. *)
  let tidy_punctuation s =
    let b = Buffer.create (String.length s) in
    let len = String.length s in
    String.iteri
      (fun i c ->
        let next = if i + 1 < len then s.[i + 1] else 'x' in
        let prev = if i > 0 then s.[i - 1] else 'x' in
        match c with
        | ' ' when String.contains ",.;:!?)" next || prev = '(' -> ()
        | c -> Buffer.add_char b c)
      s;
    Buffer.contents b

  let text_of_source = function
    | Paragraph inline ->
        Inline.to_plain_text ~break_on_soft:false inline
        |> List.map (String.concat "")
        |> String.concat " " |> collapse_spaces
    | Html html -> text_of_html html |> collapse_spaces |> tidy_punctuation

  (* [of_doc ~max_bytes doc] is the plain text of the first paragraph of [doc]
     that has text, cut to about [max_bytes] bytes. Platform release notes
     scraped from GitHub are raw HTML, so when no paragraph has text, the first
     HTML block that has text is used instead. It is [""] if there is
     neither. *)
  let of_doc ?(max_bytes = 100) doc =
    let sources = sources (Doc.block doc) in
    let paragraphs, html =
      List.partition (function Paragraph _ -> true | Html _ -> false) sources
    in
    let first_text l =
      List.find_map
        (fun s -> match text_of_source s with "" -> None | t -> Some t)
        l
    in
    match first_text paragraphs with
    | Some t -> cut ~max_bytes t
    | None -> Option.fold ~none:"" ~some:(cut ~max_bytes) (first_text html)
end
