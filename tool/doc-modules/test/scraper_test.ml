(* The doc-modules scraper: unit tests of its parts, then end-to-end scrapes
   against the mock documentation backend (mock_backend.exe, started here). *)

module S = Doc_modules_scraper

let strings = Alcotest.(list string)
let ok = function Ok v -> v | Error e -> Alcotest.fail e
let is_error = function Ok _ -> false | Error _ -> true

(* Sidebar *)

let sidebar_json =
  {|[{"node":{"kind":"library","content":"lib"},"children":[
  {"node":{"kind":"page","content":"index"},"children":[
    {"node":{"kind":"module","content":"Paged"},"children":[]}]},
  {"node":{"kind":"module","content":"A"},"children":[
    {"node":{"kind":"module","content":"B"},"children":[
      {"node":{"kind":"module","content":"C"},"children":[
        {"node":{"kind":"module","content":"D"},"children":[]}]}]},
    {"node":{"kind":"module-type","content":"S"},"children":[]}]},
  {"node":{"kind":"module","content":"Bad\n"},"children":[]},
  {"node":{"kind":"module","content":"lower"},"children":[]},
  {"node":{"kind":"module","content":"X"},"children":[
    {"node":{"kind":"module","content":"Y\n"},"children":[]}]}]},
 {"node":{"kind":"source","content":"src"},"children":[
   {"node":{"kind":"module","content":"Src"},"children":[]}]}]|}

let sidebar ?(max_paths = 500) s = S.Sidebar.of_string ~max_depth:3 ~max_paths s

