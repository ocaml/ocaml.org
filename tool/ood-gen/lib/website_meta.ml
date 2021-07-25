(** This module determines an image to be used as preview of a website.

  It does this by following the same logic Google+ and other websites use, and described in this article:
  https://www.raymondcamden.com/2011/07/26/How-are-Facebook-and-Google-creating-link-previews 
*)

let get_sync url =
  let open Piaf in
  let open Lwt_result.Syntax in
  Lwt_main.run
    (let config = { Config.default with follow_redirects = true } in
     let* response = Client.Oneshot.get ~config (Uri.of_string url) in
     if Status.is_successful response.status then Body.to_string response.body
     else
       let message = Status.to_string response.status in
       Lwt.return (Error (`Msg message)))

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
        | Some x -> Some x )
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
  let html = get_sync url |> Result.get_ok in
  { image = preview_image html; description = description html }
