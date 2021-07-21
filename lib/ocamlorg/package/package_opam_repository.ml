module Process = struct
  open Lwt.Infix

  let pp_args =
    let sep = Fmt.(const string) " " in
    Fmt.(array ~sep (quote string))

  let pp_cmd f = function
    | "", args ->
      pp_args f args
    | bin, args ->
      Fmt.pf f "(%S, %a)" bin pp_args args

  let pp_status f = function
    | Unix.WEXITED x ->
      Fmt.pf f "exited with status %d" x
    | Unix.WSIGNALED x ->
      Fmt.pf f "failed with signal %d" x
    | Unix.WSTOPPED x ->
      Fmt.pf f "stopped with signal %d" x

  let check_status cmd = function
    | Unix.WEXITED 0 ->
      ()
    | status ->
      Fmt.failwith "%a %a" pp_cmd cmd pp_status status

  let exec cmd =
    let proc = Lwt_process.open_process_none cmd in
    proc#status >|= check_status cmd
end

let clone_path = Config.opam_repository_path

let clone () =
  match Bos.OS.Path.exists clone_path with
  | Ok true ->
    Lwt.return_unit
  | Ok false ->
    Process.exec
      ( ""
      , [| "git"
         ; "clone"
         ; "https://github.com/ocaml/opam-repository.git"
         ; Fpath.to_string clone_path
        |] )
  | _ ->
    Fmt.failwith "Error finding about this path: %a" Fpath.pp clone_path

let pull () =
  Process.exec
    ("", [| "git"; "-C"; Fpath.to_string clone_path; "pull"; "origin" |])

module Store = Git_unix.Store

let clone_path = Config.opam_repository_path

let open_store () =
  let open Lwt.Syntax in
  let dotgit = Fpath.(clone_path / ".git") in
  let+ store = Git_unix.Store.v ~dotgit clone_path in
  match store with
  | Ok x ->
    x
  | Error e ->
    Fmt.failwith "Failed to open opam-repository: %a" Store.pp_error e

let last_commit () =
  let open Lwt.Syntax in
  let* store = open_store () in
  let+ commit = Store.Ref.resolve store Git.Reference.master in
  Store.Hash.to_raw_string @@ Result.get_ok commit

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
