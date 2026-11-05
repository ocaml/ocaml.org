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
    let open Lwt.Syntax in
    let+ status = proc#status in
    match status with Unix.WEXITED 0 -> Ok () | s -> Error (cmd, s)

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

let clone_path = Paths.opam_repository
let exists () = Result.get_ok (Bos.OS.Path.exists clone_path)

let git_cmd ?(repo = clone_path) args =
  ("git", Array.of_list ("git" :: "-C" :: Fpath.to_string repo :: args))

let last_commit () =
  let open Lwt.Syntax in
  let+ output =
    Process.pread (git_cmd [ "rev-parse"; "HEAD" ]) |> Lwt.map String.trim
  in
  output

let clone () =
  let open Lwt.Syntax in
  let* res =
    Process.exec
      ( "git",
        [|
          "git";
          "clone";
          "https://github.com/ocaml/opam-repository.git";
          Fpath.to_string clone_path;
        |] )
  in
  (match res with Ok () -> () | Error (c, s) -> Process.check_status c s);
  last_commit ()

let pull () =
  let open Lwt.Syntax in
  let* pul =
    Process.exec (git_cmd [ "pull"; "-q"; "--ff-only"; "origin"; "master" ])
  in
  (match pul with
  | Ok () -> ()
  | Error (_, Unix.WEXITED 1) ->
      prerr_endline
        "\n\
         Pulling from opam repository was not possible. \n\
         We will continue by building the package state\n\
         using the existing local state of opam-repository.\n\
         Some functionality might not work properly.\n"
  | Error (c, s) -> Process.check_status c s);
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

(* Opam files are small (1.3 KB median) and are read right after [git pull], so
   they are usually in the page cache. Reading them synchronously is about 10
   times faster than [Lwt_io], which hands every open, read and close to its
   thread pool. *)
let process_opam_file f =
  match In_channel.with_open_bin (Fpath.to_string f) In_channel.input_all with
  | exception Sys_error reason -> Error reason
  | content -> (
      try Ok (OpamFile.OPAM.read_from_string content) with
      | (Out_of_memory | Stack_overflow) as exn -> raise exn
      | exn -> Error (Printexc.to_string exn))

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

type ancestry =
  | First_parent
  | Not_first_parent
  | Unknown_commit
  | Git_failed of string

(* Run [cmd] and return its stdout lines, or its exit status and stderr. These
   Git calls are expected to fail on an unknown commit, so the caller decides
   what a failure means. *)
let pread_result cmd =
  let open Lwt.Syntax in
  Lwt_process.with_process_full cmd (fun proc ->
      let* lines = Lwt_io.read_lines proc#stdout |> Lwt_stream.to_list
      and* stderr = Lwt_io.read proc#stderr in
      let+ status = proc#status in
      match status with
      | Unix.WEXITED 0 -> Ok lines
      | status -> Error (cmd, status, String.trim stderr))

let git_failed (cmd, status, stderr) =
  Git_failed
    (Fmt.str "%a %a: %s" Process.pp_cmd cmd Process.pp_status status stderr)

let ancestry ?repo a b =
  let open Lwt.Syntax in
  let rev_parse rev =
    pread_result
      (git_cmd ?repo
         [
           "rev-parse";
           "--verify";
           "--quiet";
           "--end-of-options";
           rev ^ "^{commit}";
         ])
  in
  let* resolved = rev_parse a in
  match resolved with
  | Error (_, Unix.WEXITED 1, _) | Ok [] -> Lwt.return Unknown_commit
  | Error e -> Lwt.return (git_failed e)
  | Ok (a :: _) -> (
      (* Walking first parents from [b], the walk leaves [a..b] at the first
         commit reachable from [a] that it meets, which is [a] itself iff [a] is
         on that history. Each line is a commit followed by its parents. *)
      let* walk =
        pread_result
          (git_cmd ?repo
             [
               "rev-list";
               "--first-parent";
               "--parents";
               "--reverse";
               "--end-of-options";
               a ^ ".." ^ b;
             ])
      in
      match walk with
      | Error e -> Lwt.return (git_failed e)
      | Ok (oldest :: _) ->
          Lwt.return
            (match String.split_on_char ' ' oldest with
            | _ :: parent :: _ when parent = a -> First_parent
            | _ -> Not_first_parent)
      | Ok [] -> (
          (* [b] is reachable from [a]: they are equal, or [a] is ahead. *)
          let+ resolved = rev_parse b in
          match resolved with
          | Ok (b :: _) when b = a -> First_parent
          | Ok _ | Error (_, Unix.WEXITED 1, _) -> Not_first_parent
          | Error e -> git_failed e))

(* Borrowed from
   https://github.com/ocaml-opam/opam2web/blob/ad2ddb01865c891949f3560b653247bdbb2a0f75/src/o2wUniverse.ml#L25 *)
let parse_git_commit_times ~init =
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
  read_time init

let create_package_to_timestamp ?repo ?since ?(init = OpamPackage.Map.empty)
    commit =
  let open Lwt.Syntax in
  let range = match since with None -> commit | Some a -> a ^ ".." ^ commit in
  let+ output =
    Process.pread_lines
      (git_cmd ?repo
         [
           "log";
           "--name-only";
           "--diff-filter=ACR";
           "--reverse";
           "--pretty=format:%ct";
           "-m";
           "--first-parent";
           range;
           "--";
           "*/opam";
         ])
  in
  parse_git_commit_times ~init output
