let clone_path = Config.opam_repository_path

let ls_dir directory =
  Sys.readdir directory
  |> Array.to_list
  |> List.filter (fun x -> Sys.is_directory (Filename.concat directory x))

let list_packages () = ls_dir Fpath.(to_string (clone_path / "packages"))

let list_package_versions package =
  ls_dir Fpath.(to_string (clone_path / "packages" / package))

let process_opam_file f =
  let ic = open_in (Fpath.to_string f) in
  let result = OpamFile.OPAM.read_from_channel ic in
  close_in ic;
  result

let opam_file package_name package_version =
  let opam_file =
    Fpath.(clone_path / "packages" / package_name / package_version / "opam")
  in
  process_opam_file opam_file
