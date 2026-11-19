(* Tests for the pieces shared by the MCP tools that read many documentation
   pages in one call: module resolution in a sidebar, module path parsing, the
   latest documented version, and partial results. *)

open Mcp_fixtures
module Navmap = Ocamlorg_frontend.Navmap

let strings = Alcotest.(list string)

let resolve ?max_matches ?(sidebar = lwt_sidebar) path =
  Mcp_docs.resolve_module ?max_matches ~name:"lwt" ~version:"5.9.0" sidebar
    (String.split_on_char '.' path)

let describe (m : Mcp_docs.module_match) =
  Printf.sprintf "%s %s %s %s"
    (Mcp_docs.module_path_string m)
    m.kind
    (Option.value ~default:"-" m.library)
    m.page

let matches ?max_matches ?sidebar path =
  List.map describe (resolve ?max_matches ?sidebar path).matches

let dotted_paths () =
  Alcotest.(check strings)
    "a submodule"
    [
      "Lwt_unix.LargeFile module lwt.unix \
       lwt.unix/Lwt_unix/LargeFile/index.html";
    ]
    (matches "Lwt_unix.LargeFile");
  Alcotest.(check strings)
    "a module type"
    [ "Lwt_pqueue.S module-type lwt lwt/Lwt_pqueue/module-type-S/index.html" ]
    (matches "Lwt_pqueue.S");
  Alcotest.(check strings)
    "a top-level module"
    [ "Lwt_main module lwt.unix lwt.unix/Lwt_main/index.html" ]
    (matches "Lwt_main");
  Alcotest.(check strings) "a wrong path" [] (matches "Lwt_unix.Infix")

let ambiguous_names () =
  Alcotest.(check strings)
    "both nested modules, in sidebar order"
    [
      "Lwt.Infix module lwt lwt/Lwt/Infix/index.html";
      "Lwt_result.Infix module lwt lwt/Lwt_result/Infix/index.html";
    ]
    (matches "Infix");
  let r = resolve ~max_matches:1 "Infix" in
  Alcotest.(check int) "capped" 1 (List.length r.matches);
  Alcotest.(check bool) "truncated" true r.matches_truncated

let node ?(kind = Navmap.Module) ?(children = []) title href : Navmap.toc =
  { title; kind; href = Some ("/p/lwt/5.9.0/doc/" ^ href); children }

let library name children : Navmap.toc =
  {
    title = "Library <code>" ^ name ^ "</code>";
    kind = Navmap.Library;
    href = None;
    children;
  }

(* [Aaa.Result] comes first in the sidebar, the top-level [Result] after it;
   [Why3.Term] is only reached through its wrapper module. *)
let clashing =
  [
    library "x"
      [
        node "Aaa" "x/Aaa/index.html"
          ~children:[ node "Result" "x/Aaa/Result/index.html" ];
        node "Why3" "x/Why3/index.html"
          ~children:[ node "Term" "x/Why3/Term/index.html" ];
      ];
    library "y" [ node "Result" "y/Result/index.html" ];
  ]

let shallowest_wins () =
  Alcotest.(check strings)
    "the top-level module, not the nested one"
    [ "Result module y y/Result/index.html" ]
    (matches ~sidebar:clashing "Result");
  Alcotest.(check strings)
    "a module reached through an open of its wrapper"
    [ "Why3.Term module x x/Why3/Term/index.html" ]
    (matches ~sidebar:clashing "Term");
  Alcotest.(check strings)
    "the full path"
    [ "Aaa.Result module x x/Aaa/Result/index.html" ]
    (matches ~sidebar:clashing "Aaa.Result")

let top_level_modules () =
  let r = resolve "Nope" in
  Alcotest.(check strings) "no match" [] (List.map describe r.matches);
  Alcotest.(check strings)
    "the real top-level modules, not their submodules"
    [ "Lwt"; "Lwt_pqueue"; "Lwt_result"; "Lwt_main"; "Lwt_unix" ]
    r.top_level

let module_paths () =
  let p s =
    match Mcp_docs.parse_module_path s with
    | Ok l -> String.concat "|" l
    | Error e -> e
  in
  Alcotest.(check string) "nested" "Ortools|Sat" (p "Ortools.Sat");
  Alcotest.(check string) "one module" "Lwt_main" (p "Lwt_main");
  Alcotest.(check string)
    "empty component" "invalid module path: \"Lwt..Main\"" (p "Lwt..Main");
  Alcotest.(check string)
    "path characters" "invalid module path: \"../etc\"" (p "../etc");
  Alcotest.(check string) "empty" "invalid module path: \"\"" (p "");
  Alcotest.(check string)
    "a quote"
    "invalid module path: \"M'\" (module names containing a quote are not \
     supported)"
    (p "M'")

let latest_documented () =
  let state =
    Package.mockup_state
      [ package "p" "1.0"; package "p" "2.0"; package "p" "3.0" ]
  in
  let docs =
    backend
      [
        ("p.3.0", `Missing); ("p.2.0", `Failed); ("p.1.0", `Built ([], [], []));
      ]
  in
  let latest depth =
    Lwt_main.run (Mcp_docs.latest_documented ~depth docs state (n "p"))
    |> Option.map (fun p -> Package.Version.to_string (Package.version p))
  in
  Alcotest.(check (option string))
    "skips missing and failed builds" (Some "1.0") (latest 5);
  Alcotest.(check (option string))
    "probes at most depth versions" None (latest 2)

let partial_results () =
  let payload partial =
    match Mcp_docs.ok_json ~partial [ ("x", `Int 1) ] with
    | Ok [ block ] -> Ocamlorg_mcp.Tool.take_partial block <> None
    | _ -> Alcotest.fail "expected one block"
  in
  Alcotest.(check bool) "marked" true (payload true);
  Alcotest.(check bool) "not marked" false (payload false)

let () =
  Alcotest.run "mcp_docs"
    [
      ( "resolve_module",
        [
          Alcotest.test_case "dotted paths" `Quick dotted_paths;
          Alcotest.test_case "ambiguous names" `Quick ambiguous_names;
          Alcotest.test_case "shallowest wins" `Quick shallowest_wins;
          Alcotest.test_case "top-level modules" `Quick top_level_modules;
        ] );
      ( "helpers",
        [
          Alcotest.test_case "module paths" `Quick module_paths;
          Alcotest.test_case "latest documented" `Quick latest_documented;
          Alcotest.test_case "partial results" `Quick partial_results;
        ] );
    ]
