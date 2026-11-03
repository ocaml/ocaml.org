(* Publication dates read incrementally from [old..new] must match a scan of the
   whole history. The history is a throwaway Git repository with fixed commit
   times, shaped like opam-repository: a merge commit (first-parent diff), an
   opam file removed then added back, and a branch that is never merged. *)

module Package = Ocamlorg_package

(* Git must only see the throwaway repository: a [GIT_DIR] or [GIT_INDEX_FILE]
   inherited from a Git hook would point it at the enclosing repository, and the
   user's configuration could change its output. OCaml can't unset an
   environment variable, so re-run the test without them. *)
let isolate_git () =
  let wanted = [ "GIT_CONFIG_GLOBAL=/dev/null"; "GIT_CONFIG_NOSYSTEM=1" ] in
  let env = Array.to_list (Unix.environment ()) in
  let is_git v = String.starts_with ~prefix:"GIT_" v in
  if List.sort compare (List.filter is_git env) <> wanted then
    Unix.execve Sys.executable_name Sys.argv
      (Array.of_list (List.filter (fun v -> not (is_git v)) env @ wanted))

let () = isolate_git ()

let git repo args =
  let cmd = Filename.quote_command "git" ("-C" :: repo :: args) in
  let ic = Unix.open_process_in cmd in
  let out = In_channel.input_all ic in
  match Unix.close_process_in ic with
  | WEXITED 0 -> String.trim out
  | _ -> Alcotest.failf "command failed: %s" cmd

let set_time time =
  Unix.putenv "GIT_AUTHOR_DATE" (Printf.sprintf "@%d +0000" time);
  Unix.putenv "GIT_COMMITTER_DATE" (Printf.sprintf "@%d +0000" time)

let commit repo time msg =
  set_time time;
  ignore (git repo [ "commit"; "-q"; "--allow-empty"; "-m"; msg ]);
  git repo [ "rev-parse"; "HEAD" ]

let add_opam repo pkg =
  let name, _ = Scanf.sscanf pkg "%[^.].%s" (fun n v -> (n, v)) in
  let dir = Filename.concat repo (Filename.concat "packages" name) in
  let dir = Filename.concat dir pkg in
  ignore (Sys.command (Filename.quote_command "mkdir" [ "-p"; dir ]));
  Out_channel.with_open_text (Filename.concat dir "opam") (fun oc ->
      Printf.fprintf oc "opam-version: \"2.0\"\nsynopsis: %S\n" pkg);
  ignore (git repo [ "add"; "packages" ])

