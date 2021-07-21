let doc_path = Fpath.(v "var" / "occurent-output")

type files =
  { opam : Fpath.t option
  ; otherdocs : Fpath.t list
  ; odocls : Fpath.t list
  }

let package_path name version = Fpath.(doc_path / "packages" / name / version)

let package_path_in_root name version = Fpath.(v "packages" / name / version)

let package_parent_path package_name package_version =
  let pkg_path = package_path package_name package_version in
  Fpath.(pkg_path / ".." / ("page-" ^ package_version ^ ".odocl"))

let ok_or_log = function
  | Ok x ->
    x
  | Error (`Msg e) ->
    raise
      (Invalid_argument
         (Printf.sprintf
            "An error occured while rendering the documentation: %s"
            e))

let package_files package_name package_version =
  let empty = { opam = None; otherdocs = []; odocls = [] } in
  let pkg_path = package_path package_name package_version in
  Bos.OS.Dir.fold_contents
    ~elements:`Files
    ~dotfiles:false
    (fun p files ->
      match Fpath.get_ext p with
      | ".odocl" ->
        { files with odocls = p :: files.odocls }
      | _ ->
        (match Fpath.basename p with
        | "opam" ->
          { files with opam = Some p }
        | _ ->
          { files with otherdocs = p :: files.otherdocs }))
    empty
    pkg_path
  |> Result.get_ok

module Renderer = struct
  let ( >>= ) r f = match r with Ok v -> f v | Error _ as e -> e

  let document_of_odocl ~syntax input =
    let open Odoc_odoc in
    let open Odoc_document in
    Odoc_file.load input >>= fun unit ->
    match unit.content with
    | Odoc_file.Page_content odoctree ->
      Ok (Renderer.document_of_page ~syntax odoctree)
    | Unit_content odoctree ->
      Ok (Renderer.document_of_compilation_unit ~syntax odoctree)

  let render_document ~package_path odoctree =
    let pages = Odoc_thtml.Generator.render ~indent:false odoctree in
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

  let render ~package_path file =
    let open Odoc_odoc in
    let f = Fs.File.of_string (Fpath.to_string file) in
    Logs.info (fun m -> m "Rendering file %s" (Fpath.to_string file));
    let document =
      document_of_odocl ~syntax:Odoc_document.Renderer.OCaml f |> ok_or_log
    in
    render_document ~package_path document
end

let load_package package_name package_version =
  let files = package_files package_name package_version in
  let parent = package_parent_path package_name package_version in
  let files = parent :: files.odocls in
  let hashtbl = Hashtbl.create 256 in
  let package_path = package_path_in_root package_name package_version in
  List.iter
    (fun f ->
      let new_tbl = Renderer.render ~package_path f in
      (* Merge hash tables *)
      Hashtbl.fold
        (fun key elt () -> Hashtbl.replace hashtbl key elt)
        new_tbl
        ())
    files;
  hashtbl
