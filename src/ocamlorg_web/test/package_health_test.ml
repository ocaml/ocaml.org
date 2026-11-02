(* Build results from check.ci.ocaml.org (#3847): the range query behind the
   ocaml_package_build_information MCP tool, its argument parsing, and the
   per-package view used by the package page, GraphQL and
   ocaml_package_documentation. Releases are synthetic, built over the compilers
   of the packed run, so the tests do not depend on any particular package
   staying in check.ci. *)

module P = Ocamlorg_web.Package_health
module M = Ocamlorg_web.Mcp_tools
module H = Data.Opam_health

let compilers = H.run.compilers
let n = List.length compilers
let first = List.hd compilers
let second = List.nth compilers 1
let all s = List.init n (fun _ -> s)
let rel name version statuses : H.release = { name; version; statuses }

(* b.1 fails only on the oldest compiler. *)
let releases =
  [
    rel "a" "1.9" (all H.Good);
    rel "a" "1.10" (all H.Bad);
    rel "b" "1" (H.Bad :: List.init (n - 1) (fun _ -> H.Good));
    rel "dune-rpc" "3.0" (all H.Not_available);
  ]

let run q =
  let r = P.query ~releases q in
  ( r.total,
    List.map (fun ((r : H.release), _) -> r.name ^ "." ^ r.version) r.results )

let check name expected q =
  Alcotest.(check (pair int (list string))) name expected (run q)

let q = P.default_query

let query () =
  check "latest only, newest by opam order"
    (3, [ "a.1.10"; "b.1"; "dune-rpc.3.0" ])
    q;
  check "all versions, newest first"
    (2, [ "a.1.10"; "a.1.9" ])
    { q with package = Some "a"; latest_only = false };
  check "bad on any compiler"
    (2, [ "a.1.10"; "b.1" ])
    { q with statuses = [ H.Bad ] };
  check "bad on all compilers" (1, [ "a.1.10" ])
    { q with statuses = [ H.Bad ]; match_mode = P.All };
  check "range excludes the oldest compiler" (1, [ "a.1.10" ])
    { q with statuses = [ H.Bad ]; compiler_min = Some second };
  check "range of only the oldest compiler"
    (2, [ "a.1.10"; "b.1" ])
    {
      q with
      statuses = [ H.Bad ];
      match_mode = P.All;
      compiler_max = Some first;
    };
  check "page" (3, [ "b.1" ]) { q with limit = 1; offset = 1 };
  check "glob" (1, [ "dune-rpc.3.0" ]) { q with package = Some "dune*" };
  check "exact name is not a prefix" (0, []) { q with package = Some "dune" };
  let r = P.query ~releases { q with compiler_min = Some second } in
  Alcotest.(check (list string))
    "compilers in range" (List.tl compilers) r.compilers;
  Alcotest.(check int)
    "builds restricted to range" (n - 1)
    (List.length (snd (List.hd r.results)))

let glob () =
  let t p s expected =
    Alcotest.(check bool) (p ^ " ~ " ^ s) expected (P.glob_matches p s)
  in
  t "dune*" "dune" true;
  t "dune*" "dune-rpc" true;
  t "dune*" "xdune" false;
  t "*ppx*" "ppx_deriving" true;
  t "a.b" "axb" false

let summary () =
  let s name expected l =
    Alcotest.(check string) name expected (H.summary_to_string (H.summary l))
  in
  s "all good" "all_good" [ H.Good; H.Good ];
  s "not-available is not a failure" "all_good" [ H.Not_available; H.Good ];
  s "not on the newest compiler" "not_on_latest" [ H.Good; H.Not_available ];
  s "newest failing" "some_failures" [ H.Good; H.Bad ];
  s "mixed" "some_failures" [ H.Good; H.Partial ];
  s "all failing" "all_failing" [ H.Bad; H.Internal_failure; H.Not_available ];
  s "nothing available" "not_available" [ H.Not_available ]

let for_package () =
  (match H.releases with
  | [] -> ()
  | (r : H.release) :: _ -> (
      match P.for_package ~name:r.name ~version:r.version with
      | None -> Alcotest.fail "a packed release has no view"
      | Some v ->
          Alcotest.(check bool) "current found" true (v.current = Some r);
          Alcotest.(check bool)
            "others exclude current" false
            (List.exists
               (fun (o : H.release) -> o.version = r.version)
               v.others)));
  Alcotest.(check bool)
    "unknown package" true
    (P.for_package ~name:"no-such-package-3847" ~version:"1" = None)

(* A version absent from the run is "newer than checked" only when it sorts
   after every checked version of its package. In opam's order, appending ".1"
   to a version gives a newer one and appending "~" an older one. *)
let for_page () =
  match H.releases with
  | [] -> ()
  | (r : H.release) :: _ ->
      let checked = P.versions r.name in
      let newest = (List.hd checked).version in
      let oldest = (List.hd (List.rev checked)).version in
      let page version =
        match P.for_page ~now:0. ~name:r.name ~version with
        | None -> Alcotest.fail "a packed package has no page view"
        | Some t -> t
      in
      let t = page newest in
      Alcotest.(check bool) "checked: current" true (t.current <> None);
      Alcotest.(check bool) "checked: not newer" false t.newer_than_checked;
      let t = page (newest ^ ".1") in
      Alcotest.(check bool) "newer: no current" true (t.current = None);
      Alcotest.(check bool) "newer: newer" true t.newer_than_checked;
      let t = page (oldest ^ "~") in
      Alcotest.(check bool) "older: no current" true (t.current = None);
      Alcotest.(check bool) "older: not newer" false t.newer_than_checked

let parse () =
  let ok name json =
    match M.parse_build_query (Yojson.Safe.from_string json) with
    | Ok q -> q
    | Error e -> Alcotest.failf "%s: %s" name e
  in
  let err name json =
    match M.parse_build_query (Yojson.Safe.from_string json) with
    | Ok _ -> Alcotest.failf "%s: expected an error" name
    | Error _ -> ()
  in
  Alcotest.(check bool) "defaults" true (ok "empty" "{}" = P.default_query);
  let q =
    ok "full"
      {|{"package":"lwt*","compiler_min":"5.0","compiler_max":"5.5",
    "status":["bad","partial"],"match":"all","latest_only":false,"limit":10,"offset":5}|}
  in
  Alcotest.(check bool)
    "full" true
    (q
    = {
        P.package = Some "lwt*";
        compiler_min = Some "5.0";
        compiler_max = Some "5.5";
        statuses = [ H.Bad; H.Partial ];
        match_mode = P.All;
        latest_only = false;
        limit = 10;
        offset = 5;
      });
  Alcotest.(check bool)
    "single status string" true
    ((ok "one" {|{"status":"bad"}|}).statuses = [ H.Bad ]);
  err "unknown status" {|{"status":["meh"]}|};
  err "bad compiler" {|{"compiler_min":"five"}|};
  err "limit too big" {|{"limit":501}|};
  err "negative offset" {|{"offset":-1}|};
  err "bad match" {|{"match":"some"}|};
  err "latest_only not a bool" {|{"latest_only":"yes"}|}

let () =
  Alcotest.run "package_health"
    [
      ( "package_health",
        [
          Alcotest.test_case "query" `Quick query;
          Alcotest.test_case "glob" `Quick glob;
          Alcotest.test_case "summary" `Quick summary;
          Alcotest.test_case "for_package" `Quick for_package;
          Alcotest.test_case "for_page" `Quick for_page;
          Alcotest.test_case "MCP arguments" `Quick parse;
        ] );
    ]
