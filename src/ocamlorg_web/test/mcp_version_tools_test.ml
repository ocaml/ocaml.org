(* Tests for ocaml_package_versions and ocaml_package_changelog. The changelog
   tool runs end to end on a docs-ci stand-in (see [Mcp_fixtures.backend]). *)

open Mcp_fixtures
module M = Ocamlorg_web.Mcp_version_tools

let strings = Alcotest.(list string)

let payload = function
  | Ok json -> json
  | Error e -> Alcotest.failf "unexpected error: %s" e

(* --- changelog --- *)

let known l s = List.mem s l

let reads_heading_versions () =
  let hv ?(known_versions = []) ?package s =
    match M.heading_version ~is_known:(known known_versions) ?package s with
    | Some (M.Known v) -> "known " ^ v
    | Some (M.Like v) -> "like " ^ v
    | None -> "none"
  in
  Alcotest.(check string)
    "a version of the package, with its v" "known v0.16.0"
    (hv ~known_versions:[ "v0.16.0" ] "Release v0.16.0");
  Alcotest.(check string)
    "a version of the package, without its v" "known v0.17.0"
    (hv ~known_versions:[ "v0.17.0" ] "0.17.0 (2024-05-01)");
  Alcotest.(check string) "punctuation" "like 1.2.0" (hv "1.2.0:");
  Alcotest.(check string)
    "after the package name" "like 0.4.0"
    (hv ~package:"cmarkit" "cmarkit (0.4.0)");
  Alcotest.(check string) "after a lead word" "like 1.2" (hv "Version 1.2");
  Alcotest.(check string) "after a date" "like 1.2.0" (hv "2024-05-23 - 1.2.0");
  Alcotest.(check string) "no version" "none" (hv "Changes");
  Alcotest.(check string) "a date" "none" (hv "2024.01.15 release");
  Alcotest.(check string) "a year" "none" (hv "2025");
  (* A version only counts when it leads the heading. *)
  Alcotest.(check string)
    "not after another word" "none"
    (hv ~known_versions:[ "1.1"; "1.2" ] "OCaml 4.14 support");
  Alcotest.(check string)
    "even a version of the package" "none"
    (hv ~known_versions:[ "5.2.0" ] "Support for OCaml 5.2.0");
  (* The project's name, up to a "-" or "_" of the package name. *)
  Alcotest.(check string)
    "after the project name" "like 0.24.0"
    (hv ~package:"ctypes-foreign" "ctypes 0.24.0");
  Alcotest.(check string)
    "after the project name, with an underscore" "like 5.9.0"
    (hv ~package:"lwt_ppx" "Lwt 5.9.0");
  Alcotest.(check string)
    "a longer prefix" "like 6.0.0"
    (hv ~package:"cohttp-lwt-unix" "cohttp-lwt 6.0.0");
  Alcotest.(check string)
    "not a word that only starts the name" "none"
    (hv ~package:"ctypes-foreign" "ct 0.24.0");
  Alcotest.(check string)
    "not OCaml, even for an ocaml-* package" "none"
    (hv ~package:"ocaml-lsp-server" "OCaml 5.2 support")

(* ctypes-foreign's CHANGES names the project, ctypes, in its headings. *)
let project_name_headings () =
  let text =
    "# Changes\n\n\
     ## ctypes 0.24.0\n\n\
     - a\n\n\
     ## ctypes 0.23.0\n\n\
     - b\n\n\
     ## ctypes 0.22.0\n\n\
     - c\n"
  in
  let versions =
    match
      M.changelog_range
        ~is_known:(known [ "0.22.0"; "0.23.0"; "0.24.0" ])
        ~package:"ctypes-foreign" ~since:"0.23.0" text
    with
    | Some (_, versions) -> versions
    | None -> [ "no headings" ]
  in
  Alcotest.(check (list string)) "after 0.23.0" [ "0.24.0" ] versions

let range ?(known_versions = []) ?since ?until text =
  M.changelog_range ~is_known:(known known_versions) ?since ?until text

let kept ?known_versions ?since ?until text =
  match range ?known_versions ?since ?until text with
  | Some (_, versions) -> versions
  | None -> [ "no headings" ]

let text_of ?known_versions ?since ?until text =
  match range ?known_versions ?since ?until text with
  | Some (t, _) -> t
  | None -> ""

let changelog =
  {|# Changes

## v2.1.0 2025-11-25

- Fix the synopsis.

### OCaml 5.2 support

- Builds with 5.2.0.

#123 fixed for 4.14.0 users

## v2.0.0 2025-09-26

```
# 1.0.0 is not a heading in a code block
```

- Indicate the `--help` option in the usage line.

## 2024.01.15 release

## v1.3.0 2024-05-23

- Older change.|}

let selects_sections () =
  Alcotest.(check strings)
    "since" [ "v2.1.0"; "v2.0.0" ]
    (kept ~since:"1.3.0" changelog);
  Alcotest.(check strings)
    "since and until" [ "v2.0.0" ]
    (kept ~since:"v1.3.0" ~until:"2.0.0" changelog);
  Alcotest.(check strings)
    "until only" [ "v2.0.0"; "v1.3.0" ]
    (kept ~until:"v2.0.0" changelog);
  Alcotest.(check strings) "nothing newer" [] (kept ~since:"2.1.0" changelog);
  let t = text_of ~since:"1.9" changelog in
  Alcotest.(check bool) "sub-heading kept" true (contains "Builds with 5.2.0" t);
  Alcotest.(check bool) "and what follows it" true (contains "usage line" t);
  Alcotest.(check bool) "title dropped" false (contains "# Changes" t);
  Alcotest.(check bool)
    "a dated heading has no version" false (contains "2024.01.15" t)

(* The version headings are at the level with the most of them: a deeper heading
   naming a version first does not make every "### Added" a section. *)
let level_with_most_versions () =
  let changelog =
    {|## Unreleased

### Changes since 1.2.0

- Pending.

## 1.2.0

### Added

- Two.

## 1.1.0

### Fixed

- One.|}
  in
  let known_versions = [ "1.0.0"; "1.1.0"; "1.2.0" ] in
  Alcotest.(check strings)
    "the level-2 headings" [ "1.2.0"; "1.1.0" ]
    (kept ~known_versions ~since:"1.0.0" changelog);
  let t = text_of ~known_versions ~since:"1.0.0" changelog in
  Alcotest.(check bool) "with their entries" true (contains "- Two." t);
  Alcotest.(check bool) "and sub-headings" true (contains "### Fixed" t)

(* Only a bare "```" line is a fence, as {!Mcp_doc_html.transform} writes them:
   a line of a code block that starts with "```" does not end it. *)
let fences () =
  let changelog =
    {|## 1.2.0

```
To use it, write:
```ocaml
let x = 1
```

- After the block.

## 1.1.0

- Older.

## 1.0.0

- Oldest.|}
  in
  Alcotest.(check strings)
    "the headings after the block" [ "1.2.0"; "1.1.0" ]
    (kept ~since:"1.0.0" changelog)

(* A heading at the level of the version headings, with a version-like token
   that is not its first: it names no version, so its entries are not filed
   under a version that does not exist. *)
let version_in_a_title () =
  let changelog = "## 1.2\n\n- x\n\n## OCaml 4.14 support\n\n- y\n\n## 1.1\n" in
  let known_versions = [ "1.1"; "1.2" ] in
  Alcotest.(check strings)
    "sections" [ "1.2" ]
    (kept ~known_versions ~since:"1.1" changelog);
  Alcotest.(check strings)
    "a version of the package in a title" [ "5.3.0" ]
    (kept
       ~known_versions:[ "5.1.0"; "5.2.0"; "5.3.0" ]
       ~since:"5.1.0"
       "## 5.3.0\n\n- z\n\n## Support for OCaml 5.2.0\n\n- y\n\n## 5.1.0\n")

let dated_headings () =
  Alcotest.(check strings)
    "a dd.mm.yyyy date is no version" [ "1.4" ]
    (kept ~since:"1.3" "## 21.03.2024: 1.4\n\n- New.\n\n## 15.01.2024: 1.3\n")

let oldest_first () =
  let changelog =
    {|# Changelog

## 0.1.0

- First.

## 0.2.0

- Second.

## 0.3.0

- Third.|}
  in
  Alcotest.(check strings)
    "each section on its own" [ "0.2.0"; "0.3.0" ]
    (kept ~since:"0.1.0" changelog)

(* base's CHANGES.md as docs-ci renders it: "Release v0.17.0" headings, then
   older ones such as "v0.11" that are no opam version, with sub-headings. *)
let base_changes =
  {|<h3 id="release-v0.17.0"><a href="#release-v0.17.0" class="anchor"></a>Release v0.17.0</h3><p>Added functionality:</p><ul><li>Add <code>String.to_sequence</code></li></ul><h3 id="release-v0.16.0"><a href="#release-v0.16.0" class="anchor"></a>Release v0.16.0</h3><p>Changes across many modules:</p><ul><li>Replaced <code>Caml</code> with <code>Stdlib</code>.</li></ul><h3 id="old-pre-v0.15-changelogs-(very-likely-stale-and-incomplete)"><a href="#old-pre-v0.15-changelogs-(very-likely-stale-and-incomplete)" class="anchor"></a>Old pre-v0.15 changelogs (very likely stale and incomplete)</h3><h3 id="git-version"><a href="#git-version" class="anchor"></a>git version</h3><ul><li>Renamed <code>Result.ok_fst</code> to <code>Result.to_either</code>.</li></ul><h3 id="v0.11"><a href="#v0.11" class="anchor"></a>v0.11</h3><ul><li>Deprecated <code>Not_found</code>.</li></ul><h3 id="v0.10"><a href="#v0.10" class="anchor"></a>v0.10</h3><p>(Changes that can break existing programs are marked with a &quot;*&quot;)</p><h4 id="bugfixes"><a href="#bugfixes" class="anchor"></a>Bugfixes</h4><ul><li>Generalized the type of <code>Printf.ifprintf</code>.</li></ul><h3 id="v0.9"><a href="#v0.9" class="anchor"></a>v0.9</h3><p>Initial release.</p>|}

let base_versions = [ "v0.9.0"; "v0.10.0"; "v0.11.0"; "v0.16.0"; "v0.17.0" ]

let changelog_call ?(versions = base_versions) ?(docs = None) ?stalling
    ?deadline args =
  let state =
    Package.mockup_state (List.map (fun ver -> package "base" ver) versions)
  in
  let docs =
    match docs with
    | Some d -> d
    | None ->
        [
          ( "base.v0.17.0",
            `Built ([], [], [ ("doc/CHANGES.html", base_changes) ]) );
        ]
  in
  call
    (M.package_changelog ~docs:(backend ?stalling docs) ?deadline state)
    (`Assoc (("package", `String "base") :: args))

