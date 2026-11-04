(* Short descriptions for Planet posts.

   A post's description is shown as a two-line teaser on the Planet listing, is
   the entry content of planet.xml, and is searched (at a lower weight than
   keywords, which already cover the body). It should be the article's opening
   sentences, not the article. Many feeds deliver exactly that, but RSS 2.0 lets
   <description> carry the whole post, and some generators (Zola, for one) put
   it there, so the raw feed summary can be tens of kilobytes.

   [choose] picks, in order of preference: 1. the feed summary, when it is
   already short (an author-written excerpt); 2. the page's og:description /
   meta description (also author-written); 3. the opening paragraphs of the post
   body, skipping code, tables, figures and headings; 4. the feed summary,
   shortened. Whatever is chosen is whitespace-normalised and cut to
   [max_length] bytes, at a sentence end when possible. *)

let max_length = 400

(* A sentence cut is only taken if it keeps at least this much text; otherwise
   cut at a word and add an ellipsis. *)
let min_sentence_cut = 100
let ellipsis = "\xe2\x80\xa6" (* U+2026 *)
let is_space c = c = ' ' || c = '\t' || c = '\n' || c = '\r' || c = '\012'

(* Collapse runs of whitespace (including non-breaking spaces) to one space and
   trim. *)
let normalize s =
  let b = Buffer.create (String.length s) in
  let pending = ref false in
  let n = String.length s in
  let i = ref 0 in
  while !i < n do
    let c = s.[!i] in
    let nbsp = c = '\xc2' && !i + 1 < n && s.[!i + 1] = '\xa0' in
    if is_space c || nbsp then (
      pending := true;
      i := !i + if nbsp then 2 else 1)
    else (
      if !pending && Buffer.length b > 0 then Buffer.add_char b ' ';
      pending := false;
      Buffer.add_char b c;
      incr i)
  done;
  Buffer.contents b

(* [shorten s] is [normalize s] when that fits in [max_length]; otherwise the
   longest prefix ending a sentence (".", "!" or "?" followed by a space) that
   fits, or failing that the longest prefix ending at a word followed by an
   ellipsis. Cuts are made at ASCII spaces, so UTF-8 sequences stay whole. *)
let shorten s =
  let s = normalize s in
  let n = String.length s in
  if n <= max_length then s
  else
    let rec sentence i =
      if i < min_sentence_cut then None
      else if
        (s.[i] = '.' || s.[i] = '!' || s.[i] = '?')
        && i + 1 < n
        && s.[i + 1] = ' '
      then Some (String.sub s 0 (i + 1))
      else sentence (i - 1)
    in
    match sentence (max_length - 1) with
    | Some cut -> cut
    | None -> (
        let limit = max_length - String.length ellipsis in
        match String.rindex_from_opt s limit ' ' with
        | Some i when i > 0 -> String.sub s 0 i ^ ellipsis
        | _ ->
            (* No space at all: back off to a UTF-8 boundary. *)
            let i = ref limit in
            while !i > 0 && Char.code s.[!i] land 0xc0 = 0x80 do
              decr i
            done;
            String.sub s 0 !i ^ ellipsis)

let non_empty s = if s = "" then None else Some s

(* Elements whose text never belongs in a teaser, even inside a paragraph. *)
let skip_tags =
  [
    "script";
    "style";
    "noscript";
    "nav";
    "header";
    "footer";
    "aside";
    "form";
    "svg";
    "head";
    "button";
    "iframe";
    "pre";
    "table";
    "figure";
    "figcaption";
    "h1";
    "h2";
    "h3";
    "h4";
    "h5";
    "h6";
  ]

let inline_tags =
  [
    "a";
    "abbr";
    "b";
    "cite";
    "code";
    "em";
    "i";
    "kbd";
    "mark";
    "q";
    "s";
    "samp";
    "small";
    "span";
    "strong";
    "sub";
    "sup";
    "time";
    "tt";
    "u";
    "var";
  ]

(* [lead_of_html html] is the text of the post's first paragraphs, enough to
   fill [max_length], shortened. Only <p> elements count; when the HTML has none
   (plain text content), all its text is used. *)
let lead_of_html html =
  let paras = Buffer.create 1024 and all = Buffer.create 1024 in
  let stack = ref [] in
  let in_any tags = List.exists (fun t -> List.mem t tags) !stack in
  let full () = Buffer.length paras > max_length in
  (try
     Markup.string html |> Markup.parse_html |> Markup.signals
     |> Markup.iter (function
          | `Start_element ((_, name), _) ->
              let name = String.lowercase_ascii name in
              (* Element boundaries separate words unless the element is inline:
                 "<li>a</li><li>b</li>" is "a b", not "ab". *)
              if not (List.mem name inline_tags) then (
                if List.mem "p" !stack || name = "p" then
                  if not (full ()) then Buffer.add_char paras ' ';
                Buffer.add_char all ' ');
              stack := name :: !stack
          | `End_element -> (
              match !stack with _ :: tl -> stack := tl | [] -> ())
          | `Text ss ->
              if not (in_any skip_tags) then
                let p = List.mem "p" !stack && not (full ()) in
                List.iter
                  (fun s ->
                    if p then Buffer.add_string paras s;
                    if Buffer.length all <= max_length * 4 then
                      Buffer.add_string all s)
                  ss
          | _ -> ())
   with _ -> ());
  let paras = normalize (Buffer.contents paras) in
  non_empty (shorten (if paras <> "" then paras else Buffer.contents all))

(* [meta_of_html html] is the page's og:description, or else its description
   meta tag. *)
let meta_of_html html =
  let og = ref None and plain = ref None in
  (try
     Markup.string html |> Markup.parse_html |> Markup.signals
     |> Markup.iter (function
          | `Start_element ((_, "meta"), attrs) -> (
              let attr k =
                List.find_map
                  (fun ((_, n), v) ->
                    if String.lowercase_ascii n = k then Some v else None)
                  attrs
              in
              let key =
                match (attr "property", attr "name") with
                | Some k, _ | None, Some k -> Some (String.lowercase_ascii k)
                | None, None -> None
              in
              match (key, attr "content") with
              | Some "og:description", Some c when !og = None -> og := Some c
              | Some "description", Some c when !plain = None -> plain := Some c
              | _ -> ())
          | _ -> ())
   with _ -> ());
  match !og with
  | Some c when normalize c <> "" -> Some c
  | _ -> Option.bind !plain (fun c -> non_empty (normalize c))

(* [choose ~summary ~content ~page] is the description to store. [summary] is
   the feed's plain-text summary, [content] the post body HTML, and [page ()]
   fetches the article page; it is only called when the summary is missing or
   too long. *)
let choose ~summary ~content ~page =
  let summary = Option.bind summary (fun s -> non_empty (normalize s)) in
  match summary with
  | Some s when String.length s <= max_length -> Some s
  | _ -> (
      match Option.bind (page ()) meta_of_html with
      | Some m -> Some (shorten m)
      | None -> (
          match lead_of_html content with
          | Some l -> Some l
          | None -> Option.map shorten summary))
