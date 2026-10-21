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

let parse s = Yojson.Safe.from_string s |> Status.of_yojson |> Result.get_ok
let test_case n = Alcotest.test_case n `Quick

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
