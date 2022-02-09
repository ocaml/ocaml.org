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

type source = { name : string; url : string }
type content = Atom of Syndic.Atom.feed | Rss2 of Syndic.Rss2.channel

let string_of_feed = function Atom _ -> "Atom" | Rss2 _ -> "Rss2"

type t = { name : string; title : string; url : string; content : content }

let classify_feed ~xmlbase (xml : string) =
  try Atom (Syndic.Atom.parse ~xmlbase (Xmlm.make_input (`String (0, xml))))
  with Syndic.Atom.Error.Error _ -> (
    try Rss2 (Syndic.Rss2.parse ~xmlbase (Xmlm.make_input (`String (0, xml))))
    with Syndic.Rss2.Error.Error _ -> failwith "Neither Atom nor RSS2 feed")

let fetch (source : source) =
  let xmlbase = Uri.of_string @@ source.url in
  let response = Http.get source.url in
  let content = classify_feed ~xmlbase response in
  let title =
    match content with
    | Atom atom -> Util.string_of_text_construct atom.Syndic.Atom.title
    | Rss2 ch -> ch.Syndic.Rss2.title
  in
  { name = source.name; title; content; url = source.url }
