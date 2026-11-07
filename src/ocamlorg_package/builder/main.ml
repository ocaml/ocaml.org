(* ocamlorg-package-builder [--nice N] STATE_PATH

   Bring the opam-repository clone at [OCAMLORG_REPO_PATH] up to date (cloning
   it if it is missing), rebuild the package state saved at STATE_PATH if the
   clone has moved, write it, and exit. A missing or unreadable state, or one
   saved by another version, is rebuilt from scratch; otherwise only what
   changed since the saved commit is re-read where possible. Exits with 0 once
   STATE_PATH is up to date, whether or not it had to be written, and with 1 on
   any failure, leaving STATE_PATH as it was. *)

open Ocamlorg_package_state

let usage () =
  prerr_endline "usage: ocamlorg-package-builder [--nice N] STATE_PATH";
  exit 2

let state_path_of_string s =
  match Fpath.of_string s with Ok p -> p | Error _ -> usage ()

let parse_args = function
  | [ path ] -> (None, state_path_of_string path)
  | [ "--nice"; n; path ] -> (
      match int_of_string_opt n with
      | Some n -> (Some n, state_path_of_string path)
      | None -> usage ())
  | _ -> usage ()

let build state_path =
  let open Lwt.Syntax in
  let previous = Package_state.load state_path in
  let* commit =
    if Opam_repository.exists () then (
      Logs.info (fun m -> m "Opam repo: git pull");
      Opam_repository.pull ())
    else (
      Logs.info (fun m -> m "Opam repo: git clone");
      Opam_repository.clone ())
  in
  if previous.opam_repository_commit = Some commit then (
    Logs.info (fun m -> m "Package state up to date (opam commit %s)" commit);
    Lwt.return_unit)
  else
    let+ v =
      Logs.info (fun m -> m "Update server state");
      Package_state.rebuild ~previous ~commit
    in
    Package_state.write state_path v;
    Logs.info (fun m -> m "Package state saved")

let () =
  Logs.set_reporter (Logs.format_reporter ());
  Logs.set_level (Some Info);
  let nice, state_path = parse_args (List.tl (Array.to_list Sys.argv)) in
  Option.iter (fun n -> ignore (Unix.nice n)) nice;
  match Lwt_main.run (build state_path) with
  | () -> exit 0
  | exception e ->
      Logs.err (fun m ->
          m "Failed to update the package state: %s" (Printexc.to_string e));
      exit 1