let v_prefixed_changelog () =
  List.iter
    (fun since ->
      let json = payload (changelog_call [ ("since", `String since) ]) in
      Alcotest.(check string)
        "the latest documented version" "v0.17.0"
        (to_string (member "version" json));
      Alcotest.(check bool)
        ("since " ^ since) true
        (member "section_versions" json = `List [ `String "v0.17.0" ]))
    [ "v0.16.0"; "0.16.0" ];
  let json =
    payload
      (changelog_call
         [ ("since", `String "v0.9.0"); ("until", `String "v0.11.0") ])
  in
  Alcotest.(check bool)
    "headings that are no opam version" true
    (member "section_versions" json = `List [ `String "v0.11"; `String "v0.10" ]);
  Alcotest.(check bool)
    "with their sub-headings" true
    (contains "Printf.ifprintf" (to_string (member "content" json)))

let long_changelog () =
  (* 40 sections of 4 KB each: more than the output cap, which applies after the
     range. *)
  let section i =
    Printf.sprintf "<h2>%d.0.0</h2><p>%s</p>" i (String.make 4000 'x')
  in
  let html = String.concat "" (List.init 40 (fun i -> section (40 - i))) in
  let versions = List.init 40 (fun i -> Printf.sprintf "%d.0.0" (i + 1)) in
  let docs =
    Some [ ("base.40.0.0", `Built ([], [], [ ("doc/CHANGES.html", html) ])) ]
  in
  let json =
    payload (changelog_call ~versions ~docs [ ("until", `String "2.0.0") ])
  in
  Alcotest.(check bool)
    "the old sections" true
    (member "section_versions" json = `List [ `String "2.0.0"; `String "1.0.0" ]);
  Alcotest.(check bool)
    "not truncated" false
    (member "truncated" json = `Bool true);
  let json = payload (changelog_call ~versions ~docs []) in
  Alcotest.(check bool)
    "the whole file is" true
    (member "truncated" json = `Bool true)

let changelog_errors () =
  let err ?versions ?stalling ?deadline ?(args = []) docs =
    match
      changelog_call ?versions ~docs:(Some docs) ?stalling ?deadline args
    with
    | Error e -> e
    | Ok _ -> "ok"
  in
  Alcotest.(check string)
    "no docs"
    "no documentation of base.v0.17.0 on docs-ci: it was not built (yet)"
    (err []);
  (* A status that could not be read is a backend failure, an error (which is
     not cached), and not "no documentation": neither for the version given, nor
     while looking for the latest documented one, which would then be an older
     version. *)
  let unreadable =
    "the documentation status of base.v0.17.0 could not be read from docs-ci: \
     call again later"
  in
  Alcotest.(check string)
    "unreadable status" unreadable
    (err
       ~args:[ ("version", `String "v0.17.0") ]
       [ ("base.v0.17.0", `Unreadable) ]);
  Alcotest.(check string)
    "unreadable status of a newer version" unreadable
    (err
       [
         ("base.v0.17.0", `Unreadable);
         ( "base.v0.16.0",
           `Built ([], [], [ ("doc/CHANGES.html", base_changes) ]) );
       ]);
  Alcotest.(check string)
    "docs-ci does not answer"
    "docs-ci did not answer within 0.01 s: call again later"
    (err ~stalling:[ "base.v0.17.0" ] ~deadline:0.01 []);
  Alcotest.(check string)
    "failed build"
    "the documentation build of base.v0.17.0 failed, so its changelog is not \
     available"
    (err [ ("base.v0.17.0", `Failed) ]);
  Alcotest.(check string)
    "no changelog"
    "the documentation of base.v0.17.0 has no changelog file (CHANGES, \
     CHANGELOG, ...): the package has none, or one that docs-ci does not \
     render (not in Markdown)"
    (err [ ("base.v0.17.0", `Built ([], [], [])) ]);
  Alcotest.(check string)
    "too large"
    "the CHANGES file of base.v0.17.0 is too large to read here (over 2000000 \
     bytes)"
    (err
       ~args:[ ("since", `String "v0.16.0") ]
       [
         ( "base.v0.17.0",
           `Built
             ( [],
               [],
               [
                 ( "doc/CHANGES.html",
                   "<h2>v0.17.0</h2>" ^ String.make 2_000_000 'x' );
               ] ) );
       ]);
  Alcotest.(check string)
    "unknown version" "unknown version \"v0.12.0\" of package \"base\""
    (match changelog_call [ ("version", `String "v0.12.0") ] with
    | Error e -> e
    | Ok _ -> "ok")

(* A range that ends after the version whose changelog is read gets a note: the
   changes of the versions after it are not in that changelog. *)
let older_than_range () =
  let versions = base_versions @ [ "v0.18.0" ] in
  let note args =
    to_string (member "note" (payload (changelog_call ~versions args)))
  in
  Alcotest.(check string)
    "until"
    "this is the changelog of v0.17.0, the latest documented version, older \
     than v0.18.0: the changes of the versions after v0.17.0 are not in it"
    (note [ ("since", `String "v0.17.0"); ("until", `String "v0.18.0") ]);
  Alcotest.(check string)
    "since only, with a newer version"
    "this is the changelog of v0.17.0, the latest documented version, older \
     than v0.18.0: the changes of the versions after v0.17.0 are not in it"
    (note [ ("since", `String "v0.16.0") ]);
  Alcotest.(check string)
    "a version given"
    "this is the changelog of v0.17.0, older than 0.18.0: the changes of the \
     versions after v0.17.0 are not in it"
    (note [ ("version", `String "v0.17.0"); ("until", `String "0.18.0") ]);
  Alcotest.(check string)
    "a range within the changelog" "null"
    (note [ ("since", `String "v0.16.0"); ("until", `String "v0.17.0") ]);
  Alcotest.(check string) "no range" "null" (note [])

(* "version" is found with or without its leading "v", as since and until. *)
let version_without_v () =
  let json = payload (changelog_call [ ("version", `String "0.17.0") ]) in
  Alcotest.(check string)
    "the version" "v0.17.0"
    (to_string (member "version" json))

(* --- ocaml_package_versions --- *)

let versions_state =
  Package.mockup_state
    [
      Package.create ~name:(n "pkg") ~version:(v "1.0") (info 1_700_000_000.);
      Package.create ~name:(n "pkg") ~version:(v "1.1")
        (info ~flags:[ OpamTypes.Pkgflag_Deprecated ] 1_710_000_000.);
      Package.create ~name:(n "pkg") ~version:(v "2.0")
        (info
           ~url:
             {
               Package.Info.uri = "https://example.org/<pkg>-2.0.tbz";
               checksum = [ "sha256=abc" ];
             }
           1_730_000_000.);
    ]

let versions_call args =
  payload
    (call
       (M.package_versions versions_state)
       (`Assoc (("package", `String "pkg") :: args)))

