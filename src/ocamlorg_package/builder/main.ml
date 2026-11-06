(* ocamlorg-package-builder [--nice N] [--require-doc-modules] STATE_PATH

   Bring the opam-repository clone at [OCAMLORG_REPO_PATH] up to date (cloning
   it if it is missing), rebuild the package state saved at STATE_PATH if the
   clone has moved, write it, and exit. A missing or unreadable state, or one
   saved by another version, is rebuilt from scratch; otherwise only what
   changed since the saved commit is re-read where possible.

   Then, independently, bring the doc-modules index at
   [OCAMLORG_DOC_MODULES_PATH] up to date from the release asset CI publishes
   (Doc_modules_fetch, #3982): a failure there keeps the current index and never
   fails the state, and the other way round.

   Exits with 0 once STATE_PATH is up to date, whether or not it had to be
   written, and with 1 if the state could not be brought up to date, leaving
   STATE_PATH as it was. With --require-doc-modules (used when building the
   image, so that a server never starts without module data), also exits with 1
   if no valid index is in place afterwards. *)

open Ocamlorg_package_state

let usage () =
  prerr_endline
    "usage: ocamlorg-package-builder [--nice N] [--require-doc-modules] \
     STATE_PATH";
  exit 2

let state_path_of_string s =
  match Fpath.of_string s with Ok p -> p | Error _ -> usage ()

type args = { nice : int option; require_doc_modules : bool; state : Fpath.t }

let rec parse_args acc = function
  | [ path ] -> { acc with state = state_path_of_string path }
  | "--nice" :: n :: rest -> (
      match int_of_string_opt n with
      | Some n -> parse_args { acc with nice = Some n } rest
      | None -> usage ())
  | "--require-doc-modules" :: rest ->
      parse_args { acc with require_doc_modules = true } rest
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
  let args =
    parse_args
      { nice = None; require_doc_modules = false; state = Fpath.v "." }
      (List.tl (Array.to_list Sys.argv))
  in
  Option.iter (fun n -> ignore (Unix.nice n)) args.nice;
  let state_ok =
    match Lwt_main.run (build args.state) with
    | () -> true
    | exception e ->
        Logs.err (fun m ->
            m "Failed to update the package state: %s" (Printexc.to_string e));
        false
  in
  let index_ok = Lwt_main.run (Doc_modules_fetch.run Paths.doc_modules) in
  if not state_ok then exit 1
  else if args.require_doc_modules && not index_ok then (
    Logs.err (fun m ->
        m "No valid doc-modules index at %a" Fpath.pp Paths.doc_modules);
    exit 1)
  else exit 0
