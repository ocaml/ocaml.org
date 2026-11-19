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

(* --- The status cache, through [Documentation.status]: a fake fetch counts the
   status.json requests and a fake clock moves time. A status and a missing
   status.json (404) are kept for the full TTL (OCAMLORG_PACKAGE_CACHES_TTL,
   3600 s by default), a failure to read it only for the negative TTL
   (OCAMLORG_DOC_NEGATIVE_TTL, 60 s by default). The times are computed from
   both, so that the tests hold whatever they are set to, provided the negative
   TTL is the shorter by more than 2 s. --- *)

let ttl = Documentation.For_testing.package_caches_ttl
let negative_ttl = Documentation.For_testing.doc_negative_ttl

let package ?(name = "foo") ?(version = "1.0.0") () =
  Ocamlorg_package.create
    ~name:(Ocamlorg_package.Name.of_string name)
    ~version:(Ocamlorg_package.Version.of_string version)
    {
      Ocamlorg_package.Info.synopsis = "";
      description = "";
      authors = [];
      maintainers = [];
      license = "";
      homepage = [];
      tags = [];
      dependencies = [];
      rev_deps = [];
      depopts = [];
      conflicts = [];
      url = None;
      publication = 0.;
      flags = [];
    }

(* The answers of [Documentation.status] for [package] at the given times, on a
   fresh cache, with a backend that always answers [response], and the number of
   status.json requests made. *)
let statuses_at response times =
  let package = package () in
  let state = Ocamlorg_package.mockup_state [ package ] in
  let clock = ref 0. and requests = ref [] in
  let get url =
    requests := url :: !requests;
    Lwt.return response
  in
  let answers =
    List.map
      (fun t ->
        clock := t;
        Lwt_main.run
          (Documentation.For_testing.status ~get
             ~now:(fun () -> !clock)
             ~kind:`Package state package)
        |> Option.map (fun (s : Status.t) -> s.name))
      times
  in
  (answers, List.rev !requests)

let requested ~expected (response, times) =
  let _, requests = statuses_at response times in
  Alcotest.(check int) "status.json requests" expected (List.length requests)

let status_is_cached () =
  let answers, requests =
    statuses_at (Ok without_digest) [ 0.; negative_ttl +. 1.; ttl -. 1. ]
  in
  Alcotest.(check (list (option string)))
    "the status"
    [ Some "foo"; Some "foo"; Some "foo" ]
    answers;
  (match requests with
  | [ url ] ->
      Alcotest.(check bool)
        "the version's status.json" true
        (String.ends_with ~suffix:"p/foo/1.0.0/status.json" url)
  | _ -> Alcotest.fail "expected one request");
  requested ~expected:2 (Ok without_digest, [ 0.; ttl +. 1. ])

let missing_status_is_cached () =
  let answers, _ = statuses_at (Error `Not_found) [ 0. ] in
  Alcotest.(check (list (option string))) "no status" [ None ] answers;
  requested ~expected:1 (Error `Not_found, [ 0.; negative_ttl +. 1.; ttl -. 1. ]);
  requested ~expected:2 (Error `Not_found, [ 0.; ttl +. 1. ])

let failures_are_cached_briefly () =
  List.iter
    (fun response ->
      let answers, _ = statuses_at response [ 0. ] in
      Alcotest.(check (list (option string))) "no status" [ None ] answers;
      requested ~expected:1 (response, [ 0.; negative_ttl /. 2. ]);
      requested ~expected:2 (response, [ 0.; negative_ttl +. 1. ]))
    [
      Error (`Msg "timed out after 30s fetching status.json");
      Error (`Msg "Failed to fetch status.json");
      Ok "<html><body>Bad gateway</body></html>";
      Ok {|{"name": "foo"}|};
    ]

(* [latest_documented_version] over versions 3.0, 2.0 and 1.0 of foo, whose
   status.json requests are answered with [statuses] (given for 1.0, 2.0 and
   3.0; [Error `Not_found] for none), on a fresh cache. Also the versions whose
   status was requested, in order. *)
let latest_documented statuses =
  let versions = [ "1.0"; "2.0"; "3.0" ] in
  let state =
    Ocamlorg_package.mockup_state
      (List.map (fun version -> package ~version ()) versions)
  in
  let requests = ref [] in
  let get url =
    match
      List.find_opt
        (fun (v, _) -> String.ends_with ~suffix:("/" ^ v ^ "/status.json") url)
        (List.combine versions statuses)
    with
    | Some (v, response) ->
        requests := v :: !requests;
        Lwt.return response
    | None -> Alcotest.failf "unexpected fetch: %s" url
  in
  let latest =
    Lwt_main.run
      (Documentation.For_testing.latest_documented_version ~get
         ~now:(fun () -> 0.)
         state
         (Ocamlorg_package.Name.of_string "foo"))
    |> Result.map (Option.map Ocamlorg_package.Version.to_string)
  in
  (latest, List.rev !requests)

let latest_documented_version () =
  let unreadable = Error (`Msg "timed out after 30s fetching status.json") in
  let check name ~expected ~requested statuses =
    let latest, requests = latest_documented statuses in
    Alcotest.(check (result (option string) unit)) name expected latest;
    Alcotest.(check (list string)) (name ^ ": requests") requested requests
  in
  (* Statuses of 1.0, 2.0 and 3.0. *)
  check "skips a version without documentation" ~expected:(Ok (Some "1.0"))
    ~requested:[ "3.0"; "2.0"; "1.0" ]
    [ Ok without_digest; Error `Not_found; Error `Not_found ];
  check "none documented" ~expected:(Ok None) ~requested:[ "3.0"; "2.0"; "1.0" ]
    [ Error `Not_found; Error `Not_found; Error `Not_found ];
  check "stops at a status that could not be read" ~expected:(Error ())
    ~requested:[ "3.0"; "2.0" ]
    [ Ok without_digest; unreadable; Error `Not_found ];
  check "after a documented version" ~expected:(Ok (Some "3.0"))
    ~requested:[ "3.0" ]
    [ Ok without_digest; unreadable; Ok without_digest ]

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
      ( "status cache",
        [
          test_case "a status is kept for the full TTL" status_is_cached;
          test_case "so is a missing status.json (404)" missing_status_is_cached;
          test_case "a failure only for the negative TTL"
            failures_are_cached_briefly;
          test_case "the latest documented version" latest_documented_version;
        ] );
    ]
