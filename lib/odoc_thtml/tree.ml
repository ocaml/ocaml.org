(*
 * Copyright (c) 2016 Thomas Refis <trefis@janestreet.com>
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

module Html = Tyxml.Html

type uri =
  | Absolute of string
  | Relative of Odoc_document.Url.Path.t option

let page_creator
    ?(theme_uri = Relative None)
    ?(support_uri = Relative None)
    ~url
    _title
    _header
    toc
    content
  =
  let _theme_uri = theme_uri in
  let _support_uri = support_uri in
  let _breadcrumbs =
    let rec get_parents x =
      match x with
      | [] ->
        []
      | x :: xs ->
        (match Odoc_document.Url.Path.of_list (List.rev (x :: xs)) with
        | Some x ->
          x :: get_parents xs
        | None ->
          get_parents xs)
    in
    let parents =
      get_parents (List.rev (Odoc_document.Url.Path.to_list url)) |> List.rev
    in
    let has_parent = List.length parents > 1 in
    let href page =
      Link.href ~resolve:(Current url) (Odoc_document.Url.from_path page)
    in
    if has_parent then
      let up_url = List.hd (List.tl (List.rev parents)) in
      let l =
        [ Html.a ~a:[ Html.a_href (href up_url) ] [ Html.txt "Up" ]
        ; Html.txt " – "
        ]
        @
        (* Create breadcrumbs *)
        let space = Html.txt " " in
        parents
        |> Utils.list_concat_map
             ?sep:(Some [ space; Html.entity "#x00BB"; space ])
             ~f:(fun url' ->
               [ [ (if url = url' then
                      Html.txt url.name
                   else
                     Html.a
                       ~a:[ Html.a_href (href url') ]
                       [ Html.txt url'.name ])
                 ]
               ])
        |> List.flatten
      in
      [ Html.nav ~a:[ Html.a_class [ "odoc-nav" ] ] l ]
    else
      []
  in
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "flex-auto flex" ] ]
    [ div
        ~a:[ a_class [ "relative flex w-full" ] ]
        [ div
            ~a:
              [ a_class
                  [ "hidden lg:block absolute top-0 bottom-0 right-0 left-1/2 \
                     bg-white"
                  ]
              ]
            []
        ; div
            ~a:
              [ a_class
                  [ "relative flex w-full max-w-container mx-auto px-4 sm:px-6 \
                     lg:px-8"
                  ]
              ]
            [ div
                ~a:
                  [ a_class
                      [ "w-full flex-none lg:grid lg:grid-cols-3 lg:gap-8" ]
                  ]
                [ div
                    ~a:
                      [ a_class
                          [ "bg-gray-50 lg:bg-transparent -mx-4 sm:-mx-6 \
                             lg:mx-0 py-8 sm:py-12 px-4 sm:px-6 lg:pl-0 \
                             lg:pr-8"
                          ]
                      ]
                    toc
                ; div
                    ~a:
                      [ a_class
                          [ "relative col-span-2 lg:-ml-8 bg-white lg:shadow-md"
                          ]
                      ]
                    [ div
                        ~a:
                          [ a_class
                              [ "hidden lg:block absolute top-0 bottom-0 \
                                 -right-4 w-8 bg-white"
                              ]
                          ]
                        []
                    ; div
                        ~a:[ a_class [ "relative py-16 lg:px-16" ] ]
                        [ div
                            ~a:
                              [ a_class
                                  [ "prose prose-sm prose-orange \
                                     max-w-[37.5rem] mx-auto"
                                  ]
                              ]
                            content
                        ]
                    ]
                ]
            ]
        ]
    ]

let make
    ?theme_uri ?support_uri ~indent ~url ~header ~toc title content children
  =
  let filename = Link.Path.as_filename url in
  let html =
    page_creator ?theme_uri ?support_uri ~url title header toc content
  in
  let content ppf = (Html.pp_elt ~indent ()) ppf html in
  { Odoc_document.Renderer.filename; content; children }

let open_details = ref true
