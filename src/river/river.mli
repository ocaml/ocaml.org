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
(** The source of a feed. *)

type feed
type post

val fetch : source -> feed
(** [fetch source] returns an Atom or RSS feed from a source. *)

val name : feed -> string
(** [name feed] is the name of the feed source passed to [fetch]. *)

val url : feed -> string
(** [url feed] is the url of the feed source passed to [fetch]. *)

val posts : feed list -> post list
(** [posts feeds] is the list of deduplicated posts of the given feeds. *)

val feed : post -> feed
(** [feed post] is the feed the post originates from. *)

val title : post -> string
(** [title post] is the title of the post. *)

val link : post -> Uri.t option
(** [link post] is the link of the post. *)

val date : post -> Syndic.Date.t option
(** [date post] is the date of the post. *)

val author : post -> string
(** [author post] is the author of the post. *)

val email : post -> string
(** [email post] is the email of the post. *)

val content : post -> string
(** [content post] is the content of the post. *)

val meta_description : post -> string option
(** [meta_description post] is the meta description of the post on the origin
    site.

    To get the meta description, we make get the content of [link post] and look
    for an HTML meta tag with the name "description" or "og:description".*)

val seo_image : post -> string option
(** [seo_image post] is the image to be used by social networks and links to the
    post.

    To get the seo image, we make get the content of [link post] and look for an
    HTML meta tag with the name "og:image" or "twitter:image". *)

val create_atom_entries : post list -> Syndic.Atom.entry list
(** [create_atom_feed posts] creates a list of atom entries, which can then be
    used to create an atom feed that is an aggregate of the posts. *)