type history = {
  repo : string;
  old : string;  (** On the first-parent history of [new_]. *)
  side : string;  (** An ancestor of [new_] through a merge's second parent. *)
  stray : string;  (** Not an ancestor of [new_]. *)
  new_ : string;
}

(* Expected dates at [new_], from the first-parent history. *)
let expected =
  [
    ("a.1", 1000.);
    ("a.2", 7000.);
    ("b.1", 1000.);
    ("b.2", 4000.);
    ("c.1", 5000.);
  ]

let make_history () =
  let repo = Filename.temp_dir "publication-dates" "" in
  at_exit (fun () ->
      ignore (Sys.command (Filename.quote_command "rm" [ "-rf"; repo ])));
  List.iter
    (fun v -> Unix.putenv v "Test")
    [ "GIT_AUTHOR_NAME"; "GIT_COMMITTER_NAME" ];
  List.iter
    (fun v -> Unix.putenv v "test@example.org")
    [ "GIT_AUTHOR_EMAIL"; "GIT_COMMITTER_EMAIL" ];
  ignore (git repo [ "init"; "-q"; "-b"; "master" ]);
  add_opam repo "a.1";
  add_opam repo "b.1";
  let _ = commit repo 1000 "a.1, b.1" in
  add_opam repo "a.2";
  let old = commit repo 2000 "a.2" in
  ignore (git repo [ "checkout"; "-q"; "-b"; "side" ]);
  add_opam repo "c.1";
  let side = commit repo 3000 "c.1 on a side branch" in
  ignore (git repo [ "checkout"; "-q"; "master" ]);
  add_opam repo "b.2";
  let _ = commit repo 4000 "b.2" in
  set_time 5000;
  ignore (git repo [ "merge"; "-q"; "--no-ff"; "-m"; "merge side"; "side" ]);
  ignore (git repo [ "rm"; "-q"; "packages/a/a.2/opam" ]);
  let _ = commit repo 6000 "remove a.2" in
  add_opam repo "a.2";
  let new_ = commit repo 7000 "a.2 again" in
  ignore (git repo [ "checkout"; "-q"; "-b"; "stray"; old ]);
  add_opam repo "d.1";
  let stray = commit repo 8000 "d.1, never merged" in
  ignore (git repo [ "checkout"; "-q"; "master" ]);
  { repo; old; side; stray; new_ }

let history = lazy (make_history ())
let opam pkg = OpamPackage.of_string pkg

let packages_map f pkgs =
  List.fold_left
    (fun acc (pkg, x) ->
      let p = opam pkg in
      let name = Package.Name.of_string (OpamPackage.Name.to_string p.name) in
      let version =
        Package.Version.of_string (OpamPackage.Version.to_string p.version)
      in
      let versions =
        Option.value ~default:Package.Version.Map.empty
          (Package.Name.Map.find_opt name acc)
      in
      Package.Name.Map.add name
        (Package.Version.Map.add version (f x) versions)
        acc)
    Package.Name.Map.empty pkgs

let info publication =
  {
    Package.Info.synopsis = "";
    description = "";
    authors = [];
    maintainers = [];
    license = "";
    homepage = [];
    tags = [];
    dependencies = [];
    rev_deps = [];
    depopts = [];
    conflicts = [];
    url = None;
    publication;
    flags = [];
  }

(* The versions present at [commit], as in [read_packages]. *)
let present commit =
  let h = Lazy.force history in
  git h.repo [ "ls-tree"; "-r"; "--name-only"; commit; "packages" ]
  |> String.split_on_char '\n'
  |> List.filter_map (fun path ->
         match String.split_on_char '/' path with
         | [ "packages"; _; pkg; "opam" ] -> Some pkg
         | _ -> None)

let state dates = packages_map info dates

let compute ?commit previous =
  let h = Lazy.force history in
  let commit = Option.value ~default:h.new_ commit in
  let opams =
    packages_map ignore (List.map (fun p -> (p, ())) (present commit))
  in
  Lwt_main.run
    (Package.Publication_dates.compute ~repo:(Fpath.v h.repo) ~previous ~commit
       opams)

let to_list dates =
  OpamPackage.Map.bindings dates
  |> List.map (fun (p, t) -> (OpamPackage.to_string p, t))

let dates = Alcotest.(list (pair string (float 0.)))
let check msg want got = Alcotest.check dates msg want (to_list got)

let with_date pkg t =
  List.map (fun (p, d) -> if p = pkg then (p, t) else (p, d))

(* A state with a date for b.1 that no Git commit carries: it is kept only when
   the incremental path is taken. *)
let marked_state = state [ ("a.1", 1000.); ("a.2", 2000.); ("b.1", 42.) ]
let test_full () = check "full history" expected (compute (None, state []))

let test_incremental () =
  let h = Lazy.force history in
  check "dates of untouched versions come from the state"
    (with_date "b.1" 42. expected)
    (compute (Some h.old, marked_state))

let test_unknown_commit () =
  check "unknown commit: full history" expected
    (compute (Some (String.make 40 'f'), marked_state))

let test_not_ancestor () =
  let h = Lazy.force history in
  check "not an ancestor: full history" expected
    (compute (Some h.stray, marked_state))

let test_other_parent () =
  let h = Lazy.force history in
  (* [side..new_] on the first-parent history misses commits that the full scan
     counts, so it can't be used. *)
  check "ancestor through a second parent: full history" expected
    (compute (Some h.side, marked_state))

let test_missing_date () =
  let h = Lazy.force history in
  (* b.1 was present at [old] but is not in the state (e.g. its opam file did
     not parse then): the range can't date it. *)
  check "version without a date: full history" expected
    (compute (Some h.old, state [ ("a.1", 1000.); ("a.2", 2000.) ]))

let test_every_commit () =
  let h = Lazy.force history in
  (* From every commit on the first-parent history, with the state a full scan
     gives there, the incremental scan gives exactly the full scan at [new_]. *)
  git h.repo [ "rev-list"; "--first-parent"; h.new_ ]
  |> String.split_on_char '\n'
  |> List.iter (fun old ->
         let at_old = to_list (compute ~commit:old (None, state [])) in
         let old_state =
           List.map (fun p -> (p, List.assoc p at_old)) (present old)
         in
         check
           ("incremental from " ^ old)
           expected
           (compute (Some old, state old_state)))

let () =
  Alcotest.run "Publication_dates"
    [
      ( "compute",
        [
          Alcotest.test_case "full history" `Quick test_full;
          Alcotest.test_case "incremental from an ancestor" `Quick
            test_incremental;
          Alcotest.test_case "falls back on an unknown commit" `Quick
            test_unknown_commit;
          Alcotest.test_case "falls back when not an ancestor" `Quick
            test_not_ancestor;
          Alcotest.test_case "falls back off the first-parent history" `Quick
            test_other_parent;
          Alcotest.test_case "falls back when a date is missing" `Quick
            test_missing_date;
          Alcotest.test_case "incremental equals full from every commit" `Quick
            test_every_commit;
        ] );
    ]
