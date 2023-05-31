module Process = struct
  open Lwt.Infix

  let pp_args =
    let sep = Fmt.(const string) " " in
    Fmt.(array ~sep (quote string))

  let pp_cmd f = function
    | "", args -> pp_args f args
    | bin, args -> Fmt.pf f "(%S, %a)" bin pp_args args

  let pp_status f = function
    | Unix.WEXITED x -> Fmt.pf f "exited with status %d" x
    | Unix.WSIGNALED x -> Fmt.pf f "failed with signal %d" x
    | Unix.WSTOPPED x -> Fmt.pf f "stopped with signal %d" x

  let check_status cmd = function
    | Unix.WEXITED 0 -> ()
    | status -> Fmt.failwith "%a %a" pp_cmd cmd pp_status status

  let exec cmd =
    let proc = Lwt_process.open_process_none cmd in
    proc#status >|= check_status cmd

  let pread cmd =
    let proc = Lwt_process.open_process_in cmd in
    Lwt_io.read proc#stdout >>= fun output ->
    proc#status >|= check_status cmd >|= fun () -> output

  let pread_lines cmd =
    let open Lwt.Syntax in
    let proc = Lwt_process.open_process_in cmd in
    let* lines = Lwt_io.read_lines proc#stdout |> Lwt_stream.to_list in
    let* status = proc#status in
    check_status cmd status;
    Lwt.return lines
end

let clone_path = Config.opam_repository_path
let exists () = Result.get_ok (Bos.OS.Path.exists clone_path)

let git_cmd args =
  ("git", Array.of_list ("git" :: "-C" :: Fpath.to_string clone_path :: args))

let last_commit () =
  let open Lwt.Syntax in
  let+ output =
    Process.pread (git_cmd [ "rev-parse"; "HEAD" ]) |> Lwt.map String.trim
  in
  output

let clone () =
  let open Lwt.Syntax in
  let* () =
    Process.exec
      ( "git",
        [|
          "git";
          "clone";
          "https://github.com/ocaml/opam-repository.git";
          Fpath.to_string clone_path;
        |] )
  in
  Logs.info (fun m -> m "git clone");
  last_commit ()

let pull () =
  let open Lwt.Syntax in
  let* () =
    Process.exec (git_cmd [ "pull"; "-q"; "--ff-only"; "origin"; "master" ])
  in
  Logs.info (fun m -> m "git pull");
  last_commit ()

let fold_dir f acc directory =
  match Sys.readdir directory with
  | exception Sys_error _ -> None
  | entries ->
      (* Sort to remove a source of non-determinism. *)
      Array.sort String.compare entries;
      Some (Array.fold_right f entries acc)

(** Read directory [directory] and return the base name of every directories in
    it. *)
let ls_dir_in_dir directory =
  fold_dir
    (fun x acc ->
      if Sys.is_directory (Filename.concat directory x) then x :: acc else acc)
    [] directory

let list_package_versions package =
  ls_dir_in_dir Fpath.(to_string (clone_path / "packages" / package))

let list_packages_and_versions () =
  let directory = Fpath.(to_string (clone_path / "packages")) in
  fold_dir
    (fun x acc ->
      match list_package_versions x with
      | Some versions -> (x, versions) :: acc
      | None -> acc)
    [] directory
  |> Option.value ~default:[]

let list_packages () =
  ls_dir_in_dir Fpath.(to_string (clone_path / "packages"))
  |> Option.value ~default:[]

let process_opam_file f =
  let open Lwt.Syntax in
  Lwt_io.with_file ~mode:Input (Fpath.to_string f) (fun channel ->
      let+ content = Lwt_io.read channel in
      OpamFile.OPAM.read_from_string content)

let opam_file package_name package_version =
  let opam_file =
    Fpath.(clone_path / "packages" / package_name / package_version / "opam")
  in
  process_opam_file opam_file

let commit_at_date date =
  Process.pread (git_cmd [ "rev-list"; "-1"; "--before=" ^ date; "@" ])
  |> Lwt.map String.trim

let new_files_since ~a ~b =
  let parse_commits lines =
    let rec commit acc = function date :: tl -> files date acc tl | [] -> acc
    and files date acc = function
      | "" :: tl -> commit acc tl
      | hd :: tl -> files date ((Fpath.v hd, date) :: acc) tl
      | [] -> acc
    in
    List.rev (commit [] lines)
  in
  Process.pread_lines
    (git_cmd
       [
         "log";
         "--name-only";
         "--diff-filter=A" (* Show added file for each commit. *);
         "--format=format:%ar" (* Date of the commit. In relative format. *);
         a ^ ".." ^ b;
       ])
  |> Lwt.map parse_commits

(* Borrowed from
   https://github.com/ocaml-opam/opam2web/blob/ad2ddb01865c891949f3560b653247bdbb2a0f75/src/o2wUniverse.ml#L25 *)
let parse_git_commit_times =
  let any_opam_path = "*/opam" in
  let rec read_time found = function
    | [] -> found
    | ln :: rest -> read_file found (float_of_string ln) rest
  and read_file found time = function
    | [] -> found
    | "" :: rest -> read_time found rest
    | path :: rest ->
        let suff = String.length any_opam_path - 1 in
        let path = String.(sub path 0 (length path - suff)) in
        let slash = try String.rindex path '/' + 1 with Not_found -> 0 in
        let pkg = String.(sub path slash (length path - slash)) in
        let found =
          match OpamPackage.of_string_opt pkg with
          | Some pkg -> OpamPackage.Map.add pkg time found
          | None -> found
        in
        read_file found time rest
  in
  read_time OpamPackage.Map.empty

let create_package_to_timestamp () =
  let open Lwt.Syntax in
  let+ output =
    Process.pread_lines
      (git_cmd
         [
           "log";
           "--name-only";
           "--diff-filter=ACR";
           "--reverse";
           "--pretty=format:%ct";
           "-m";
           "--first-parent";
           "--";
           "*/opam";
         ])
  in
  parse_git_commit_times output
