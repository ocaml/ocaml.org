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

type source = Feed.source = { name : string; url : string }
type feed = Feed.t
type post = Post.t

let fetch = Feed.fetch
let name feed = feed.Feed.name
let url feed = feed.Feed.url
let posts feeds = Post.get_posts feeds
let title post = post.Post.title
let link post = post.Post.link
let date post = post.Post.date
let feed post = post.Post.feed
let author post = post.Post.author
let email post = post.Post.email
let content post = Post.string_of_html post.Post.content

let meta_description post =
  match Post.fetch_link post with
  | None -> None
  | Some response -> Meta.description response

let seo_image post =
  match Post.fetch_link post with
  | None -> None
  | Some response -> Meta.preview_image response

let create_atom_entries = Post.mk_entries
