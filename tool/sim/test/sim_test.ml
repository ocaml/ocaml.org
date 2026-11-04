open Sim

let commits l =
  Array.of_list (List.map (fun (sha, time) -> { Upstream.sha; time }) l)

let test_select () =
  let h = commits [ ("a", 100.); ("b", 200.); ("c", 200.); ("d", 350.) ] in
  let sel t = h.(Upstream.select h t).sha in
  Alcotest.(check string) "before first" "a" (sel 50.);
  Alcotest.(check string) "at first" "a" (sel 100.);
  Alcotest.(check string) "between" "a" (sel 199.);
  Alcotest.(check string) "ties take the last" "c" (sel 200.);
  Alcotest.(check string) "past the end" "d" (sel 1e9)

let test_feed_offsets () =
  let h = commits [ ("a", 1000.); ("b", 1720.); ("c", 1720.); ("d", 8200.) ] in
  let off i = Upstream.offset ~h ~speedup:720. i in
  Alcotest.(check (list (float 1e-9)))
    "one commit at a time, at (time - start) / speedup" [ 0.; 1.; 1.; 10. ]
    (List.map off [ 0; 1; 2; 3 ])

let test_parse_log () =
  (* git log prints newest first *)
  let h = Upstream.parse_log "ccc 300\nbbb 200\n\naaa 100\n" in
  Alcotest.(check (list string))
    "oldest first" [ "aaa"; "bbb"; "ccc" ]
    (Array.to_list (Array.map (fun c -> c.Upstream.sha) h))

