(*
 * Copyright (c) 2014, OCaml.org project
 * Copyright (c) 2015 KC Sivaramakrishnan <sk826@cl.cam.ac.uk>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

type t = {
  title : string;
  link : Uri.t option;
  date : Syndic.Date.t option;
  feed : Feed.t;
  author : string;
  email : string;
  content : Nethtml.document list;
  mutable link_response : (string, string) result option;
}

let rec len_prefix_of_html html len =
  if len <= 0 then (0, [])
  else
    match html with
    | [] -> (len, [])
    | el :: tl ->
        let len, prefix_el = len_prefix_of_el el len in
        let len, prefix_tl = len_prefix_of_html tl len in
        (len, prefix_el :: prefix_tl)

and len_prefix_of_el el len =
  match el with
  | Nethtml.Data d ->
      let len' = len - String.length d in
      (len', if len' >= 0 then el else Data (String.sub d 0 len ^ "…"))
  | Nethtml.Element (tag, args, content) ->
      (* Remove "id" and "name" to avoid duplicate anchors with the whole
         post. *)
      let args = List.filter (fun (n, _) -> n <> "id" && n <> "name") args in
      let len, prefix_content = len_prefix_of_html content len in
      (len, Element (tag, args, prefix_content))

let prefix_of_html html len = snd (len_prefix_of_html html len)

let rec filter_map l f =
  match l with
  | [] -> []
  | a :: tl -> (
      match f a with None -> filter_map tl f | Some a -> a :: filter_map tl f)

let encode_html =
  Netencoding.Html.encode ~prefer_name:false ~in_enc:`Enc_utf8 ()

let decode_document html = Nethtml.decode ~enc:`Enc_utf8 html
let encode_document html = Nethtml.encode ~enc:`Enc_utf8 html

let rec resolve ?xmlbase html = List.map (resolve_links_el ~xmlbase) html

and resolve_links_el ~xmlbase = function
  | Nethtml.Element ("a", attrs, sub) ->
      let attrs =
        match List.partition (fun (t, _) -> t = "href") attrs with
        | [], _ -> attrs
        | (_, h) :: _, attrs ->
            let src =
              Uri.to_string (Syndic.XML.resolve ~xmlbase (Uri.of_string h))
            in
            ("href", src) :: attrs
      in
      Nethtml.Element ("a", attrs, resolve ?xmlbase sub)
  | Nethtml.Element ("img", attrs, sub) ->
      let attrs =
        match List.partition (fun (t, _) -> t = "src") attrs with
        | [], _ -> attrs
        | (_, src) :: _, attrs ->
            let src =
              Uri.to_string (Syndic.XML.resolve ~xmlbase (Uri.of_string src))
            in
            ("src", src) :: attrs
      in
      Nethtml.Element ("img", attrs, sub)
  | Nethtml.Element (e, attrs, sub) ->
      Nethtml.Element (e, attrs, resolve ?xmlbase sub)
  | Data _ as d -> d

(* Things that posts should not contain *)
let undesired_tags = [ "style"; "script" ]
let undesired_attr = [ "id" ]

let remove_undesired_attr =
  List.filter (fun (a, _) -> not (List.mem a undesired_attr))

let rec remove_undesired_tags html = filter_map html remove_undesired_tags_el

and remove_undesired_tags_el = function
  | Nethtml.Element (t, a, sub) ->
      if List.mem t undesired_tags then None
      else
        Some
          (Nethtml.Element
             (t, remove_undesired_attr a, remove_undesired_tags sub))
  | Data _ as d -> Some d

let relaxed_html40_dtd =
  (* Allow <font> inside <pre> because blogspot uses it! :-( *)
  let constr =
    `Sub_exclusions
      ( [ "img"; "object"; "applet"; "big"; "small"; "sub"; "sup"; "basefont" ],
        `Inline )
  in
  let dtd = Nethtml.relaxed_html40_dtd in
  ("pre", (`Block, constr)) :: List.remove_assoc "pre" dtd

let html_of_text ?xmlbase s =
  try
    Nethtml.parse (new Netchannels.input_string s) ~dtd:relaxed_html40_dtd
    |> decode_document |> resolve ?xmlbase |> remove_undesired_tags
  with _ -> [ Nethtml.Data (encode_html s) ]

(* Do not trust sites using XML for HTML content. Convert to string and parse
   back. (Does not always fix bad HTML unfortunately.) *)
let html_of_syndic =
  let ns_prefix _ = Some "" in
  fun ?xmlbase h ->
    html_of_text ?xmlbase
      (String.concat "" (List.map (Syndic.XML.to_string ~ns_prefix) h))

let string_of_option = function None -> "" | Some s -> s

(* Email on the forge contain the name in parenthesis *)
let forge_name_re = Str.regexp ".*(\\([^()]*\\))"

let post_compare p1 p2 =
  (* Most recent posts first. Posts with no date are always last *)
  match (p1.date, p2.date) with
  | Some d1, Some d2 -> Syndic.Date.compare d2 d1
  | None, Some _ -> 1
  | Some _, None -> -1
  | None, None -> 1