let lists_versions () =
  let json = versions_call [ ("include_source", `Bool true) ] in
  let versions = to_list (member "versions" json) in
  Alcotest.(check strings)
    "newest first" [ "2.0"; "1.1"; "1.0" ]
    (List.map (fun x -> to_string (member "version" x)) versions);
  Alcotest.(check strings)
    "dates"
    [ "2024-10-27"; "2024-03-09"; "2023-11-14" ]
    (List.map (fun x -> to_string (member "published" x)) versions);
  Alcotest.(check string)
    "labelled" "community-authored-untrusted"
    (to_string (member "content_trust" json));
  match versions with
  | [ latest; deprecated; _ ] ->
      Alcotest.(check string)
        "source url, sanitised" "https://example.org/&lt;pkg>-2.0.tbz"
        (to_string (member "url" (member "source" latest)));
      Alcotest.(check bool)
        "deprecated" true
        (member "statuses" deprecated = `List [ `String "deprecated" ])
  | _ -> Alcotest.fail "expected three versions"

let pages_versions () =
  let versions json =
    List.map
      (fun x -> to_string (member "version" x))
      (to_list (member "versions" json))
  in
  let json = versions_call [] in
  Alcotest.(check bool)
    "no source by default" true
    (List.for_all
       (fun x -> member "source" x = `Null)
       (to_list (member "versions" json)));
  Alcotest.(check bool)
    "not truncated" true
    (member "truncated" json = `Bool false);
  let json = versions_call [ ("limit", `Int 2) ] in
  Alcotest.(check strings) "first page" [ "2.0"; "1.1" ] (versions json);
  Alcotest.(check bool) "truncated" true (member "truncated" json = `Bool true);
  Alcotest.(check bool) "count" true (member "count" json = `Int 3);
  let json = versions_call [ ("limit", `Int 2); ("offset", `Int 2) ] in
  Alcotest.(check strings) "second page" [ "1.0" ] (versions json);
  Alcotest.(check bool) "last page" true (member "truncated" json = `Bool false);
  match
    call
      (M.package_versions versions_state)
      (`Assoc [ ("package", `String "pkg"); ("limit", `Int 0) ])
  with
  | Error e ->
      Alcotest.(check string)
        "bad limit" "argument \"limit\" must be an integer from 1 to 500" e
  | Ok _ -> Alcotest.fail "expected an error"

