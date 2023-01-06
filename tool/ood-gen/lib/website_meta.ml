(** This module determines an image to be used as preview of a website.

    It does this by following the same logic Google+ and other websites use, and
    described in this article:
    https://www.raymondcamden.com/2011/07/26/How-are-Facebook-and-Google-creating-link-previews *)

let og_image html =
  let open Soup in
  let soup = parse html in
  try soup $ "meta[property=og:image]" |> R.attribute "content" |> Option.some
  with Failure _ -> None

let image_src html =
  let open Soup in
  let soup = parse html in
  try soup $ "link[rel=\"image_src\"]" |> R.attribute "href" |> Option.some
  with Failure _ -> None

let twitter_image html =
  let open Soup in
  let soup = parse html in
  try
    soup $ "meta[name=\"twitter:image\"]" |> R.attribute "content"
    |> Option.some
  with Failure _ -> None

let og_description html =
  let open Soup in
  let soup = parse html in
  try
    soup $ "meta[property=og:description]" |> R.attribute "content"
    |> Option.some
  with Failure _ -> None

let description html =
  let open Soup in
  let soup = parse html in
  try
    soup $ "meta[property=description]" |> R.attribute "content" |> Option.some
  with Failure _ -> None

let preview_image html =
  let preview_image =
    match og_image html with
    | None -> (
        match image_src html with
        | None -> twitter_image html
        | Some x -> Some x)
    | Some x -> Some x
  in
  match Option.map String.trim preview_image with
  | Some "" -> None
  | Some x -> Some x
  | None -> None

let description html =
  let preview_image =
    match og_description html with None -> description html | Some x -> Some x
  in
  match Option.map String.trim preview_image with
  | Some "" -> None
  | Some x -> Some x
  | None -> None

type t = { image : string option; description : string option }

let all url =
  let html = Http_client.get_sync url in
  { image = preview_image html; description = description html }
