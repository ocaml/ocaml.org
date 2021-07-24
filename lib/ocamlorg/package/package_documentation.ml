let doc_path = Config.documentation_path

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

let load_package package_name package_version =
  let files = package_files package_name package_version in
  let parent = package_parent_path package_name package_version in
  let hashtbl = Hashtbl.create 256 in
  let package_path = package_path_in_root package_name package_version in
  List.iter
    (fun f ->
      let new_tbl = Odoc_thtml.render ~package_path f in
      (* Merge hash tables *)
      Hashtbl.fold
        (fun key elt () ->
          try Hashtbl.replace hashtbl key elt with
          | exn ->
            Logs.err (fun m -> m "%s" (Printexc.to_string exn)))
        new_tbl
        ())
    (parent :: files.odocls);
  List.iter
    (fun f ->
      let new_tbl = Odoc_thtml.render_other ~package_path ~parent f in
      (* Merge hash tables *)
      Hashtbl.fold
        (fun key elt () ->
          try Hashtbl.replace hashtbl key elt with
          | exn ->
            Logs.err (fun m -> m "%s" (Printexc.to_string exn)))
        new_tbl
        ())
    files.otherdocs;
  hashtbl

let load_readme package_name package_version =
  let parent = package_parent_path package_name package_version in
  let f = Fpath.(package_path package_name package_version / "README.md") in
  let package_path = package_path_in_root package_name package_version in
  let hashtbl =
    Odoc_thtml.render_other ~with_toc:false ~package_path ~parent f
  in
  Hashtbl.find_opt hashtbl "README.md"
