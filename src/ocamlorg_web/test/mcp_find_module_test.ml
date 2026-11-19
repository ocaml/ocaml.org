(* Tests for ocaml_module_find: matching modules and libraries in a package's
   sidebar (lwt 5.9.0's, see [Mcp_fixtures]), the package names guessed from a
   module or library name, the argument errors, and the handler end to end on a
   docs-ci stand-in. *)

open Mcp_fixtures
module M = Ocamlorg_web.Mcp_find_module

let strings = Alcotest.(list string)

let describe = function
  | M.Library { name; path } ->
      Printf.sprintf "library %s %s" name (Option.value ~default:"-" path)
  | M.Module m ->
      Printf.sprintf "%s %s %s %s" m.kind
        (Mcp_docs.module_path_string m)
        (Option.value ~default:"-" m.library)
        m.page

let find kind target =
  M.find_in_sidebar ~kind ~target ~name:"lwt" ~version:"5.9.0" lwt_sidebar
  |> fst |> List.map describe

let finds_modules () =
  Alcotest.(check strings)
    "a top-level module"
    [ "module Lwt_main lwt.unix lwt.unix/Lwt_main/index.html" ]
    (find "any" "Lwt_main");
  Alcotest.(check strings)
    "a dotted path"
    [
      "module Lwt_unix.LargeFile lwt.unix \
       lwt.unix/Lwt_unix/LargeFile/index.html";
    ]
    (find "module" "Lwt_unix.LargeFile");
  Alcotest.(check strings)
    "nested modules of the same name, with their full paths"
    [
      "module Lwt.Infix lwt lwt/Lwt/Infix/index.html";
      "module Lwt_result.Infix lwt lwt/Lwt_result/Infix/index.html";
    ]
    (find "module" "Infix");
  Alcotest.(check strings) "absent" [] (find "any" "Nope")

let finds_libraries () =
  Alcotest.(check strings)
    "findlib name, which has no page" [ "library lwt.unix -" ]
    (find "library" "lwt.unix");
  Alcotest.(check strings)
    "kind module ignores libraries" [] (find "module" "lwt.unix");
  Alcotest.(check strings)
    "kind library ignores modules" []
    (find "library" "Lwt_main")

let guesses_packages () =
  Alcotest.(check strings)
    "library root" [ "lwt" ]
    (M.guessed_packages "lwt.unix");
  Alcotest.(check strings)
    "a module, with its prefixes"
    [ "lwt_main"; "lwt-main"; "lwt" ]
    (M.guessed_packages "Lwt_main");
  Alcotest.(check strings)
    "several underscores"
    [
      "cohttp_lwt_unix"; "cohttp-lwt-unix"; "cohttp_lwt"; "cohttp-lwt"; "cohttp";
    ]
    (M.guessed_packages "Cohttp_lwt_unix")

(* A state with lwt, documented in 5.9.0 (with the sidebar of the fixture) but
   not in 6.0.0, and other packages: [app] depends on lwt and [nodoc], [nodoc]
   has no documentation, [flaky]'s fetches raise, [big] depends on 45 packages,
   [unread]'s status cannot be read, [stalled] never answers, [deep] has 7
   versions without documentation, and [sigs] has 25 module types [S]. *)
let deps l = List.map (fun d -> (n d, None)) l
let many = List.init 45 (Printf.sprintf "dep%02d")

let state =
  Package.mockup_state
    ([
       package "lwt" "5.9.0";
       package "lwt" "6.0.0";
       package "app" "1.0" ~dependencies:(deps [ "lwt"; "nodoc" ]);
       package "nodoc" "1.0";
       package "flaky" "1.0";
       package "big" "1.0" ~dependencies:(deps many);
       package "unread" "1.0";
       package "stalled" "1.0";
       package "sigs" "1.0";
     ]
    @ List.init 7 (fun i -> package "deep" (Printf.sprintf "1.%d" i))
    @ List.map (fun d -> package d "1.0") many)

let module_types_s =
  let node ?(kind = Ocamlorg_frontend.Navmap.Module) ?(children = []) title href
      : Ocamlorg_frontend.Navmap.toc =
    { title; kind; href = Some ("/p/sigs/1.0/doc/" ^ href); children }
  in
  [
    {
      Ocamlorg_frontend.Navmap.title = "Library <code>sigs</code>";
      kind = Ocamlorg_frontend.Navmap.Library;
      href = None;
      children =
        List.init 25 (fun i ->
            let m = Printf.sprintf "M%02d" i in
            node m
              (Printf.sprintf "sigs/%s/index.html" m)
              ~children:
                [
                  node "S" ~kind:Ocamlorg_frontend.Navmap.Module_type
                    (Printf.sprintf "sigs/%s/module-type-S/index.html" m);
                ]);
    };
  ]

let docs =
  [
    ("lwt.5.9.0", `Built (lwt_sidebar, [], []));
    ("lwt.6.0.0", `Missing);
    ("flaky.1.0", `Built (lwt_sidebar, [], []));
    ("unread.1.0", `Unreadable);
    ("sigs.1.0", `Built (module_types_s, [], []));
  ]

let find_call ?(fetches = ref 0) ?(status_fetches = ref 0) ?deadline args =
  call_partial
    (M.find_module
       ~docs:
         (backend ~raising:[ "flaky.1.0" ] ~stalling:[ "stalled.1.0" ] ~fetches
            ~status_fetches docs)
       ?deadline state)
    (`Assoc args)

let payload = function
  | Ok (json, partial) -> (json, partial)
  | Error e -> Alcotest.failf "unexpected error: %s" e

let checked json =
  List.map
    (fun c ->
      to_string (member "package" c) ^ " " ^ to_string (member "status" c))
    (to_list (member "checked" json))

let matches json =
  List.map
    (fun m ->
      String.concat " "
        (List.map
           (fun k -> to_string (member k m))
           [ "package"; "version"; "kind"; "module"; "library"; "path" ]))
    (to_list (member "matches" json))

let finds_through_guesses () =
  let fetches = ref 0 in
  let json, partial =
    payload (find_call ~fetches [ ("name", `String "Lwt_main") ])
  in
  Alcotest.(check bool) "complete" false partial;
  Alcotest.(check strings)
    "lwt, the latest documented version"
    [ "lwt 5.9.0 module Lwt_main lwt.unix lwt.unix/Lwt_main/index.html" ]
    (matches json);
  Alcotest.(check strings) "checked" [ "lwt match" ] (checked json);
  Alcotest.(check int) "one sidebar fetched" 1 !fetches

let searches_dependencies () =
  let fetches = ref 0 in
  let json, _ =
    payload
      (find_call ~fetches
         [
           ("name", `String "lwt.unix");
           ("kind", `String "library");
           ("packages", `List [ `String "nope"; `String "lwt" ]);
           ("dependencies_of", `String "app");
         ])
  in
  Alcotest.(check strings)
    "the library"
    [ "lwt 5.9.0 library null lwt.unix null" ]
    (matches json);
  Alcotest.(check strings)
    "given, then dependencies, each once"
    [ "lwt match"; "nodoc no-docs" ]
    (checked json);
  Alcotest.(check bool)
    "unknown packages reported" true
    (member "unknown_packages" json = `List [ `String "nope" ]);
  Alcotest.(check int) "no sidebar fetched without docs" 1 !fetches

let failures_are_partial () =
  let json, partial =
    payload
      (find_call
         [
           ("name", `String "Infix");
           ("packages", `List [ `String "flaky"; `String "lwt" ]);
         ])
  in
  Alcotest.(check bool) "marked partial, so not cached" true partial;
  Alcotest.(check bool) "said so" true (member "partial" json = `Bool true);
  Alcotest.(check strings)
    "checked"
    [ "flaky error"; "lwt match" ]
    (checked json);
  Alcotest.(check int)
    "both Infix modules" 2
    (List.length (to_list (member "matches" json)))

let caps_candidates () =
  let json, _ =
    payload
      (find_call
         [ ("name", `String "Nope"); ("dependencies_of", `String "big") ])
  in
  Alcotest.(check int)
    "40 checked" 40
    (List.length (to_list (member "checked" json)));
  Alcotest.(check bool)
    "truncated" true
    (member "candidates_truncated" json = `Bool true)

let argument_errors () =
  let error args = match find_call args with Error e -> e | Ok _ -> "ok" in
  Alcotest.(check string)
    "name required" "missing required argument: \"name\"" (error []);
  Alcotest.(check string)
    "invalid name" "invalid name: \"a/b\""
    (error [ ("name", `String "a/b") ]);
  Alcotest.(check string)
    "invalid name" "invalid name: \"Lwt..Main\""
    (error [ ("name", `String "Lwt..Main") ]);
  Alcotest.(check string)
    "not a module path, looked up as a module"
    "invalid module path: \"make.real\" (module names start with a capital \
     letter)"
    (error [ ("name", `String "make.real"); ("kind", `String "module") ]);
  Alcotest.(check bool)
    "with any kind, it may be a library name" false
    (String.starts_with ~prefix:"invalid module path"
       (error [ ("name", `String "make.real") ]));
  Alcotest.(check string)
    "unknown kind" "unknown kind: \"value\""
    (error [ ("name", `String "X"); ("kind", `String "value") ]);
  Alcotest.(check string)
    "packages type" "argument \"packages\" must be an array of strings"
    (error [ ("name", `String "X"); ("packages", `String "lwt") ]);
  Alcotest.(check string)
    "unknown dependencies_of" "unknown package: \"nope\""
    (error [ ("name", `String "X"); ("dependencies_of", `String "nope") ]);
  Alcotest.(check string)
    "no candidate at all"
    "no package to search for \"Xyz\": none is named after it, and no known \
     package was given in \"packages\" or as a dependency of \
     \"dependencies_of\" (unknown packages: \"nope\")"
    (error [ ("name", `String "Xyz"); ("packages", `List [ `String "nope" ]) ])

(* A status that could not be read is a backend failure: the candidate is not
   reported without documentation, and the result is partial (not cached). *)
let unreadable_status () =
  let json, partial =
    payload
      (find_call
         [
           ("name", `String "Lwt_main");
           ("packages", `List [ `String "unread"; `String "lwt" ]);
         ])
  in
  Alcotest.(check bool) "partial" true partial;
  Alcotest.(check strings)
    "checked"
    [ "unread docs-unavailable"; "lwt match" ]
    (checked json)

(* The deadline only bounds the wait for the stalled candidate: long enough for
   the other one to be read on a slow CI machine. *)
let stalled_candidate () =
  let json, partial =
    payload
      (find_call ~deadline:2.
         [
           ("name", `String "Lwt_main");
           ("packages", `List [ `String "stalled"; `String "lwt" ]);
         ])
  in
  Alcotest.(check bool) "partial" true partial;
  Alcotest.(check strings)
    "checked"
    [ "stalled skipped"; "lwt match" ]
    (checked json);
  Alcotest.(check bool)
    "deadline reached" true
    (member "deadline_reached" json = `Bool true)

(* More than 20 modules of that name in one package: the matches are cut, and
   the result says so. *)
let truncated_matches () =
  let json, _ =
    payload
      (find_call
         [ ("name", `String "S"); ("packages", `List [ `String "sigs" ]) ])
  in
  Alcotest.(check int)
    "20 matches" 20
    (List.length (to_list (member "matches" json)));
  Alcotest.(check bool) "cut" true (member "matches_truncated" json = `Bool true);
  match to_list (member "checked" json) with
  | [ c ] ->
      Alcotest.(check bool)
        "in that package" true
        (member "matches_truncated" c = `Bool true)
  | _ -> Alcotest.fail "expected one package"

(* The status probes of a candidate: down to its latest documented version, at
   most 5. *)
let status_probes () =
  let probes package =
    let status_fetches = ref 0 and fetches = ref 0 in
    let _ =
      payload
        (find_call ~status_fetches ~fetches
           [ ("name", `String "X"); ("packages", `List [ `String package ]) ])
    in
    (!status_fetches, !fetches)
  in
  Alcotest.(check (pair int int))
    "lwt: 6.0.0 and 5.9.0, then its sidebar" (2, 1) (probes "lwt");
  Alcotest.(check (pair int int))
    "deep: its 5 newest versions, no sidebar" (5, 0) (probes "deep")

let compiler_libraries () =
  let note =
    "Unix comes with the OCaml compiler, not with an opam package: see the API \
     reference of the OCaml distribution at https://ocaml.org/api/"
  in
  (match find_call [ ("name", `String "Unix.LargeFile") ] with
  | Error e ->
      Alcotest.(check bool) "a hint in the error" true (contains note e)
  | Ok _ -> Alcotest.fail "expected an error");
  let json, _ =
    payload
      (find_call
         [ ("name", `String "Unix"); ("dependencies_of", `String "app") ])
  in
  Alcotest.(check string) "a note" note (to_string (member "note" json))

let () =
  Alcotest.run "mcp_find_module"
    [
      ( "sidebar",
        [
          Alcotest.test_case "modules" `Quick finds_modules;
          Alcotest.test_case "libraries" `Quick finds_libraries;
          Alcotest.test_case "guesses" `Quick guesses_packages;
        ] );
      ( "tool",
        [
          Alcotest.test_case "guessed package" `Quick finds_through_guesses;
          Alcotest.test_case "dependencies" `Quick searches_dependencies;
          Alcotest.test_case "partial" `Quick failures_are_partial;
          Alcotest.test_case "40 candidates" `Quick caps_candidates;
          Alcotest.test_case "arguments" `Quick argument_errors;
          Alcotest.test_case "unreadable status" `Quick unreadable_status;
          Alcotest.test_case "stalled candidate" `Quick stalled_candidate;
          Alcotest.test_case "truncated matches" `Quick truncated_matches;
          Alcotest.test_case "status probes" `Quick status_probes;
          Alcotest.test_case "compiler libraries" `Quick compiler_libraries;
        ] );
    ]
