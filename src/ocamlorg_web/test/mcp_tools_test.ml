(* Tests for the MCP package-documentation tools (issue #3775): the
   library/module extraction and its output cap. The sidebar fetch is size-
   capped upstream, but [libraries_and_modules] must also bound its own JSON so
   a package with a very large module tree cannot serialise one unbounded array
   (the counterpart to the body/reference caps in [Mcp_doc_html]). *)

module M = Ocamlorg_web.Mcp_tools
module Navmap = Ocamlorg_frontend.Navmap

let node ?(kind = Navmap.Module) ?href ?(children = []) title : Navmap.toc =
  { title; kind; href; children }

let lib name children = node ~kind:Navmap.Library ("Library " ^ name) ~children

let modl name =
  node ~kind:Navmap.Module ~href:("/p/pkg/1.0/doc/" ^ name ^ "/index.html") name

let run ?max_nodes sidebar =
  M.libraries_and_modules ?max_nodes ~name:"pkg" ~version:"1.0" sidebar

(* JSON helpers so we assert on shape without pulling in the whole yojson
   API. *)
let list_len = function `List l -> List.length l | _ -> -1

let library_module_count = function
  | `Assoc fields -> (
      match List.assoc_opt "modules" fields with
      | Some (`List ms) -> List.length ms
      | _ -> -1)
  | _ -> -1

(* docs-ci nests libraries under the package root page, so the extractor must
   recurse to find them, and report each with its direct module children. *)
let finds_nested_libraries () =
  let sidebar =
    [
      node "pkg index"
        ~children:
          [ lib "core" [ modl "A"; modl "B" ]; lib "extra" [ modl "C" ] ];
    ]
  in
  let libraries, modules, truncated = run sidebar in
  Alcotest.(check int) "two libraries" 2 (list_len libraries);
  Alcotest.(check int) "no bare modules" 0 (list_len modules);
  Alcotest.(check bool) "not truncated" false truncated

(* A package with modules but no [Library] wrapper falls back to the flat module
   list. *)
let falls_back_to_modules () =
  let sidebar =
    [ modl "A"; node ~kind:Navmap.Page "grp" ~children:[ modl "B" ] ]
  in
  let libraries, modules, truncated = run sidebar in
  Alcotest.(check int) "no libraries" 0 (list_len libraries);
  Alcotest.(check int) "two modules" 2 (list_len modules);
  Alcotest.(check bool) "not truncated" false truncated

(* The shared budget counts both the library node and each of its modules, and
   latches [truncated] once exhausted. Budget 3 over a library (1) + 5 modules
   keeps the library plus its first 2 modules, then stops. *)
let caps_library_modules () =
  let sidebar =
    [ lib "big" [ modl "A"; modl "B"; modl "C"; modl "D"; modl "E" ] ]
  in
  let libraries, _modules, truncated = run ~max_nodes:3 sidebar in
  Alcotest.(check int) "one library kept" 1 (list_len libraries);
  (match libraries with
  | `List [ l ] ->
      Alcotest.(check int) "two modules kept" 2 (library_module_count l)
  | _ -> Alcotest.fail "expected exactly one library");
  Alcotest.(check bool) "truncated" true truncated

(* Later libraries are dropped once the budget is spent; the result stays a
   valid (partial) library list rather than spilling into the module
   fallback. *)
let caps_libraries () =
  let sidebar =
    [ lib "a" [ modl "A" ]; lib "b" [ modl "B" ]; lib "c" [ modl "C" ] ]
  in
  let libraries, modules, truncated = run ~max_nodes:2 sidebar in
  Alcotest.(check int) "one library kept" 1 (list_len libraries);
  Alcotest.(check int) "no module fallback" 0 (list_len modules);
  Alcotest.(check bool) "truncated" true truncated

(* The flat fallback honours the same budget. *)
let caps_fallback_modules () =
  let sidebar = [ modl "A"; modl "B"; modl "C"; modl "D" ] in
  let _libraries, modules, truncated = run ~max_nodes:2 sidebar in
  Alcotest.(check int) "two modules kept" 2 (list_len modules);
  Alcotest.(check bool) "truncated" true truncated

(* An exactly-fitting tree is not flagged as truncated. *)
let exact_fit_not_truncated () =
  let sidebar = [ lib "a" [ modl "A"; modl "B" ] ] in
  let _libraries, _modules, truncated = run ~max_nodes:3 sidebar in
  Alcotest.(check bool) "not truncated" false truncated

let () =
  Alcotest.run "mcp_tools"
    [
      ( "libraries_and_modules",
        [
          Alcotest.test_case "nested libraries" `Quick finds_nested_libraries;
          Alcotest.test_case "module fallback" `Quick falls_back_to_modules;
          Alcotest.test_case "caps library modules" `Quick caps_library_modules;
          Alcotest.test_case "caps libraries" `Quick caps_libraries;
          Alcotest.test_case "caps fallback modules" `Quick
            caps_fallback_modules;
          Alcotest.test_case "exact fit" `Quick exact_fit_not_truncated;
        ] );
    ]
