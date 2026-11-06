(* ocamlorg-package-builder [--nice N] [--commit SHA] [--oom-score-adj N]
   [--require-doc-modules] STATE_PATH

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
   STATE_PATH as it was. With [--require-doc-modules] (used when building the
   image, so that a server never starts without module data), also exits with 1
   if no valid index is in place afterwards.

   [--commit SHA] is the opam-repository commit of the state the caller already
   holds. If the clone is still at SHA once pulled, and STATE_PATH exists, the
   builder exits at once, without reading the state: most polls find nothing
   new, and reading the state is the bulk of their cost.

   [--oom-score-adj N] raises the builder's [oom_score_adj] to N once the clone
   is pulled, so that the kernel kills the builder before the server if memory
   runs out. Git is not exposed while it writes to the clone. Ignored where
   [/proc] is missing. *)

open Ocamlorg_package_state

type options = {
  nice : int option;
  commit : string option;
  oom_score_adj : int option;
  require_doc_modules : bool;
  state_path : Fpath.t;
}

let usage () =
  prerr_endline
    "usage: ocamlorg-package-builder [--nice N] [--commit SHA] \
     [--oom-score-adj N] [--require-doc-modules] STATE_PATH";
  exit 2

let int_arg n = match int_of_string_opt n with Some n -> n | None -> usage ()

let parse_args args =
  let rec go o = function
    | "--nice" :: n :: tl -> go { o with nice = Some (int_arg n) } tl
    | "--commit" :: c :: tl -> go { o with commit = Some c } tl
    | "--oom-score-adj" :: n :: tl ->
        go { o with oom_score_adj = Some (int_arg n) } tl
    | "--require-doc-modules" :: tl ->
        go { o with require_doc_modules = true } tl
    | [ path ] when String.length path > 0 && path.[0] <> '-' -> (
        match Fpath.of_string path with
        | Ok state_path -> { o with state_path }
        | Error _ -> usage ())
    | _ -> usage ()
  in
  go
    {
      nice = None;
      commit = None;
      oom_score_adj = None;
      require_doc_modules = false;
      state_path = Fpath.v ".";
    }
    args

(* Not fatal: the builder still works, it is only not the first one killed. The
   flush makes the write happen here, where its error is caught:
   [with_open_text] would close the channel with [close_out_noerr], which
   discards it, so that an out-of-range value, or a lowering the process has no
   right to, would go unnoticed. *)
let set_oom_score_adj n =
  match
    Out_channel.with_open_text "/proc/self/oom_score_adj" (fun oc ->
        Out_channel.output_string oc (string_of_int n);
        Out_channel.flush oc)
  with
  | () -> ()
  | exception Sys_error e ->
      Logs.warn (fun m -> m "Could not set oom_score_adj to %d: %s" n e)

let pull () =
  if Opam_repository.exists () then (
    Logs.info (fun m -> m "Opam repo: git pull");
    Opam_repository.pull ())
  else (
    Logs.info (fun m -> m "Opam repo: git clone");
    Opam_repository.clone ())

let up_to_date commit =
  Logs.info (fun m -> m "Package state up to date (opam commit %s)" commit)

let build o =
  let open Lwt.Syntax in
  let* commit = pull () in
  if o.commit = Some commit && Sys.file_exists (Fpath.to_string o.state_path)
  then (
    up_to_date commit;
    Lwt.return_unit)
  else (
    Option.iter set_oom_score_adj o.oom_score_adj;
    let previous = Package_state.load o.state_path in
    if previous.opam_repository_commit = Some commit then (
      up_to_date commit;
      Lwt.return_unit)
    else
      let+ v =
        Logs.info (fun m -> m "Update server state");
        Package_state.rebuild ~previous ~commit
      in
      Package_state.write o.state_path v;
      Logs.info (fun m -> m "Package state saved"))

let () =
  Logs.set_reporter (Logs.format_reporter ());
  Logs.set_level (Some Info);
  let o = parse_args (List.tl (Array.to_list Sys.argv)) in
  Option.iter (fun n -> ignore (Unix.nice n)) o.nice;
  let state_ok =
    match Lwt_main.run (build o) with
    | () -> true
    | exception e ->
        Logs.err (fun m ->
            m "Failed to update the package state: %s" (Printexc.to_string e));
        false
  in
  let index_ok = Lwt_main.run (Doc_modules_fetch.run Paths.doc_modules) in
  if not state_ok then exit 1
  else if o.require_doc_modules && not index_ok then (
    Logs.err (fun m ->
        m "No valid doc-modules index at %a" Fpath.pp Paths.doc_modules);
    exit 1)
  else exit 0