let test_profile_roundtrip () =
  let p =
    {
      Profile.source = "test";
      base_rps = 2.5;
      hourly = Profile.normalise_hourly (Array.init 24 float_of_int);
      pages =
        [| { path = "/"; weight = 3. }; { path = "/p/{pkg}"; weight = 1. } |];
    }
  in
  let p' = Profile.of_json (Profile.to_json p) in
  Alcotest.(check string) "source" p.source p'.source;
  Alcotest.(check (float 1e-9)) "rate" p.base_rps p'.base_rps;
  Alcotest.(check (float 1e-9))
    "hourly mean is 1" 1.
    (Array.fold_left ( +. ) 0. p'.hourly /. 24.);
  Alcotest.(check int) "pages" 2 (Array.length p'.pages)

let test_pick () =
  let p =
    {
      Profile.source = "";
      base_rps = 1.;
      hourly = Array.make 24 1.;
      pages = [| { path = "/a"; weight = 1. }; { path = "/b"; weight = 3. } |];
    }
  in
  let s = Profile.sampler p in
  Alcotest.(check string) "low" "/a" (Profile.pick s 0.1);
  Alcotest.(check string) "high" "/b" (Profile.pick s 0.3);
  Alcotest.(check string) "top" "/b" (Profile.pick s 0.999)

let test_classify () =
  List.iter
    (fun (path, cls) ->
      Alcotest.(check string) path cls (Profile.classify path))
    [
      ("/", "home");
      ("/p/dune", "pkg");
      ("/p/dune/3.17.0", "pkg-ver");
      ("/p/dune/3.17.0/doc/index.html", "pkg-doc");
      ("/css/main.css", "static");
      ("/docs/tour-of-ocaml", "learn");
      ("/packages/search?q=json", "packages");
    ]

(* A trimmed Plausible v2 response for each of the three queries. *)
let plausible_total =
  {|{"results":[{"metrics":[86400],"dimensions":[]}],"meta":{}}|}

let plausible_hours =
  {|{"results":[
    {"metrics":[10],"dimensions":["2026-10-01 00:00:00"]},
    {"metrics":[30],"dimensions":["2026-10-01 12:00:00"]},
    {"metrics":[20],"dimensions":["2026-10-02T12:00:00Z"]}]}|}

let plausible_pages =
  {|{"results":[
    {"metrics":[50000],"dimensions":["/"]},
    {"metrics":[20000],"dimensions":["/p/dune"]},
    {"metrics":[6000],"dimensions":["/p/dune/3.17.0"]}]}|}

let test_plausible () =
  let rows s = Plausible.rows (Yojson.Safe.from_string s) in
  let p =
    Plausible.profile ~site:"ocaml.org" ~period:"day"
      ~total_rows:(rows plausible_total) ~hour_rows:(rows plausible_hours)
      ~page_rows:(rows plausible_pages)
  in
  Alcotest.(check (float 1e-9)) "rate" 1. p.base_rps;
  Alcotest.(check bool)
    "noon busier than midnight" true
    (p.hourly.(12) > p.hourly.(0));
  let w path =
    Array.fold_left
      (fun acc (pg : Profile.page) -> if pg.path = path then pg.weight else acc)
      0. p.pages
  in
  (* tail = 86400 - 76000 = 10400, split 20000:6000 between pkg and pkg-ver *)
  Alcotest.(check (float 1e-6)) "pkg tail" 8000. (w "/p/{pkg}");
  Alcotest.(check (float 1e-6)) "pkg-ver tail" 2400. (w "/p/{pkg}/{ver}")

let test_access_log () =
  let lines =
    List.to_seq
      [
        {|1.2.3.4 - - [03/Nov/2026:13:05:01 +0000] "GET /p/dune HTTP/1.1" 200 5123 "-" "bot"|};
        {|1.2.3.4 - - [03/Nov/2026:13:05:11 +0000] "GET / HTTP/1.1" 200 51 "-" "x"|};
        {|1.2.3.4 - - [03/Nov/2026:14:05:01 +0100] "POST /mcp HTTP/1.1" 200 1 "-" "x"|};
        {|garbage|};
      ]
  in
  let p = Access_log.profile ~source:"t" lines in
  Alcotest.(check (float 1e-9)) "2 GETs over 10s" 0.2 p.base_rps;
  Alcotest.(check bool)
    "13h UTC busiest" true
    (Array.for_all (fun x -> x <= p.hourly.(13)) p.hourly)

let test_log_lines () =
  let c = Server_log.classify in
  let show = function
    | Some (e, s, d) -> Printf.sprintf "%s|%s|%s" e s d
    | None -> "-"
  in
  List.iter
    (fun (line, expect) -> Alcotest.(check string) line expect (show (c line)))
    [
      ( "03.11.26 12:00:01.000    ocamlorg_package  INFO Compute package info: \
         12.34s",
        "phase|12.34|Compute package info" );
      ("Read opam files: 0.50s", "phase|0.50|Read opam files");
      ("03.11.26 12:00:00.000  INFO Opam repo: git pull", "pull||");
      ("INFO Loaded 4321 packages", "loaded||4321");
      ("INFO Package state saved", "saved||");
      ("INFO Opam repository is currently at 0fae6c68", "at||0fae6c68");
      ("INFO State cache file: /var/package.state", "-");
    ]

let test_summary_percentile () =
  let a = [| 1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10. |] in
  Alcotest.(check (float 0.)) "p50" 5. (Summary.percentile a 0.5);
  Alcotest.(check (float 0.)) "p90" 9. (Summary.percentile a 0.9);
  Alcotest.(check (float 0.)) "max" 10. (Summary.percentile a 1.0)

let test_quantile_display () =
  let a n = Array.init n float_of_int in
  (* 50 samples: one lies above p98, none above p99.9 *)
  Alcotest.(check string) "p99.9 needs 1000" "-" (Summary.quantile (a 50) 0.999);
  Alcotest.(check string)
    "few above: marked" "48.0*"
    (Summary.quantile (a 50) 0.97);
  Alcotest.(check string) "enough above" "49.0" (Summary.quantile (a 100) 0.5)

let check_mmu label expect got =
  match got with
  | None -> Alcotest.fail (label ^ ": no result")
  | Some (u, _) -> Alcotest.(check (float 1e-9)) label expect u

let test_mmu () =
  (* pauses of 10 ms at t = 1.0 and 1.015 (5 ms apart), and 1 ms at t = 5 *)
  let ivs = [ (1.0, 1.01); (1.015, 1.025); (5.0, 5.001) ] in
  let mmu w = Summary.mmu ivs ~lo:0. ~hi:10. w in
  check_mmu "1 ms window inside a pause" 0. (mmu 0.001);
  check_mmu "10 ms window" 0. (mmu 0.01);
  (* worst 25 ms window covers both pauses: 20 ms paused *)
  check_mmu "25 ms window" 0.2 (mmu 0.025);
  (* the pause at t = 5 is too far to share a 1 s window with the others *)
  check_mmu "1 s window" 0.98 (mmu 1.);
  Alcotest.(check bool)
    "span too short" true
    (Summary.mmu ivs ~lo:0. ~hi:1. 2. = None);
  check_mmu "overlapping pauses merge" 0.5
    (Summary.mmu [ (0., 0.4); (0.2, 0.5) ] ~lo:0. ~hi:2. 1.)

let test_cpu_seconds () =
  let s st cpu = { Summary.st; mem = nan; rss = nan; cpu } in
  (* 100% of a core from 0 to 2, 50% from 2 to 4 *)
  let samples = [| s 0. nan; s 1. 100.; s 2. 100.; s 3. 50.; s 4. 50. |] in
  Alcotest.(check (float 1e-9)) "all" 3. (Summary.cpu_seconds samples 0. 4.);
  Alcotest.(check (float 1e-9))
    "partial" 1.25
    (Summary.cpu_seconds samples 1.5 3.5)

let test_slope () =
  Alcotest.(check (option (float 1e-9)))
    "linear" (Some 2.)
    (Summary.slope [ 1.; 3.; 5.; 7. ]);
  Alcotest.(check (option (float 1e-9)))
    "too few" None
    (Summary.slope [ 1.; 2. ])

let test_windows () =
  Alcotest.(check (list (pair (float 0.) (float 0.))))
    "update -> saved, and update -> loaded when not saved"
    [ (1., 5.); (10., 12.) ]
    (Summary.windows_of_events
       [
         (0., "pull");
         (1., "update");
         (4., "loaded");
         (5., "saved");
         (10., "update");
         (12., "loaded");
       ])

let plan_profile =
  {
    Profile.source = "";
    base_rps = 5.;
    hourly =
      Profile.normalise_hourly (Array.init 24 (fun h -> float_of_int (h + 1)));
    pages =
      [|
        { path = "/"; weight = 1. }; { path = "/p/{pkg}/{ver}"; weight = 2. };
      |];
  }

let plan_packages =
  [| ("dune", [| "3.16.0"; "3.17.0" |]); ("lwt", [| "5.9.0" |]) |]

let make_plan ?(bot = true) seed =
  let human =
    Traffic.human ~seed ~profile:plan_profile ~packages:plan_packages ~scale:1.
      ~hour_of:(fun offset -> int_of_float (offset /. 60.))
  in
  let bot =
    if bot then
      [
        Traffic.crawler ~seed ~packages:plan_packages ~rps:3.
          ~include_docs:false;
      ]
    else []
  in
  Traffic.plan ~seed ~duration:600. (human :: bot)

let show (p : Traffic.planned) =
  Printf.sprintf "%.9f %s %d %s" p.offset p.stream p.id p.path

let test_plan_deterministic () =
  let a = Array.map show (make_plan 42) and b = Array.map show (make_plan 42) in
  Alcotest.(check (array string)) "same seed, same plan" a b;
  Alcotest.(check bool)
    "another seed, another plan" false
    (Array.map show (make_plan 7) = a)

let test_plan_streams_independent () =
  let human l =
    Array.to_list l
    |> List.filter (fun (p : Traffic.planned) -> p.stream = "human")
    |> List.map show
  in
  Alcotest.(check (list string))
    "the human plan does not depend on the bot stream"
    (human (make_plan ~bot:false 42))
    (human (make_plan 42))

let test_plan_rate () =
  let p = make_plan 42 in
  let count s =
    Array.fold_left
      (fun n (x : Traffic.planned) -> if x.stream = s then n + 1 else n)
      0 p
  in
  (* bot: 3 rps over 600 s; human: mean of hours 0..9 of the curve *)
  let expect_human =
    5.
    *. (Array.fold_left ( +. ) 0. (Array.sub plan_profile.hourly 0 10) /. 10.)
    *. 600.
  in
  let close label expect n =
    Alcotest.(check bool)
      (Printf.sprintf "%s: %d near %.0f" label n expect)
      true
      (Float.abs (float_of_int n -. expect) < 4. *. sqrt expect)
  in
  close "bot" 1800. (count "bot");
  close "human" expect_human (count "human");
  Alcotest.(check bool)
    "sorted" true
    (Array.for_all2
       (fun (a : Traffic.planned) (b : Traffic.planned) -> a.offset <= b.offset)
       (Array.sub p 0 (Array.length p - 1))
       (Array.sub p 1 (Array.length p - 1)))

let req ?(stream = "bot") ?(status = "200") t ms =
  {
    Summary.t;
    latency_ms = ms;
    status;
    stream;
    cls = "pkg-ver";
    path = "/p/x/1";
    id = None;
  }

let test_bursts () =
  let reqs =
    [
      (* a burst of 3, the next one 10 s later is alone *)
      req 10. 3000.;
      req 12. 2500.;
      req 16. 4000.;
      req 26. 5000.;
      (* fast, and dropped: never part of a burst *)
      req 11. 10.;
      req ~status:"drop" 13. 9000.;
    ]
  in
  match Summary.bursts ~busy:(fun _ -> false) reqs with
  | [ e ] ->
      Alcotest.(check (float 1e-9)) "starts at the first slow request" 10. e.et;
      Alcotest.(check (float 1e-9)) "worst latency" 4000. e.value
  | l -> Alcotest.failf "expected one burst, got %d" (List.length l)

let test_flatten () =
  let j =
    Yojson.Safe.from_string
      {|{"schema":"x","run":{"seed":42},"cpu":{"total_cpu_s":3.5},
         "latency_ms":{"bot":{"all":{"n":10,
           "p99":{"value":null,"samples_above":0,"reliable":false},
           "p50":{"value":4.0,"samples_above":5,"reliable":false}}}},
         "mmu":{"1s":{"window_s":1.0,"utilisation":0.5,"worst_at_s":3.0}}}|}
  in
  let leaves = List.map (fun (p, _, _) -> p) (Compare.flatten j) in
  Alcotest.(check (list string))
    "numeric leaves, percentiles as one leaf, no run parameters or positions"
    [
      "cpu.total_cpu_s";
      "latency_ms.bot.all.n";
      "latency_ms.bot.all.p99";
      "latency_ms.bot.all.p50";
      "mmu.1s.utilisation";
    ]
    leaves

let test_timeline_width () =
  let samples =
    Array.init 30 (fun i ->
        { Summary.st = float_of_int i; mem = 100.; rss = 80.; cpu = 50. })
  in
  let rows =
    Summary.timeline ~bin:10. ~run_end:29.
      ~wins:[ (5., 12.) ]
      ~samples ~pauses:[]
      ~reqs:[ req 3. 5. ]
      ~heap:[]
      ~feed:[ (4., 2) ]
      [ "bot" ]
  in
  let width = List.length (Summary.timeline_header [ "bot" ]) in
  Alcotest.(check int) "three bins" 3 (List.length rows);
  List.iter
    (fun r -> Alcotest.(check int) "row width" width (List.length r))
    rows;
  Alcotest.(check string)
    "update share of bin 0" "0.50"
    (List.nth (List.hd rows) 1)

let pair ?(stream = "bot") ?(cls = "pkg") a b =
  { Compare.stream; cls; a_ms = a; b_ms = b; during_update = false }

let test_paired_groups () =
  let ps = [ pair 10. 5.; pair 10. 20.; pair 10. 8.; pair ~cls:"home" 1. 3. ] in
  let g = Compare.group ps in
  Alcotest.(check int) "pairs" 4 g.n;
  Alcotest.(check (float 1e-9)) "B faster in 2 of 4" 0.5 g.b_faster;
  Alcotest.(check (list string))
    "grouped by class" [ "home"; "pkg" ]
    (List.map fst (Compare.by (fun p -> p.Compare.cls) ps))

let test_slow_overlap () =
  let ps =
    [ pair 3000. 2500.; pair 3000. 400.; pair 500. 2600.; pair 500. 400. ]
  in
  let s = Compare.slow ps in
  Alcotest.(check (list int))
    "both / only A / only B" [ 1; 1; 1 ]
    [ s.both; s.only_a; s.only_b ];
  Alcotest.(check (float 1e-9)) "overlap" (1. /. 3.) s.overlap

let test_docs_stub_kind () =
  List.iter
    (fun (line, k) -> Alcotest.(check string) line k (Docs_stub.kind line))
    [
      ("GET /docs/p/dune/3.17.0/status.json HTTP/1.1", "status_json");
      ("HEAD /docs/p/dune/3.17.0/doc/index.js HTTP/1.1", "head");
      ("GET /docs/p/dune/3.17.0/doc/README.html.json HTTP/1.1", "other");
    ]

let test_packages_of_find () =
  let p =
    Traffic.packages_of_find
      "/var/opam-repository/packages/dune/dune.3.17.0\n\
       /var/opam-repository/packages/dune/dune.3.16.0\n\
       /var/opam-repository/packages/lwt/lwt.5.9.0\n"
  in
  Alcotest.(check int) "two packages" 2 (Array.length p);
  Alcotest.(check int) "two dune versions" 2 (Array.length (snd p.(0)))

let () =
  Alcotest.run "sim"
    [
      ( "upstream",
        [
          Alcotest.test_case "select" `Quick test_select;
          Alcotest.test_case "parse_log" `Quick test_parse_log;
          Alcotest.test_case "feed offsets" `Quick test_feed_offsets;
        ] );
      ( "profile",
        [
          Alcotest.test_case "roundtrip" `Quick test_profile_roundtrip;
          Alcotest.test_case "pick" `Quick test_pick;
          Alcotest.test_case "classify" `Quick test_classify;
          Alcotest.test_case "plausible" `Quick test_plausible;
          Alcotest.test_case "access log" `Quick test_access_log;
        ] );
      ( "analysis",
        [
          Alcotest.test_case "server log" `Quick test_log_lines;
          Alcotest.test_case "percentile" `Quick test_summary_percentile;
          Alcotest.test_case "quantile display" `Quick test_quantile_display;
          Alcotest.test_case "mmu" `Quick test_mmu;
          Alcotest.test_case "cpu seconds" `Quick test_cpu_seconds;
          Alcotest.test_case "slope" `Quick test_slope;
          Alcotest.test_case "windows" `Quick test_windows;
          Alcotest.test_case "packages" `Quick test_packages_of_find;
          Alcotest.test_case "plan deterministic" `Quick test_plan_deterministic;
          Alcotest.test_case "plan streams independent" `Quick
            test_plan_streams_independent;
          Alcotest.test_case "plan rate" `Quick test_plan_rate;
          Alcotest.test_case "bursts" `Quick test_bursts;
          Alcotest.test_case "flatten" `Quick test_flatten;
          Alcotest.test_case "timeline width" `Quick test_timeline_width;
          Alcotest.test_case "paired groups" `Quick test_paired_groups;
          Alcotest.test_case "slow overlap" `Quick test_slow_overlap;
          Alcotest.test_case "docs stub kind" `Quick test_docs_stub_kind;
        ] );
    ]
