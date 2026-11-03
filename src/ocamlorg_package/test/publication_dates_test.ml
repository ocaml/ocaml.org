(* Publication dates read incrementally from [old..new] must match a scan of the
   whole history. The history is a throwaway Git repository with fixed commit
   times, shaped like opam-repository: a merge commit (first-parent diff), and
   an opam file removed then added back. *)

module Package = Ocamlorg_package

let git repo args =
  let cmd =
    Filename.quote_command "git"
      ("-c" :: "commit.gpgsign=false" :: "-c" :: "core.hooksPath=/dev/null"
     :: "-C" :: repo :: args)
  in
  let ic = Unix.open_process_in cmd in
  let out = In_channel.input_all ic in
  match Unix.close_process_in ic with
  | WEXITED 0 -> String.trim out
  | _ -> Alcotest.failf "command failed: %s" cmd

let commit repo time msg =
  Unix.putenv "GIT_AUTHOR_DATE" (Printf.sprintf "@%d +0000" time);
  Unix.putenv "GIT_COMMITTER_DATE" (Printf.sprintf "@%d +0000" time);
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

type history = { repo : string; old : string; new_ : string }

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
  let env = [ "GIT_AUTHOR_NAME"; "GIT_COMMITTER_NAME" ] in
  List.iter (fun v -> Unix.putenv v "Test") env;
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
  let _ = commit repo 3000 "c.1 on a side branch" in
  ignore (git repo [ "checkout"; "-q"; "master" ]);
  add_opam repo "b.2";
  let _ = commit repo 4000 "b.2" in
  Unix.putenv "GIT_COMMITTER_DATE" "@5000 +0000";
  Unix.putenv "GIT_AUTHOR_DATE" "@5000 +0000";
  ignore (git repo [ "merge"; "-q"; "--no-ff"; "-m"; "merge side"; "side" ]);
  ignore (git repo [ "rm"; "-q"; "packages/a/a.2/opam" ]);
  let _ = commit repo 6000 "remove a.2" in
  add_opam repo "a.2";
  let new_ = commit repo 7000 "a.2 again" in
  { repo; old; new_ }

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

(* The packages present at [new_]. *)
let opams = packages_map ignore expected
let state dates = packages_map info dates

let compute previous =
  let h = Lazy.force history in
  Lwt_main.run
    (Package.Publication_dates.compute ~repo:(Fpath.v h.repo) ~previous
       ~commit:h.new_ opams)

let dates = Alcotest.(list (pair string (float 0.)))

let check msg want got =
  let got =
    OpamPackage.Map.bindings got
    |> List.map (fun (p, t) -> (OpamPackage.to_string p, t))
  in
  Alcotest.check dates msg want got

let with_date pkg t =
  List.map (fun (p, d) -> if p = pkg then (p, t) else (p, d))

(* The state at [old], with a date for b.1 that no Git commit carries: it is
   kept only when the incremental path is taken. *)
let old_state = [ ("a.1", 1000.); ("a.2", 2000.); ("b.1", 42.) ]
let test_full () = check "full history" expected (compute (None, state []))

let test_incremental () =
  let h = Lazy.force history in
  check "dates of untouched versions come from the state"
    (with_date "b.1" 42. expected)
    (compute (Some h.old, state old_state))

let test_not_ancestor () =
  check "unknown commit: full history" expected
    (compute (Some (String.make 40 'f'), state old_state))

let test_missing_date () =
  let h = Lazy.force history in
  (* b.1 was present at [old] but is not in the state (e.g. its opam file did
     not parse then): the range can't date it. *)
  check "version without a date: full history" expected
    (compute (Some h.old, state [ ("a.1", 1000.); ("a.2", 2000.) ]))

let test_matches_full_at_every_commit () =
  let h = Lazy.force history in
  (* Starting from the real dates at [old] gives exactly the full scan. *)
  check "incremental equals full" expected
    (compute
       (Some h.old, state [ ("a.1", 1000.); ("a.2", 2000.); ("b.1", 1000.) ]))

let () =
  Alcotest.run "Publication_dates"
    [
      ( "compute",
        [
          Alcotest.test_case "full history" `Quick test_full;
          Alcotest.test_case "incremental from an ancestor" `Quick
            test_incremental;
          Alcotest.test_case "falls back when not an ancestor" `Quick
            test_not_ancestor;
          Alcotest.test_case "falls back when a date is missing" `Quick
            test_missing_date;
          Alcotest.test_case "incremental equals full" `Quick
            test_matches_full_at_every_commit;
        ] );
    ]
