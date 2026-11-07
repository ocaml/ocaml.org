(* ocamlorg-package-builder [--nice N] [--commit SHA] [--oom-score-adj N]
   STATE_PATH

   Bring the opam-repository clone at [OCAMLORG_REPO_PATH] up to date (cloning
   it if it is missing), rebuild the package state saved at STATE_PATH if the
   clone has moved, write it, and exit. A missing or unreadable state, or one
   saved by another version, is rebuilt from scratch; otherwise only what
   changed since the saved commit is re-read where possible. Exits with 0 once
   STATE_PATH is up to date, whether or not it had to be written, and with 1 on
   any failure, leaving STATE_PATH as it was.

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
  state_path : Fpath.t;
}

let usage () =
  prerr_endline
    "usage: ocamlorg-package-builder [--nice N] [--commit SHA] \
     [--oom-score-adj N] STATE_PATH";
  exit 2

let int_arg n = match int_of_string_opt n with Some n -> n | None -> usage ()

let parse_args args =
  let rec go o = function
    | "--nice" :: n :: tl -> go { o with nice = Some (int_arg n) } tl
    | "--commit" :: c :: tl -> go { o with commit = Some c } tl
    | "--oom-score-adj" :: n :: tl ->
        go { o with oom_score_adj = Some (int_arg n) } tl
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
      state_path = Fpath.v ".";
    }
    args

(* Not fatal: the builder still works, it is only not the first one killed. *)
let set_oom_score_adj n =
  match
    Out_channel.with_open_text "/proc/self/oom_score_adj" (fun oc ->
        Out_channel.output_string oc (string_of_int n))
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
  match Lwt_main.run (build o) with
  | () -> exit 0
  | exception e ->
      Logs.err (fun m ->
          m "Failed to update the package state: %s" (Printexc.to_string e));
      exit 1
