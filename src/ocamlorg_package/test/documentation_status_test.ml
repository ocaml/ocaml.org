module Status = Ocamlorg_package.Documentation.Status

(* status.json as currently emitted by the docs backend: no search_index_digest
   field. Parsing must succeed and default the field to None. *)
let without_digest =
  {|{
    "name": "foo",
    "version": "1.0.0",
    "failed": false,
    "files": ["index.html"],
    "redirections": []
  }|}

(* Forward-compatible: once ocaml-docs-ci/voodoo publishes the digest
   (ocurrent/ocaml-docs-ci#193), it must be picked up. *)
let with_digest =
  {|{
    "name": "foo",
    "version": "1.0.0",
    "failed": false,
    "files": ["index.html"],
    "redirections": [],
    "search_index_digest": "deadbeef"
  }|}

(* Unknown extra fields must be ignored, not rejected. *)
let with_extra_field =
  {|{
    "name": "foo",
    "version": "1.0.0",
    "failed": false,
    "files": ["index.html"],
    "redirections": [],
    "some_future_field": 42
  }|}

(* A build with the usual special files among many ordinary ones. *)
let with_many_files =
  {|{
    "name": "foo",
    "version": "1.0.0",
    "failed": false,
    "files": ["README.md", "index.html", "foo/Foo/index.html", "LICENSE",
              "foo/Foo/Bar/index.html", "CHANGES.md", "src/foo.ml.html"],
    "redirections": [{"old_path": "a", "new_path": "b"}]
  }|}

let parse s = Status.of_string s |> Result.get_ok
let test_case n = Alcotest.test_case n `Quick

module Documentation = Ocamlorg_package.Documentation

(* What docs-ci, or a proxy in front of it, may serve with a 200 instead of
   JSON: an error page, a body cut short, or no body at all. *)
let not_json =
  [ "<html><body>Bad gateway</body></html>"; "{\"name\": \"fo"; "" ]

let sidebar =
  {|[{"node": {"url": "p/foo/1.0.0/doc/index.html", "kind": "leaf-page",
              "content": "foo"},
      "children": [{"node": {"url": null, "kind": null,
                             "content": "Library <code>foo</code>"},
                    "children": [{"node": {"url": "p/foo/1.0.0/doc/foo/Foo/index.html",
                                           "kind": "module", "content": "Foo"},
                                  "children": []}]}]}]|}

let non_json_bodies () =
  List.iter
    (fun body ->
      Alcotest.(check bool)
        "status" true
        (Result.is_error (Status.of_string body));
      Alcotest.(check bool)
        "sidebar" true
        (Result.is_error (Documentation.sidebar_of_string body));
      Alcotest.(check bool)
        "page" true
        (Result.is_error (Documentation.page_of_string body)))
    not_json

(* JSON, but not of the expected shape. *)
let malformed_bodies () =
  Alcotest.(check bool)
    "status" true
    (Result.is_error (Status.of_string {|{"name": "foo"}|}));
  Alcotest.(check bool)
    "sidebar" true
    (Result.is_error (Documentation.sidebar_of_string {|{}|}));
  Alcotest.(check bool)
    "page" true
    (Result.is_error (Documentation.page_of_string {|{}|}))

(* A rendered page ([.html.json]) with the given breadcrumbs. *)
let page breadcrumbs =
  Printf.sprintf
    {|{"header": "<h1>Make</h1>", "type": "module", "uses_katex": false,
       "breadcrumbs": [%s],
       "toc": [{"title": "Values", "href": "#values", "children": []}],
       "source_anchor": null, "preamble": "<p>pre</p>",
       "content": "<p>body</p>"}|}
    (String.concat ", " breadcrumbs)

let breadcrumb kind =
  Printf.sprintf {|{"name": "Make", "href": null, "kind": "%s"}|} kind

let foo = {|{"name": "foo", "href": "../index.html", "kind": "module"}|}

let parses_page () =
  match
    Documentation.page_of_string (page [ foo; breadcrumb "argument-1" ])
  with
  | Error e -> Alcotest.fail e
  | Ok doc ->
      Alcotest.(check string)
        "content" "<h1>Make</h1><p>pre</p><p>body</p>" doc.content;
      Alcotest.(check (list string))
        "toc" [ "Values" ]
        (List.map (fun (t : Documentation.toc) -> t.title) doc.toc);
      Alcotest.(check bool)
        "breadcrumbs" true
        (List.map (fun (b : Documentation.breadcrumb) -> b.kind) doc.breadcrumbs
        = [ Module; Parameter 1 ])

(* A breadcrumb kind that does not parse: a functor argument without a number
   (which [int_of_string] rejects with [Failure]), or a kind odoc does not
   produce (which raises [Invalid_argument]). *)
let bad_breadcrumbs () =
  List.iter
    (fun kind ->
      Alcotest.(check bool)
        kind true
        (Result.is_error
           (Documentation.page_of_string (page [ foo; breadcrumb kind ]))))
    [ "argument-x"; "argument-"; "widget" ]

let parses_sidebar () =
  match Documentation.sidebar_of_string sidebar with
  | Error e -> Alcotest.fail e
  | Ok [ root ] -> (
      Alcotest.(check (option string))
        "href" (Some "/p/foo/1.0.0/doc/index.html") root.href;
      match root.children with
      | [ lib ] ->
          Alcotest.(check bool)
            "library" true
            (lib.kind = Ocamlorg_frontend.Navmap.Library);
          Alcotest.(check (list string))
            "modules" [ "Foo" ]
            (List.map
               (fun (m : Ocamlorg_frontend.Navmap.toc) -> m.title)
               lib.children)
      | _ -> Alcotest.fail "expected one library")
  | Ok _ -> Alcotest.fail "expected one root"

let () =
  Alcotest.run "documentation_status"
    [
      ( "status.json parsing",
        [
          test_case "missing digest defaults to None" (fun () ->
              let t = parse without_digest in
              Alcotest.(check (option string))
                "no digest" None t.Status.search_index_digest);
          test_case "digest is read when present" (fun () ->
              let t = parse with_digest in
              Alcotest.(check (option string))
                "digest present" (Some "deadbeef") t.Status.search_index_digest);
          test_case "unknown fields are ignored" (fun () ->
              let t = parse with_extra_field in
              Alcotest.(check string) "name still parsed" "foo" t.Status.name);
        ] );
      ( "bodies that do not parse",
        [
          test_case "are errors, not exceptions" non_json_bodies;
          test_case "nor is malformed JSON" malformed_bodies;
          test_case "a sidebar still parses" parses_sidebar;
          test_case "a page still parses" parses_page;
          test_case "a bad breadcrumb kind is an error" bad_breadcrumbs;
        ] );
      ( "slim",
        [
          test_case "keeps only README, LICENSE and CHANGES entries" (fun () ->
              let t = parse with_many_files |> Status.slim in
              Alcotest.(check (list string))
                "files"
                [ "README.md"; "LICENSE"; "CHANGES.md" ]
                t.Status.files);
          test_case "lookups still work after slimming" (fun () ->
              let t = parse with_many_files |> Status.slim in
              Alcotest.(check (option string))
                "readme" (Some "README") (Status.readme t);
              Alcotest.(check (option string))
                "license" (Some "LICENSE") (Status.license t);
              Alcotest.(check (option string))
                "changelog" (Some "CHANGES") (Status.changelog t));
          test_case "redirections are untouched" (fun () ->
              let t = parse with_many_files |> Status.slim in
              Alcotest.(check int)
                "redirections" 1
                (List.length t.Status.redirections));
        ] );
    ]