let sidebar_tests () =
  Alcotest.check strings
    "paths: nesting capped at 3, module types, pages and libraries add no \
     segment, source skipped, invalid names dropped, shallowest first"
    [ "A"; "Paged"; "X"; "A.B"; "A.S"; "A.B.C" ]
    (ok (sidebar sidebar_json));
  Alcotest.check strings "path cap"
    [ "A"; "Paged"; "X"; "A.B" ]
    (ok (sidebar ~max_paths:4 sidebar_json));
  let many =
    Yojson.Safe.to_string
      (`List
         (List.init 600 (fun i ->
              `Assoc
                [
                  ( "node",
                    `Assoc
                      [
                        ("kind", `String "module");
                        ("content", `String (Printf.sprintf "M%d" (1000 + i)));
                      ] );
                  ( "children",
                    `List
                      [
                        `Assoc
                          [
                            ( "node",
                              `Assoc
                                [
                                  ("kind", `String "module");
                                  ("content", `String "N");
                                ] );
                          ];
                      ] );
                ])))
  in
  let paths = ok (sidebar many) in
  Alcotest.(check int) "at most 500 paths" 500 (List.length paths);
  Alcotest.(check bool)
    "the top-level ones" true
    (List.for_all (fun p -> not (String.contains p '.')) paths);
  Alcotest.check strings "a node without children" [ "Eps" ]
    (ok (sidebar {|[{"node":{"kind":"module","content":"Eps"}}]|}));
  Alcotest.check strings "no modules" []
    (ok
       (sidebar {|[{"node":{"kind":"page","content":"index"},"children":[]}]|}));
  List.iter
    (fun (what, s) ->
      Alcotest.(check bool)
        ("not a sidebar: " ^ what) true
        (is_error (sidebar s)))
    [
      ("empty array", "[]");
      ("empty body", "");
      ("HTML", "<html>not json");
      ("object", {|{"node":{}}|});
      ("module without a name", {|[{"node":{"kind":"module"}}]|});
      ("truncated", {|[{"node":|});
    ]

(* State *)

let docs version = Some { S.State.version; modules = [ "M" ]; etag = Some "e" }

let entry ?(docs = None) candidates =
  { S.State.latest = List.hd candidates; candidates; docs }

let attempts ?(day = 0) previous candidates =
  S.State.attempts ~day ~every:7 "pkg" previous candidates
  |> Option.map
       (List.map (fun (a : S.State.attempt) ->
            a.version ^ if a.conditional then ":1" else ":0"))

let opt_strings = Alcotest.(option (list string))

let state_tests () =
  let c = [ "3"; "2"; "1" ] in
  Alcotest.check opt_strings "unknown: every candidate"
    (Some [ "3:0"; "2:0"; "1:0" ])
    (attempts None c);
  Alcotest.check opt_strings "docs from the latest: revalidate it first"
    (Some [ "3:1"; "2:0"; "1:0" ])
    (attempts (Some (entry ~docs:(docs "3") c)) c);
  Alcotest.check opt_strings
    "docs from an older version: the latest first, then revalidate"
    (Some [ "3:0"; "2:1"; "1:0" ])
    (attempts (Some (entry ~docs:(docs "2") c)) c);
  let due_day =
    List.find
      (fun d -> S.State.due ~day:d ~every:7 "pkg")
      [ 0; 1; 2; 3; 4; 5; 6 ]
  in
  Alcotest.(check int)
    "re-probed on one day of seven" 1
    (List.length
       (List.filter
          (fun d -> S.State.due ~day:d ~every:7 "pkg")
          [ 0; 1; 2; 3; 4; 5; 6 ]));
  let quiet = (due_day + 1) mod 7 in
  Alcotest.check opt_strings "no docs, same candidates: not asked" None
    (attempts ~day:quiet (Some (entry c)) c);
  Alcotest.check opt_strings "no docs, its re-probe day"
    (Some [ "3:0"; "2:0"; "1:0" ])
    (attempts ~day:due_day (Some (entry c)) c);
  Alcotest.check opt_strings "no docs, new candidates"
    (Some [ "4:0"; "3:0"; "2:0"; "1:0" ])
    (attempts ~day:quiet (Some (entry c)) ("4" :: c));
  let t =
    S.State.M.empty
    |> S.State.M.add "a" (entry ~docs:(docs "2") c)
    |> S.State.M.add "b" (entry c)
    |> S.State.M.add "c"
         (entry
            ~docs:
              (Some
                 {
                   S.State.version = "1";
                   modules = [ "C"; "C.D" ];
                   etag = None;
                 })
            [ "1" ])
  in
  let back = ok (S.State.of_string (S.State.to_string t)) in
  Alcotest.(check bool) "round trip" true (S.State.M.equal ( = ) t back);
  Alcotest.(check bool) "garbled" true (is_error (S.State.of_string "not json"));
  Alcotest.(check bool)
    "another version" true
    (is_error
       (S.State.of_string
          {|{"format":"ocamlorg-doc-modules-state","version":1}|}))

(* Listing *)

let mkdir_p path =
  let rec go p =
    if not (Sys.file_exists p) then (
      go (Filename.dirname p);
      Sys.mkdir p 0o755)
  in
  go path

let listing_tests () =
  let repo = Filename.temp_dir "doc-modules-repo" "" in
  let package name versions =
    List.iter
      (fun v ->
        mkdir_p
          (Filename.concat repo
             (Printf.sprintf "packages/%s/%s.%s" name name v)))
      versions
  in
  package "a" [ "1.9"; "1.10"; "1.10~beta"; "1.0~rc1"; "1.0" ];
  package "b" [ "0.1" ];
  mkdir_p (Filename.concat repo "packages/empty");
  Alcotest.(check (list (pair string (list string))))
    "opam version order, newest first, at most 4; no version: not listed"
    [ ("a", [ "1.10"; "1.10~beta"; "1.9"; "1.0" ]); ("b", [ "0.1" ]) ]
    (S.Scrape.listing ~limit:0 repo);
  Alcotest.(check int) "limit" 1 (List.length (S.Scrape.listing ~limit:1 repo));
  Alcotest.(check int)
    "no packages directory" 0
    (List.length (S.Scrape.listing ~limit:0 (Filename.concat repo "nowhere")))

(* Stats and policy *)

let stats_tests () =
  Alcotest.(check (option int))
    "HTTP date" (Some 1767225600)
    (S.Stats.parse_http_date "Thu, 01 Jan 2026 00:00:00 GMT");
  Alcotest.(check (option int))
    "not a date" None
    (S.Stats.parse_http_date "soon");
  Alcotest.(check bool)
    "malformed stats" true
    (is_error (S.Stats.runs_of_string "not json"));
  Alcotest.(check bool)
    "a record without started" true
    (is_error (S.Stats.runs_of_string {|{"status":"scraped"}|}));
  Alcotest.(check int)
    "a minimal aborted record (from the workflow)" 1
    (List.length
       (ok
          (S.Stats.runs_of_string
             {|{"started":1,"finished":2,"status":"aborted","reason":"x"}|})))

let decide ?(force = false) ~now lines =
  S.Policy.decide ~now ~force
    (ok (S.Stats.runs_of_string (String.concat "\n" lines)))

let policy_tests () =
  let now = 2_000_000_000 in
  let d = decide ~now [] in
  Alcotest.(check bool) "no stats: due" true d.due;
  Alcotest.(check int) "no stats: the longest interval" 86400 d.interval;
  let recent =
    Printf.sprintf {|{"started":%d,"status":"scraped","last_modified":[]}|}
      (now - 600)
  in
  Alcotest.(check bool) "recent run: not due" false (decide ~now [ recent ]).due;
  Alcotest.(check bool) "forced" true (decide ~force:true ~now [ recent ]).due;
  let aborted =
    Printf.sprintf {|{"started":%d,"status":"aborted"}|} (now - 600)
  in
  Alcotest.(check bool)
    "recent abort: not due" false (decide ~now [ aborted ]).due;
  let day = 86400 in
  (* batches every 2 days: polls every 12 hours *)
  let batches =
    Printf.sprintf
      {|{"started":%d,"status":"scraped","last_modified":[%d,%d,%d]}|}
      (now - (13 * 3600))
      (now - (6 * day))
      (now - (4 * day))
      (now - (2 * day))
  in
  let d = decide ~now [ batches ] in
  Alcotest.(check int) "interval from batches" 43200 d.interval;
  Alcotest.(check int) "batches" 3 (List.length d.batches);
  Alcotest.(check bool) "due after the interval" true d.due;
  (* times closer than the batch gap are one batch *)
  let close =
    Printf.sprintf
      {|{"started":%d,"status":"scraped","last_modified":[%d,%d,%d]}|}
      (now - 600) (now - day)
      (now - day + 60)
      (now - day + 7000)
  in
  Alcotest.(check int)
    "one batch" 1
    (List.length (decide ~now [ close ]).batches);
  (* aborted runs' times do not count *)
  let aborted_times =
    Printf.sprintf {|{"started":%d,"status":"aborted","last_modified":[%d]}|}
      (now - 600) (now - day)
  in
  Alcotest.(check int)
    "aborted runs' times ignored" 0
    (List.length (decide ~now [ aborted_times ]).batches);
  Alcotest.(check string)
    "outputs" "due=true\ninterval=43200\nbatches=3\n" (S.Policy.outputs d);
  let summary = S.Policy.summary ~now ~force:false d in
  Alcotest.(check bool)
    "summary" true
    (String.length summary > 0
    && List.exists
         (fun l -> l = "| polling interval | 12 h |")
         (String.split_on_char '\n' summary))

(* Http *)

let http_tests () =
  Alcotest.(check bool)
    "gunzip of garbage" true
    (is_error (S.Http.gunzip "nope"))

(* End to end, against the mock backend. *)

let tmp = Filename.temp_dir "doc-modules-e2e" ""
let path p = Filename.concat tmp p
let backend = path "backend"
let repo = path "repo"
let state_dir = path "state"
let output = path "out.jsonl"
let stats = path "stats.jsonl"
let read p = In_channel.with_open_bin p In_channel.input_all
let write p s = Out_channel.with_open_bin p (fun oc -> output_string oc s)

let rec remove p =
  if Sys.file_exists p then
    if Sys.is_directory p then (
      Array.iter (fun n -> remove (Filename.concat p n)) (Sys.readdir p);
      Sys.rmdir p)
    else Sys.remove p

let mock_url =
  lazy
    (mkdir_p backend;
     let port_file = path "port" in
     let pid =
       Unix.create_process "./mock_backend.exe"
         [| "mock_backend.exe"; backend; port_file |]
         Unix.stdin Unix.stdout Unix.stderr
     in
     at_exit (fun () ->
         (try Unix.kill pid Sys.sigterm with Unix.Unix_error _ -> ());
         remove tmp);
     let rec wait n =
       if Sys.file_exists port_file then read port_file
       else if n = 0 then Alcotest.fail "the mock backend did not start"
       else (
         Unix.sleepf 0.05;
         wait (n - 1))
     in
     Printf.sprintf "http://127.0.0.1:%s/" (wait 200))

let config () =
  {
    S.Scrape.default with
    doc_url = Lazy.force mock_url;
    rate = 1000.;
    max_time = 5.;
    day = 0;
  }

let package name versions =
  List.iter
    (fun v ->
      mkdir_p (path (Printf.sprintf "repo/packages/%s/%s.%s" name name v)))
    versions

let lastmod = ref 1767225600. (* 2026-01-01 *)

let sidebar name version json =
  let dir =
    Filename.concat backend (Printf.sprintf "p/%s/%s/doc" name version)
  in
  mkdir_p dir;
  let file = Filename.concat dir "sidebar.json" in
  write file json;
  Unix.utimes file !lastmod !lastmod

let control name version suffix contents =
  let file =
    Filename.concat backend
      (Printf.sprintf "p/%s/%s/doc/sidebar.json.%s" name version suffix)
  in
  match contents with Some c -> write file c | None -> remove file

let modules ms =
  Printf.sprintf
    {|[{"node":{"kind":"library","content":"lib"},"children":[%s]}]|}
    (String.concat ","
       (List.map
          (Printf.sprintf
             {|{"node":{"kind":"module","content":"%s"},"children":[]}|})
          ms))

let run ?(f = Fun.id) () =
  S.Scrape.run ~config:(f (config ())) ~stats ~repo ~state_dir ~output ()

let line name =
  String.split_on_char '\n' (read output)
  |> List.find_opt (fun l ->
      let needle = Printf.sprintf {|"name":"%s"|} name in
      let n = String.length needle in
      let rec has i =
        i + n <= String.length l && (String.sub l i n = needle || has (i + 1))
      in
      has 0)
  |> Option.value ~default:""

let last field =
  let lines =
    String.split_on_char '\n' (read stats) |> List.filter (( <> ) "")
  in
  Yojson.Safe.Util.member field
    (Yojson.Safe.from_string (List.nth lines (List.length lines - 1)))

let last_int f = Yojson.Safe.Util.to_int (last f)
let last_string f = Yojson.Safe.Util.to_string (last f)

let succeeds what r =
  match r with Ok _ -> () | Error e -> Alcotest.failf "%s: aborted: %s" what e

let aborts what r =
  match r with Ok _ -> Alcotest.failf "%s: did not abort" what | Error e -> e

let contains s sub =
  let n = String.length sub in
  let rec go i =
    i + n <= String.length s && (String.sub s i n = sub || go (i + 1))
  in
  go 0

let count_lines file =
  let p = Filename.concat backend file in
  if Sys.file_exists p then
    List.length (List.filter (( <> ) "") (String.split_on_char '\n' (read p)))
  else 0

let asked ?(version = "") name =
  let p = Filename.concat backend "requests.log" in
  let prefix =
    if version = "" then Printf.sprintf "/p/%s/" name
    else Printf.sprintf "/p/%s/%s/" name version
  in
  if Sys.file_exists p then
    List.length
      (List.filter
         (String.starts_with ~prefix)
         (String.split_on_char '\n' (read p)))
  else 0

let clear_logs () =
  remove (Filename.concat backend "requests.log");
  remove (Filename.concat backend "connections.log")

let compiles () =
  match S.Compile.run ~input:output ~output:(path "out.idx") with
  | Ok _ -> ()
  | Error e -> Alcotest.failf "compile: %s" e

let snapshot () = (read output, read (Filename.concat state_dir "state.jsonl"))

let e2e_basics () =
  package "alpha" [ "1.0"; "2.0" ];
  package "beta" [ "0.1"; "0.2" ] (* docs only for the older version *);
  package "gamma" [ "1.0" ] (* no docs at all *);
  package "delta" [ "1.0" ] (* a sidebar without modules *);
  package "eps" [ "1.0" ] (* a node without children *);
  sidebar "alpha" "2.0" (modules [ "Alpha"; "Alpha_sub" ]);
  sidebar "alpha" "1.0" (modules [ "Old" ]);
  sidebar "beta" "0.1" (modules [ "Beta" ]);
  sidebar "delta" "1.0"
    {|[{"node":{"kind":"page","content":"index"},"children":[]}]|};
  sidebar "eps" "1.0" {|[{"node":{"kind":"module","content":"Eps"}}]|};
  (* 1. First run. *)
  clear_logs ();
  succeeds "first run" (run ());
  Alcotest.(check int)
    "one kept-alive connection" 1
    (count_lines "connections.log");
  Alcotest.(check bool)
    "every request asks for gzip" true
    (List.for_all
       (fun l -> l = "" || String.ends_with ~suffix:" gzip" l)
       (String.split_on_char '\n'
          (read (Filename.concat backend "requests.log"))));
  Alcotest.(check string)
    "latest version with docs"
    {|{"name":"alpha","version":"2.0","modules":["Alpha","Alpha_sub"]}|}
    (line "alpha");
  Alcotest.(check string)
    "fallback to an older version"
    {|{"name":"beta","version":"0.1","modules":["Beta"]}|} (line "beta");
  Alcotest.(check string)
    "node without children" {|{"name":"eps","version":"1.0","modules":["Eps"]}|}
    (line "eps");
  Alcotest.(check string) "no docs: absent" "" (line "gamma");
  Alcotest.(check string) "no modules: absent" "" (line "delta");
  Alcotest.(check string) "stats: scraped" "scraped" (last_string "status");
  Alcotest.(check int) "stats: fetched" 3 (last_int "fetched");
  Alcotest.check strings "stats: changed" [ "alpha"; "beta"; "eps" ]
    Yojson.Safe.Util.(to_list (last "changed_packages") |> List.map to_string);
  Alcotest.(check int)
    "stats: last modified" (int_of_float !lastmod)
    Yojson.Safe.Util.(to_list (last "last_modified") |> List.hd |> to_int);
  compiles ();
  let first = read output in
  let body s = List.tl (String.split_on_char '\n' s) in
  (* 2. Nothing changed: revalidation only (gzip ETags), same data. *)
  succeeds "second run" (run ());
  Alcotest.(check (list string)) "same data" (body first) (body (read output));
  Alcotest.(check int) "stats: nothing fetched" 0 (last_int "fetched");
  Alcotest.(check int) "stats: revalidated" 3 (last_int "unchanged");
  Alcotest.(check int) "stats: nothing changed" 0 (last_int "changed");
  (* 3. One package's docs change. *)
  lastmod := !lastmod +. (2. *. 86400.);
  sidebar "alpha" "2.0" (modules [ "Alpha"; "Alpha_new" ]);
  succeeds "run after a change" (run ());
  Alcotest.(check string)
    "changed package refetched"
    {|{"name":"alpha","version":"2.0","modules":["Alpha","Alpha_new"]}|}
    (line "alpha");
  Alcotest.check strings "stats: one changed" [ "alpha" ]
    Yojson.Safe.Util.(to_list (last "changed_packages") |> List.map to_string);
  (* 4. A failing package keeps its previous data. *)
  control "beta" "0.1" "status" (Some "500");
  succeeds "run with one error"
    (run ~f:(fun c -> { c with max_errors = 100 }) ());
  Alcotest.(check string)
    "failing package kept"
    {|{"name":"beta","version":"0.1","modules":["Beta"]}|} (line "beta");
  Alcotest.(check int) "stats: one error" 1 (last_int "errors");
  control "beta" "0.1" "status" None;
  (* 5. The backend fails everything: abort, nothing changed but the stats. *)
  let before = snapshot () in
  write (Filename.concat backend "status") "503";
  ignore (aborts "all errors" (run ()));
  Alcotest.(check bool) "all errors: unchanged" true (before = snapshot ());
  Alcotest.(check string)
    "all errors: stats aborted" "aborted" (last_string "status");
  (* ... and stops asking once packages fail in a row. *)
  clear_logs ();
  let e =
    aborts "failures in a row"
      (run ~f:(fun c -> { c with max_failures_in_a_row = 2 }) ())
  in
  Alcotest.(check bool) "in a row: reason" true (contains e "in a row");
  Alcotest.(check int)
    "in a row: no request after the second failure" 2
    (count_lines "requests.log");
  Alcotest.(check bool) "in a row: unchanged" true (before = snapshot ());
  (* 6. The backend loses every doc: abort. *)
  write (Filename.concat backend "status") "404";
  let e = aborts "all lost" (run ()) in
  Alcotest.(check bool)
    "all lost: reason" true
    (contains e "have none any more");
  Alcotest.(check bool) "all lost: unchanged" true (before = snapshot ());
  remove (Filename.concat backend "status");
  (* 7. A package removed from the repository is a loss: one of three packages
     with docs is above the limit; a higher limit accepts it. *)
  remove (path "repo/packages/eps");
  let e = aborts "removal" (run ()) in
  Alcotest.(check bool) "removal: reason" true (contains e "or are gone");
  Alcotest.(check bool) "removal: unchanged" true (before = snapshot ());
  succeeds "accepted removal" (run ~f:(fun c -> { c with max_losses = 100 }) ());
  Alcotest.(check string) "removed package gone" "" (line "eps");
  compiles ()

let e2e_empty_listing () =
  let before = snapshot () in
  Sys.rename (path "repo/packages") (path "repo/packages.saved");
  mkdir_p (path "repo/packages");
  let e = aborts "no packages" (run ()) in
  Alcotest.(check bool) "no packages: reason" true (contains e "no package in");
  Alcotest.(check bool) "no packages: unchanged" true (before = snapshot ());
  remove (path "repo/packages");
  ignore (aborts "no packages directory" (run ()));
  Sys.rename (path "repo/packages.saved") (path "repo/packages");
  write (path "header-only.jsonl")
    (List.hd (String.split_on_char '\n' (read output)));
  Alcotest.(check bool)
    "compile refuses no packages" true
    (is_error
       (S.Compile.run ~input:(path "header-only.jsonl")
          ~output:(path "empty.idx")));
  Alcotest.(check bool)
    "no index written" false
    (Sys.file_exists (path "empty.idx"))

(* Packages without docs (gamma, delta) are asked once every retry_days, on a
   day of their own, and at once when their candidate versions change. *)
let e2e_reprobe () =
  let gamma_days = ref [] and delta_days = ref 0 and skipped = ref 0 in
  for d = 0 to 6 do
    clear_logs ();
    succeeds "re-probe run" (run ~f:(fun c -> { c with day = d }) ());
    if asked "gamma" > 0 then gamma_days := d :: !gamma_days;
    if asked "delta" > 0 then incr delta_days;
    skipped := !skipped + last_int "skipped"
  done;
  Alcotest.(check int)
    "gamma asked on one day of seven" 1 (List.length !gamma_days);
  Alcotest.(check int) "delta asked on one day of seven" 1 !delta_days;
  Alcotest.(check int) "each skipped the six other days" 12 !skipped;
  let quiet = (List.hd !gamma_days + 1) mod 7 in
  clear_logs ();
  succeeds "quiet day" (run ~f:(fun c -> { c with day = quiet }) ());
  Alcotest.(check int) "not asked on a quiet day" 0 (asked "gamma");
  package "gamma" [ "2.0" ];
  clear_logs ();
  succeeds "new version" (run ~f:(fun c -> { c with day = quiet }) ());
  Alcotest.(check int)
    "asked after a new version, both candidates" 2 (asked "gamma");
  succeeds "every day" (run ~f:(fun c -> { c with retry_days = 1 }) ());
  Alcotest.(check int)
    "nothing skipped with retry_days 1" 0 (last_int "skipped")

(* A timeout, a truncated body and a garbled body are errors, and the package
   keeps its data; the next request still goes through. *)
let e2e_transfer_failures () =
  let alpha = line "alpha" in
  List.iter
    (fun mode ->
      control "alpha" "2.0" "mode" (Some mode);
      succeeds mode
        (run ~f:(fun c -> { c with max_errors = 100; max_time = 1. }) ());
      Alcotest.(check int) (mode ^ ": one error") 1 (last_int "errors");
      Alcotest.(check string) (mode ^ ": data kept") alpha (line "alpha");
      Alcotest.(check string)
        (mode ^ ": the others still answered")
        {|{"name":"beta","version":"0.1","modules":["Beta"]}|} (line "beta"))
    [ "slow"; "truncated"; "garbled" ];
  control "alpha" "2.0" "mode" None;
  (* A timeout on a reused connection (beta is asked after alpha) is not sent
     again: the timeout closing the connection is not a stale connection. *)
  control "beta" "0.1" "mode" (Some "slow");
  clear_logs ();
  succeeds "slow on a reused connection"
    (run ~f:(fun c -> { c with max_errors = 100; max_time = 1. }) ());
  Alcotest.(check int) "slow, reused: one error" 1 (last_int "errors");
  Alcotest.(check int)
    "slow, reused: asked once" 1
    (asked ~version:"0.1" "beta");
  Alcotest.(check int)
    "slow, reused: one new connection after the timeout" 2
    (count_lines "connections.log");
  control "beta" "0.1" "mode" None;
  succeeds "after transfer failures" (run ());
  Alcotest.(check int) "no error" 0 (last_int "errors")

let e2e_invalid_names () =
  package "nl" [ "1.0" ];
  sidebar "nl" "1.0"
    {|[{"node":{"kind":"module","content":"Good"}},{"node":{"kind":"module","content":"Bad\n"}}]|};
  succeeds "newline in a name" (run ());
  Alcotest.(check string)
    "dropped" {|{"name":"nl","version":"1.0","modules":["Good"]}|} (line "nl");
  compiles ()

(* Requests start at most [rate] per second. *)
let e2e_rate () =
  let rate = 20. and n = 6 in
  let http = S.Http.create ~rate ~max_time:5. in
  let uri = Uri.of_string (Lazy.force mock_url ^ "p/none/1/doc/sidebar.json") in
  let t0 = Unix.gettimeofday () in
  Lwt_main.run
    (Lwt_list.iter_s
       (fun _ -> Lwt.map ignore (S.Http.get http uri))
       (List.init n Fun.id));
  let elapsed = Unix.gettimeofday () -. t0 in
  S.Http.close http;
  Alcotest.(check int) "requests" n (S.Http.requests http);
  Alcotest.(check bool)
    (Printf.sprintf "%d requests at %g per second took %.3f s" n rate elapsed)
    true
    (elapsed >= float (n - 1) /. rate)

(* Without docs in the state, losses count against the baseline, the published
   index: a run from scratch while the backend has lost the docs aborts. *)
let e2e_damaged_state () =
  compiles ();
  let baseline c = { c with S.Scrape.baseline = Some (path "out.idx") } in
  let before = read output in
  write (Filename.concat state_dir "state.jsonl") "garbage";
  write (Filename.concat backend "status") "404";
  let e = aborts "from scratch, docs lost" (run ~f:baseline ()) in
  Alcotest.(check bool)
    "from scratch, docs lost: reason" true
    (contains e "have none any more");
  Alcotest.(check string)
    "from scratch, docs lost: unchanged" before (read output);
  remove (Filename.concat backend "status");
  write (path "bad.idx") "garbage";
  let e =
    aborts "unreadable baseline"
      (run ~f:(fun c -> { c with baseline = Some (path "bad.idx") }) ())
  in
  Alcotest.(check bool)
    "unreadable baseline: reason" true
    (contains e "cannot read the baseline");
  write (Filename.concat state_dir "state.jsonl") "garbage";
  succeeds "a damaged state: refetch" (run ~f:baseline ());
  Alcotest.(check int) "refetched" 0 (last_int "unchanged");
  Alcotest.(check string)
    "same data" {|{"name":"nl","version":"1.0","modules":["Good"]}|} (line "nl")

let () =
  Alcotest.run "doc_modules_scraper"
    [
      ( "units",
        [
          Alcotest.test_case "sidebar" `Quick sidebar_tests;
          Alcotest.test_case "state" `Quick state_tests;
          Alcotest.test_case "listing" `Quick listing_tests;
          Alcotest.test_case "stats" `Quick stats_tests;
          Alcotest.test_case "policy" `Quick policy_tests;
          Alcotest.test_case "http" `Quick http_tests;
        ] );
      ( "end to end",
        [
          Alcotest.test_case "basics" `Quick e2e_basics;
          Alcotest.test_case "empty listing" `Quick e2e_empty_listing;
          Alcotest.test_case "re-probe schedule" `Quick e2e_reprobe;
          Alcotest.test_case "transfer failures" `Quick e2e_transfer_failures;
          Alcotest.test_case "rate limit" `Quick e2e_rate;
          Alcotest.test_case "invalid names" `Quick e2e_invalid_names;
          Alcotest.test_case "damaged state" `Quick e2e_damaged_state;
        ] );
    ]
