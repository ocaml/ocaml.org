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
      ("INFO State cache file: /var/package.state", "-");
    ]

let test_summary_percentile () =
  let a = [| 1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10. |] in
  Alcotest.(check (float 0.)) "p50" 5. (Summary.percentile a 0.5);
  Alcotest.(check (float 0.)) "p90" 9. (Summary.percentile a 0.9);
  Alcotest.(check (float 0.)) "max" 10. (Summary.percentile a 1.0)

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
          Alcotest.test_case "packages" `Quick test_packages_of_find;
        ] );
    ]
