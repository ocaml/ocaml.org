(* Tests for the pieces shared by the MCP tools that read docs-ci beyond one
   page: the latest documented version, and the time limit. *)

open Mcp_fixtures

let three_versions =
  Package.mockup_state
    [ package "p" "1.0"; package "p" "2.0"; package "p" "3.0" ]

let latest ?(depth = 5) docs =
  match
    Lwt_main.run
      (Mcp_docs.latest_documented ~depth (backend docs) three_versions (n "p"))
  with
  | Ok (Some p) -> Package.Version.to_string (Package.version p)
  | Ok None -> "none"
  | Error p -> "unreadable " ^ Package.Version.to_string (Package.version p)

let latest_documented () =
  let docs =
    [ ("p.3.0", `Missing); ("p.2.0", `Failed); ("p.1.0", `Built ([], [], [])) ]
  in
  Alcotest.(check string) "skips missing and failed builds" "1.0" (latest docs);
  Alcotest.(check string)
    "probes at most depth versions" "none" (latest ~depth:2 docs)

(* A status that could not be read is not a version without documentation: the
   search stops there, rather than return an older version. *)
let unreadable_status () =
  Alcotest.(check string)
    "stops at an unreadable status" "unreadable 2.0"
    (latest
       [
         ("p.3.0", `Missing);
         ("p.2.0", `Unreadable);
         ("p.1.0", `Built ([], [], []));
       ]);
  Alcotest.(check string)
    "a documented version before it is found" "3.0"
    (latest [ ("p.3.0", `Built ([], [], [])); ("p.2.0", `Unreadable) ])

let within () =
  let run seconds p = Lwt_main.run (Mcp_docs.within seconds (fun () -> p)) in
  Alcotest.(check (option int)) "resolved" (Some 1) (run 0. (Lwt.return 1));
  let stalled, _ = Lwt.task () in
  Alcotest.(check (option int)) "timed out" None (run 0.01 stalled);
  Alcotest.(check bool)
    "and cancelled" true
    (Lwt.state stalled = Lwt.Fail Lwt.Canceled)

let () =
  Alcotest.run "mcp_docs"
    [
      ( "helpers",
        [
          Alcotest.test_case "latest documented" `Quick latest_documented;
          Alcotest.test_case "unreadable status" `Quick unreadable_status;
          Alcotest.test_case "within" `Quick within;
        ] );
    ]