let unknown_package () =
  match
    call
      (M.package_versions versions_state)
      (`Assoc [ ("package", `String "nope") ])
  with
  | Error e -> Alcotest.(check string) "error" "unknown package: \"nope\"" e
  | Ok _ -> Alcotest.fail "expected an error"

let () =
  Alcotest.run "mcp_version_tools"
    [
      ( "changelog",
        [
          Alcotest.test_case "heading versions" `Quick reads_heading_versions;
          Alcotest.test_case "project name" `Quick project_name_headings;
          Alcotest.test_case "sections" `Quick selects_sections;
          Alcotest.test_case "oldest first" `Quick oldest_first;
          Alcotest.test_case "heading level" `Quick level_with_most_versions;
          Alcotest.test_case "fences" `Quick fences;
          Alcotest.test_case "version in a title" `Quick version_in_a_title;
          Alcotest.test_case "dated headings" `Quick dated_headings;
          Alcotest.test_case "v-prefixed versions" `Quick v_prefixed_changelog;
          Alcotest.test_case "long changelog" `Quick long_changelog;
          Alcotest.test_case "errors" `Quick changelog_errors;
          Alcotest.test_case "older than the range" `Quick older_than_range;
          Alcotest.test_case "version without v" `Quick version_without_v;
        ] );
      ( "versions",
        [
          Alcotest.test_case "list" `Quick lists_versions;
          Alcotest.test_case "paging" `Quick pages_versions;
          Alcotest.test_case "unknown package" `Quick unknown_package;
        ] );
    ]
