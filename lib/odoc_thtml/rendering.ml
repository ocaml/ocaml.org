open Result

let ( >>= ) r f = match r with Ok v -> f v | Error _ as e -> e

let document_of_odocl ~syntax input =
  let open Odoc_document in
  let open Odoc_odoc in
  Odoc_file.load input >>= fun unit ->
  match unit.content with
  | Odoc_file.Page_content odoctree ->
    Ok (Renderer.document_of_page ~syntax odoctree)
  | Unit_content odoctree ->
    Ok (Renderer.document_of_compilation_unit ~syntax odoctree)

let docs_ids parent docs =
  let open Odoc_odoc in
  Odoc_file.load parent >>= fun root ->
  match root.content with
  | Page_content odoctree ->
    (match odoctree.Odoc_model.Lang.Page.name with
    | `LeafPage _ ->
      Error (`Msg "Parent is a leaf!")
    | `Page _ as parent_id ->
      let result =
        List.map
          (fun doc ->
            let id =
              let basename = Fpath.basename doc in
              `LeafPage
                (Some parent_id, Odoc_model.Names.PageName.make_std basename)
            in
            id, doc)
          docs
      in
      Ok result)
  | _ ->
    Error (`Msg "Parent is not a page!")

let otherversions parent vs =
  let open Odoc_odoc in
  Odoc_file.load parent >>= fun root ->
  match root.content with
  | Page_content odoctree ->
    (match odoctree.Odoc_model.Lang.Page.name with
    | `LeafPage _ ->
      Error (`Msg "Parent is a leaf!")
    | `Page (parent_id, _) ->
      let result =
        List.map
          (fun v -> `Page (parent_id, Odoc_model.Names.PageName.make_std v))
          vs
      in
      Ok result)
  | _ ->
    Error (`Msg "Parent is not a page!")

let render_document ~package_path ~with_toc odoctree =
  let pages = Generator.render ~indent:false ~with_toc odoctree in
  let hashtbl = Hashtbl.create 24 in
  Odoc_document.Renderer.traverse pages ~f:(fun filename content ->
      let index_length = String.length "/index" in
      let uri =
        filename
        |> Fpath.relativize ~root:package_path
        |> Option.get
        |> Fpath.normalize
        |> Fpath.rem_ext
        |> Fpath.to_string
        |> function
        | "index" ->
          ""
        | s
          when String.sub s (String.length s - index_length) index_length
               = "/index" ->
          String.sub s 0 (String.length s - index_length + 1)
        | s ->
          s
      in
      let content = Format.asprintf "%t@?" content in
      Hashtbl.add hashtbl uri content);
  hashtbl

let ok_or_log = function
  | Ok x ->
    x
  | Error (`Msg e) ->
    raise
      (Invalid_argument
         (Printf.sprintf
            "An error occured while rendering the documentation: %s"
            e))

let render ?(with_toc = true) ~package_path file =
  let open Odoc_odoc in
  let f = Fs.File.of_string (Fpath.to_string file) in
  Logs.info (fun m -> m "Rendering file %s" (Fpath.to_string file));
  let document =
    document_of_odocl ~syntax:Odoc_document.Renderer.OCaml f |> ok_or_log
  in
  render_document ~package_path ~with_toc document

let render_text ~id ~package_path ~with_toc doc =
  let url = Odoc_document.Url.Path.from_identifier id in
  let document = Markdown.read_plain doc url |> ok_or_log in
  render_document ~package_path ~with_toc document

let render_markdown ~id ~package_path ~with_toc doc =
  let url = Odoc_document.Url.Path.from_identifier id in
  match Markdown.read_md doc url with
  | Ok page ->
    render_document ~package_path ~with_toc page
  | Error _ ->
    render_text ~id ~package_path ~with_toc doc

let render_other ?(with_toc = true) ~package_path ~parent doc =
  let doc_id = docs_ids parent [ doc ] |> ok_or_log in
  match doc_id with
  | [ (id, doc) ] ->
    if Fpath.get_ext doc = ".md" then
      render_markdown ~package_path ~id ~with_toc doc
    else
      render_text ~package_path ~id ~with_toc doc
  | _ ->
    raise (Failure "docs_ids returned more than one id for a single document")
