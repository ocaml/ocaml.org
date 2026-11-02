(* Pure parts of the check.ci scraper: run-id extraction, JSON decoding and the
   diff used for the PR report. *)

module S = Data_scrape.Opam_health_scraper
open Data_intf.Opam_health

let commit = "7cdc69800790e0a8e65c35747f02a4697fe0879e"
let run_id = "1793093119-" ^ commit

(* Trimmed from
   https://check.ci.ocaml.org/?packages=dune&show-latest-only=true *)
let html =
  {|<a href="https://github.com/ocaml/opam-repository/commit/|} ^ commit
  ^ {|"><b>commit</b></a><table id="results"><tr class="results-row">
<td class="results-cell pkgname">dune.3.20.2</td>
<td class="result-col results-cell cell-good"><a href="/log/|}
  ^ run_id ^ {|/4.14/good/dune.3.20.2">☑</a></td></tr></table>|}

let run_id_extraction () =
  Alcotest.(check (option string))
    "from a log link" (Some run_id) (S.run_id_of_html html);
  Alcotest.(check (option string))
    "page without rows" None
    (S.run_id_of_html "<p>Packages with current filters: 0</p>")

let json =
  {|[{"name":"b.1.0","statuses":[{"compiler":"5.4","status":"bad"},{"compiler":"4.14","status":"good"}]},
     {"name":"a.2","statuses":[{"status":"not-available","compiler":"4.14"},{"compiler":"5.4","status":"partial"}]},
     {"name":"no version","statuses":[{"compiler":"5.4","status":"good"},{"compiler":"4.14","status":"good"}]}]|}

let decode s = Result.bind (S.Json.of_string s) (S.of_json ~run_id)

let decoding () =
  match decode json with
  | Error e -> Alcotest.fail e
  | Ok t ->
      Alcotest.(check (list string))
        "compilers ascending" [ "4.14"; "5.4" ] t.run.compilers;
      Alcotest.(check string) "commit" commit t.run.commit;
      Alcotest.(check bool)
        "releases sorted, statuses aligned, bad key skipped" true
        (t.releases
        = [
            { name = "a"; version = "2"; statuses = [ Not_available; Partial ] };
            { name = "b"; version = "1.0"; statuses = [ Good; Bad ] };
          ])

let is_error name = function
  | Ok _ -> Alcotest.failf "%s: expected an error" name
  | Error _ -> ()

let decoding_errors () =
  is_error "unknown status"
    (decode {|[{"name":"a.1","statuses":[{"compiler":"5.4","status":"meh"}]}]|});
  is_error "missing compiler"
    (decode
       {|[{"name":"a.1","statuses":[{"compiler":"5.4","status":"good"}]},
          {"name":"b.1","statuses":[{"compiler":"4.14","status":"good"}]}]|});
  is_error "not a list" (decode {|{"name":"a.1"}|});
  is_error "invalid JSON" (decode "[");
  is_error "bad run id"
    (Result.bind (S.Json.of_string "[]") (S.of_json ~run_id:"latest"))

let diff () =
  let run = { id = run_id; timestamp = 0.; commit; compilers = [ "5.4" ] } in
  let r name statuses = { name; version = "1"; statuses } in
  let old =
    { run; releases = [ r "a" [ Good ]; r "b" [ Good ]; r "c" [ Bad ] ] }
  in
  let t =
    { run; releases = [ r "a" [ Good ]; r "b" [ Bad ]; r "d" [ Good ] ] }
  in
  let d = S.diff ~old:(Some old) t in
  Alcotest.(check (list string)) "added" [ "d.1" ] d.added;
  Alcotest.(check (list string)) "removed" [ "c.1" ] d.removed;
  Alcotest.(check (list string))
    "changed" [ "b.1" ]
    (List.map (fun (k, _, _) -> k) d.changed);
  Alcotest.(check bool) "same compilers" false d.compilers_changed

let () =
  Alcotest.run "opam_health_scraper"
    [
      ( "scraper",
        [
          Alcotest.test_case "run id" `Quick run_id_extraction;
          Alcotest.test_case "decoding" `Quick decoding;
          Alcotest.test_case "decoding errors" `Quick decoding_errors;
          Alcotest.test_case "diff" `Quick diff;
        ] );
    ]