let rec remove n l =
  if n <= 0 then l else match l with [] -> [] | _ :: tl -> remove (n - 1) tl

let rec take n = function
  | [] -> []
  | e :: tl -> if n > 0 then e :: take (n - 1) tl else []

(* Blog feed
 ***********************************************************************)

let post_of_atom ~(feed : Feed.t) (e : Syndic.Atom.entry) =
  let link =
    try
      Some
        (List.find (fun l -> l.Syndic.Atom.rel = Syndic.Atom.Alternate) e.links)
          .href
    with Not_found -> (
      match e.links with l :: _ -> Some l.href | [] -> None)
  in
  let date =
    match e.published with Some _ -> e.published | None -> Some e.updated
  in
  let content =
    match e.content with
    | Some (Text s) -> html_of_text s
    | Some (Html (xmlbase, s)) -> html_of_text ?xmlbase s
    | Some (Xhtml (xmlbase, h)) -> html_of_syndic ?xmlbase h
    | Some (Mime _) | Some (Src _) | None -> (
        match e.summary with
        | Some (Text s) -> html_of_text s
        | Some (Html (xmlbase, s)) -> html_of_text ?xmlbase s
        | Some (Xhtml (xmlbase, h)) -> html_of_syndic ?xmlbase h
        | None -> [])
  in
  let author, _ = e.authors in
  {
    title = Util.string_of_text_construct e.title;
    link;
    date;
    feed;
    author = author.name;
    email = "";
    content;
    link_response = None;
  }

let post_of_rss2 ~(feed : Feed.t) it =
  let title, content =
    match it.Syndic.Rss2.story with
    | All (t, xmlbase, d) -> (
        ( t,
          match it.content with
          | _, "" -> html_of_text ?xmlbase d
          | xmlbase, c -> html_of_text ?xmlbase c ))
    | Title t ->
        let xmlbase, c = it.content in
        (t, html_of_text ?xmlbase c)
    | Description (xmlbase, d) -> (
        ( "",
          match it.content with
          | _, "" -> html_of_text ?xmlbase d
          | xmlbase, c -> html_of_text ?xmlbase c ))
  in
  let link =
    match (it.guid, it.link) with
    | Some u, _ when u.permalink -> Some u.data
    | _, Some _ -> it.link
    | Some u, _ ->
        (* Sometimes the guid is indicated with isPermaLink="false" but is
           nonetheless the only URL we get (e.g. ocamlpro). *)
        Some u.data
    | None, None -> None
  in
  {
    title;
    link;
    feed;
    author = feed.name;
    email = string_of_option it.author;
    content;
    date = it.pubDate;
    link_response = None;
  }

let posts_of_feed c =
  match c.Feed.content with
  | Feed.Atom f -> List.map (post_of_atom ~feed:c) f.Syndic.Atom.entries
  | Feed.Rss2 ch -> List.map (post_of_rss2 ~feed:c) ch.Syndic.Rss2.items

let string_of_html html =
  let buffer = Buffer.create 1024 in
  let channel = new Netchannels.output_buffer buffer in
  let () = Nethtml.write channel @@ encode_document html in
  Buffer.contents buffer

let mk_entry post =
  let content = Syndic.Atom.Html (None, string_of_html post.content) in
  let contributors =
    [ Syndic.Atom.author ~uri:(Uri.of_string post.feed.url) post.feed.name ]
  in
  let links =
    match post.link with
    | Some l -> [ Syndic.Atom.link ~rel:Syndic.Atom.Alternate l ]
    | None -> []
  in
  (* TODO: include source *)
  let id =
    match post.link with
    | Some l -> l
    | None -> Uri.of_string (Digest.to_hex (Digest.string post.title))
  in
  let authors = (Syndic.Atom.author ~email:post.email post.author, []) in
  let title : Syndic.Atom.text_construct = Syndic.Atom.Text post.title in
  let updated =
    match post.date with
    (* Atom entry requires a date but RSS2 does not. So if a date
     * is not available, just capture the current date. *)
    | None -> Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get
    | Some d -> d
  in
  Syndic.Atom.entry ~content ~contributors ~links ~id ~authors ~title ~updated
    ()

let mk_entries posts = List.map mk_entry posts

let get_posts ?n ?(ofs = 0) planet_feeds =
  let posts = List.concat @@ List.map posts_of_feed planet_feeds in
  let posts = List.sort post_compare posts in
  let posts = remove ofs posts in
  match n with None -> posts | Some n -> take n posts

(* Fetch the link response and cache it. *)
let fetch_link t =
  match (t.link, t.link_response) with
  | None, _ -> None
  | Some _, Some (Ok x) -> Some x
  | Some _, Some (Error _) -> None
  | Some link, None -> (
      try
        let host = link |> Uri.host |> Option.get in
        let response =
          Lwt_main.run
          @@ Hyper.get
               ~headers:
                 [ ("Host", host); ("User-Agent", "hyper"); ("Accept", "*/*") ]
               (Uri.to_string link)
        in
        t.link_response <- Some (Ok response);
        Some response
      with _exn ->
        t.link_response <- Some (Error "");
        None)
