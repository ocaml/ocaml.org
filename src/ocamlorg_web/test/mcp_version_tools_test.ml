(* Tests for the version tools: ocaml_package_versions, ocaml_api_changes and
   ocaml_package_changelog. The item extraction runs on fragments of real odoc
   pages (lwt 5.9.0), and both docs tools run end to end on a docs-ci stand-in
   (see [Mcp_fixtures.backend]). *)

open Mcp_fixtures
module M = Ocamlorg_web.Mcp_version_tools

let strings = Alcotest.(list string)
let opt = Alcotest.(option string)

(* --- items of odoc pages --- *)

(* Fragments of lwt 5.9.0's Lwt and Lwt_result pages, as docs-ci serves them
   (their doc comments removed): a type with constructors, values, an operator,
   an exception, a submodule, and an include. *)
let type_state =
  {|<div class="odoc-spec"><div class="spec type anchored" id="type-state"><a href="#type-state" class="anchor"></a><a href="../../src/lwt/lwt.ml.html#module-Miscellaneous.type-state" class="source_link">Source</a><code><span><span class="keyword">type</span> <span>'a state</span></span><span> = </span></code><ol><li id="type-state.Return" class="def variant constructor anchored"><a href="#type-state.Return" class="anchor"></a><code><span>| </span><span><span class="constructor">Return</span> <span class="keyword">of</span> <span class="type-var">'a</span></span></code></li><li id="type-state.Fail" class="def variant constructor anchored"><a href="#type-state.Fail" class="anchor"></a><code><span>| </span><span><span class="constructor">Fail</span> <span class="keyword">of</span> exn</span></code></li><li id="type-state.Sleep" class="def variant constructor anchored"><a href="#type-state.Sleep" class="anchor"></a><code><span>| </span><span><span class="constructor">Sleep</span></span></code></li></ol></div></div>|}

let val_state =
  {|<div class="odoc-spec"><div class="spec value anchored" id="val-state"><a href="#val-state" class="anchor"></a><a href="../../src/lwt/lwt.ml.html#module-Miscellaneous.val-state" class="source_link">Source</a><code><span><span class="keyword">val</span> state : <span><span><span class="type-var">'a</span> <a href="#type-t">t</a></span> <span class="arrow">&#45;&gt;</span></span> <span><span class="type-var">'a</span> <a href="#type-state">state</a></span></span></code></div></div>|}

let val_operator =
  {|<div class="odoc-spec"><div class="spec value anchored" id="val-(&lt;?&gt;)"><a href="#val-(&lt;?&gt;)" class="anchor"></a><a href="../../src/lwt/lwt.ml.html#module-Infix.val-(&lt;?&gt;)" class="source_link">Source</a><code><span><span class="keyword">val</span> (&lt;?&gt;) : <span><span><span class="type-var">'a</span> <a href="#type-t">t</a></span> <span class="arrow">&#45;&gt;</span></span> <span><span><span class="type-var">'a</span> <a href="#type-t">t</a></span> <span class="arrow">&#45;&gt;</span></span> <span><span class="type-var">'a</span> <a href="#type-t">t</a></span></span></code></div></div>|}

let exception_canceled =
  {|<div class="odoc-spec"><div class="spec exception anchored" id="exception-Canceled"><a href="#exception-Canceled" class="anchor"></a><a href="../../src/lwt/lwt.ml.html#module-Resolution_loop.exception-Canceled" class="source_link">Source</a><code><span><span class="keyword">exception</span> </span><span><span class="exception">Canceled</span></span></code></div></div>|}

let module_infix =
  {|<div class="odoc-spec"><div class="spec module anchored" id="module-Infix"><a href="#module-Infix" class="anchor"></a><a href="../../src/lwt/lwt.ml.html#module-Infix" class="source_link">Source</a><code><span><span class="keyword">module</span> <a href="Infix/index.html">Infix</a></span><span> : <span class="keyword">sig</span> ... <span class="keyword">end</span></span></code></div></div>|}

let include_infix =
  {|<div class="odoc-include"><details open="open"><summary class="spec include"><code><span><span class="keyword">include</span> <span class="keyword">module</span> <span class="keyword">type</span> <span class="keyword">of</span> <a href="Infix/index.html">Infix</a></span></code></summary><div class="odoc-spec"><div class="spec value anchored" id="val-(&gt;|=)"><a href="#val-(&gt;|=)" class="anchor"></a><a href="../../src/lwt/lwt_result.ml.html#module-Infix.val-(&gt;|=)" class="source_link">Source</a><code><span><span class="keyword">val</span> (&gt;|=) : <span><span><span>(<span class="type-var">'a</span>, <span class="type-var">'e</span>)</span> <a href="#type-t">t</a></span> <span class="arrow">&#45;&gt;</span></span> <span><span>(<span><span class="type-var">'a</span> <span class="arrow">&#45;&gt;</span></span> <span class="type-var">'b</span>)</span> <span class="arrow">&#45;&gt;</span></span> <span><span>(<span class="type-var">'b</span>, <span class="type-var">'e</span>)</span> <a href="#type-t">t</a></span></span></code></div></div></details></div>|}

(* Written the way odoc writes them, for what lwt's pages lack: a section
   heading whose anchor looks like an item's ("{1 Type safety}" gets
   "type-safety"), followed by prose with code; a record field; and a type
   extension, whose declaration has an anchor of its own. *)
let heading =
  {|<h2 id="type-safety"><a href="#type-safety" class="anchor"></a>Type safety</h2><p>See <code>hostile</code>.</p><h3 id="module-types"><a href="#module-types" class="anchor"></a>Module types</h3>|}

let record ~field_type =
  Printf.sprintf
    {|<div class="odoc-spec"><div class="spec type anchored" id="type-r"><a href="#type-r" class="anchor"></a><code><span><span class="keyword">type</span> r</span><span> = </span><span>{</span></code><ol><li id="type-r.label" class="def record field anchored"><a href="#type-r.label" class="anchor"></a><code><span>label : %s;</span></code></li></ol><code><span>}</span></code></div></div>|}
    field_type

let extension =
  {|<div class="odoc-spec"><div class="spec type extension anchored" id="extension-decl-Timeout"><a href="#extension-decl-Timeout" class="anchor"></a><code><span><span class="keyword">type</span> <a href="#type-t">t</a> += </span></code><ol><li id="extension-Timeout" class="def variant extension anchored"><a href="#extension-Timeout" class="anchor"></a><code><span>| </span><span><span class="extension">Timeout</span> <span class="keyword">of</span> float</span></code></li></ol></div></div>|}

let page ?(with_operator = true) ?(field_type = "string") () =
  String.concat "\n"
    ([
       {|<header class="odoc-preamble"><h1>Module <code><span>Lwt</span></code></h1></header><div class="odoc-content">|};
       heading;
       type_state;
       val_state;
     ]
    @ (if with_operator then [ val_operator ] else [])
    @ [
        exception_canceled;
        module_infix;
        include_infix;
        record ~field_type;
        extension;
        "</div>";
      ])

let describe (e : M.api_entry) =
  Printf.sprintf "%s %s: %s" e.kind e.qualified e.signature

let extracts_items () =
  let entries, truncated = M.api_entries (page ()) in
  Alcotest.(check bool) "not truncated" false truncated;
  Alcotest.(check strings)
    "anchored items only, in page order"
    [
      "type state: type 'a state =";
      "constructor state.Return: | Return of 'a";
      "constructor state.Fail: | Fail of exn";
      "constructor state.Sleep: | Sleep";
      "value state: val state : 'a t -> 'a state";
      "value (<?>): val (<?>) : 'a t -> 'a t -> 'a t";
      "exception Canceled: exception Canceled";
      "module Infix: module Infix : sig ... end";
      "value (>|=): val (>|=) : ('a, 'e) t -> ('a -> 'b) -> ('b, 'e) t";
      "type r: type r = {";
      "field r.label: label : string;";
      "extension Timeout: | Timeout of float";
    ]
    (List.map describe entries)

let diffs_pages () =
  let before, _ = M.api_entries (page ()) in
  let after, _ =
    M.api_entries (page ~with_operator:false ~field_type:"bytes" ())
  in
  let added, removed, changed = M.api_diff ~before ~after in
  Alcotest.(check strings) "added" [] (List.map describe added);
  Alcotest.(check strings)
    "removed"
    [ "value (<?>): val (<?>) : 'a t -> 'a t -> 'a t" ]
    (List.map describe removed);
  Alcotest.(check strings)
    "changed"
    [ "label : string; -> label : bytes;" ]
    (List.map
       (fun ((b : M.api_entry), (a : M.api_entry)) ->
         b.signature ^ " -> " ^ a.signature)
       changed)

let finds_entries () =
  let entries, _ = M.api_entries (page ()) in
  let find kind name =
    Option.map
      (fun (e : M.api_entry) -> e.kind ^ " " ^ e.qualified)
      (M.find_entry ~kind ~name entries)
  in
  let ident s = Result.get_ok (M.parse_identifier s) in
  Alcotest.(check opt) "value" (Some "value state") (find "value" "state");
  Alcotest.(check opt) "type" (Some "type state") (find "type" "state");
  Alcotest.(check opt)
    "constructor" (Some "constructor state.Fail")
    (find "constructor" "Fail");
  Alcotest.(check opt)
    "qualified" (Some "constructor state.Fail") (find "any" "state.Fail");
  Alcotest.(check opt) "field" (Some "field r.label") (find "field" "label");
  Alcotest.(check opt)
    "an extension is a constructor" (Some "extension Timeout")
    (find "constructor" "Timeout");
  Alcotest.(check opt)
    "operator" (Some "value (<?>)")
    (find "any" (ident "<?>"));
  Alcotest.(check opt)
    "operator in parentheses" (Some "value (<?>)")
    (find "value" (ident "( <?> )"));
  Alcotest.(check opt)
    "operator of an include" (Some "value (>|=)")
    (find "any" (ident ">|="));
  Alcotest.(check opt) "a heading is no item" None (find "type" "safety");
  Alcotest.(check opt) "nor is its code" None (find "any" "hostile");
  Alcotest.(check opt) "wrong kind" None (find "value" "Canceled");
  Alcotest.(check opt) "absent" None (find "any" "proto_solve")

let parses_identifiers () =
  let p s = match M.parse_identifier s with Ok s -> s | Error e -> e in
  Alcotest.(check string) "name" "run" (p "run");
  Alcotest.(check string) "qualified" "t.Foo" (p "t.Foo");
  Alcotest.(check string) "operator" "(>>=)" (p ">>=");
  Alcotest.(check string) "binding operator" "(let*)" (p "( let* )");
  Alcotest.(check string) "invalid" "invalid identifier: \"x y\"" (p "x y")

(* --- versions and history --- *)

let vs l = List.map Package.Version.to_string l

let selects_versions () =
  let all = List.map v [ "1.0"; "1.2"; "1.10"; "2.0"; "0.9" ] in
  let selected, truncated = M.select_versions ~max:10 all in
  Alcotest.(check strings)
    "oldest first, opam order"
    [ "0.9"; "1.0"; "1.2"; "1.10"; "2.0" ]
    (vs selected);
  Alcotest.(check bool) "not truncated" false truncated;
  let selected, truncated =
    M.select_versions ~from:(v "1.0") ~until:(v "1.10") ~max:2 all
  in
  Alcotest.(check strings) "newest in range" [ "1.2"; "1.10" ] (vs selected);
  Alcotest.(check bool) "truncated" true truncated

let summarises_history () =
  let check msg (expected, oldest, expected_changed) l =
    let f, last, i, o, r, changed = M.history_summary l in
    Alcotest.(check (list opt)) msg expected [ f; last; i; r ];
    Alcotest.(check bool) (msg ^ ": present in oldest") oldest o;
    Alcotest.(check strings) (msg ^ ": changed") expected_changed changed
  in
  check "introduced, changed, removed; unknown versions skipped"
    ([ Some "1.1"; Some "1.3"; Some "1.1"; Some "2.0" ], false, [ "1.3" ])
    [
      ("1.0", M.Absent);
      ("1.1", M.Present "val f : int");
      ("1.2", M.Present "val f : int");
      ("1.3", M.Present "val f : string");
      ("1.4", M.Unknown);
      ("2.0", M.Absent);
    ];
  check "present in the oldest version checked: not introduced there"
    ([ Some "1.8.0"; Some "1.8.2"; None; Some "1.9.0" ], true, [])
    [
      ("1.7.0", M.Unknown);
      ("1.8.0", M.Present "x");
      ("1.8.2", M.Present "x");
      ("1.9.0", M.Absent);
    ];
  check "never present"
    ([ None; None; None; None ], false, [])
    [ ("1.0", M.Absent); ("2.0", M.Unknown) ]

(* --- ocaml_api_changes, end to end on a docs-ci stand-in --- *)

(* lwt with its documented versions: the sidebar of the fixture, and the Lwt
   page as given. *)
let built ?(sidebar = lwt_sidebar) pages = `Built (sidebar, pages, [])
let lwt_page html = [ ("lwt/Lwt/index.html", html) ]

let lwt_state versions =
  Package.mockup_state (List.map (fun ver -> package "lwt" ver) versions)

let api_call ?raising docs versions args =
  call
    (M.api_changes ~docs:(backend ?raising docs) (lwt_state versions))
    (`Assoc (("package", `String "lwt") :: args))

let payload = function
  | Ok (json, partial) -> (json, partial)
  | Error e -> Alcotest.failf "unexpected error: %s" e

let statuses json =
  List.map
    (fun x ->
      to_string (member "version" x) ^ " " ^ to_string (member "status" x))
    (to_list (member "versions" json))

let tracks_an_identifier () =
  let docs =
    [
      ("lwt.1.0", `Missing);
      ("lwt.1.1", built (lwt_page (page ~with_operator:false ())));
      ("lwt.1.2", built (lwt_page (page ())));
      ("lwt.1.3", `Failed);
      ("lwt.1.4", built (lwt_page (page ())));
      ( "lwt.2.0",
        built
          ~sidebar:
            (List.map
               (fun (n : Ocamlorg_frontend.Navmap.toc) ->
                 { n with children = [] })
               lwt_sidebar)
          [] );
    ]
  in
  let json, partial =
    payload
      (api_call docs
         [ "1.0"; "1.1"; "1.2"; "1.3"; "1.4"; "2.0" ]
         [ ("module", `String "Lwt"); ("identifier", `String "<?>") ])
  in
  Alcotest.(check bool) "complete" false partial;
  Alcotest.(check strings)
    "statuses"
    [
      "1.0 no-docs";
      "1.1 absent";
      "1.2 present";
      "1.3 docs-failed";
      "1.4 present";
      "2.0 module-not-found";
    ]
    (statuses json);
  Alcotest.(check string)
    "operator, sanitised" "(&lt;?>)"
    (to_string (member "identifier" json));
  Alcotest.(check string)
    "introduced" "1.2"
    (to_string (member "introduced_in" json));
  Alcotest.(check string)
    "a module gone from documented versions removes the item" "2.0"
    (to_string (member "removed_in" json));
  Alcotest.(check string)
    "the page used" "lwt/Lwt/index.html"
    (to_string (member "path" (List.nth (to_list (member "versions" json)) 2)))

let backend_failures_are_partial () =
  let json, partial =
    payload
      (api_call ~raising:[ "lwt.1.1" ]
         [
           ("lwt.1.0", built (lwt_page (page ())));
           ("lwt.1.1", built (lwt_page (page ())));
           (* documented, but its page cannot be fetched *)
           ("lwt.1.2", built []);
         ]
         [ "1.0"; "1.1"; "1.2" ]
         [ ("module", `String "Lwt"); ("identifier", `String "state") ])
  in
  Alcotest.(check bool) "marked partial, so not cached" true partial;
  Alcotest.(check bool) "said so" true (member "partial" json = `Bool true);
  Alcotest.(check strings)
    "statuses"
    [ "1.0 present"; "1.1 error"; "1.2 docs-unavailable" ]
    (statuses json)

let compares_two_versions () =
  let docs =
    [
      ("lwt.1.0", built (lwt_page (page ())));
      ("lwt.1.1", `Missing);
      ("lwt.2.0", built (lwt_page (page ~with_operator:false ())));
      ("lwt.2.1", `Missing);
    ]
  in
  let json, partial =
    payload
      (api_call docs
         [ "1.0"; "1.1"; "2.0"; "2.1" ]
         [ ("module", `String "Lwt"); ("kind", `String "value") ])
  in
  Alcotest.(check bool) "complete" false partial;
  Alcotest.(check string)
    "to: the latest documented version" "2.0"
    (to_string (member "version" (member "to" json)));
  Alcotest.(check string)
    "from: the documented version before it" "1.0"
    (to_string (member "version" (member "from" json)));
  Alcotest.(check strings)
    "removed, sanitised"
    [ "(&lt;?>): val (&lt;?>) : 'a t -> 'a t -> 'a t" ]
    (List.map
       (fun e ->
         to_string (member "name" e) ^ ": " ^ to_string (member "signature" e))
       (to_list (member "removed" json)));
  Alcotest.(check bool)
    "kind is reported ignored" true
    (member "ignored_arguments" json = `List [ `String "kind" ]);
  Alcotest.(check string)
    "labelled" "community-authored-untrusted"
    (to_string (member "content_trust" json))

let ambiguous_module () =
  let page = "<div></div>" in
  let docs =
    [
      ( "lwt.1.0",
        built
          [
            ("lwt/Lwt/Infix/index.html", page);
            ("lwt/Lwt_result/Infix/index.html", page);
          ] );
      ( "lwt.2.0",
        built
          [
            ("lwt/Lwt/Infix/index.html", page);
            ("lwt/Lwt_result/Infix/index.html", page);
          ] );
    ]
  in
  let json, _ =
    payload
      (api_call docs [ "1.0"; "2.0" ]
         [ ("module", `String "Infix"); ("from_version", `String "1.0") ])
  in
  let side = member "to" json in
  Alcotest.(check string)
    "the first match" "Lwt.Infix"
    (to_string (member "module" side));
  Alcotest.(check bool)
    "the other one" true
    (member "ambiguous_with" side = `List [ `String "Lwt_result.Infix" ])

(* A doc author controls no signature, but a page can say anything: what looks
   like markup or a Markdown image in a signature comes out inert, and invisible
   characters are dropped. *)
let hostile_signatures () =
  let hostile =
    {|<div class="odoc-spec"><div class="spec value anchored" id="val-x"><code><span>val x : [ &lt;img src=https://evil.example/?x&gt; ![a](https://evil.example/b) ]|}
    ^ "\xe2\x80\x8b</span></code></div></div>"
  in
  let docs =
    [
      ("lwt.1.0", built (lwt_page (page ())));
      ("lwt.2.0", built (lwt_page (page () ^ hostile)));
    ]
  in
  let json, _ =
    payload
      (api_call docs [ "1.0"; "2.0" ]
         [ ("module", `String "Lwt"); ("from_version", `String "1.0") ])
  in
  match to_list (member "added" json) with
  | [ e ] ->
      let s = to_string (member "signature" e) in
      Alcotest.(check string)
        "escaped, defanged, no invisible character"
        "val x : [ &lt;img src=https://evil.example/?x> ![a] \
         (https://evil.example/b) ]"
        s
  | l -> Alcotest.failf "expected one added item, got %d" (List.length l)

let api_changes_errors () =
  let err args =
    match api_call [] [ "1.0"; "2.0" ] args with Error e -> e | Ok _ -> "ok"
  in
  let m = ("module", `String "Lwt") in
  Alcotest.(check string)
    "module required" "missing required argument: \"module\"" (err []);
  Alcotest.(check string)
    "invalid module" "invalid module path: \"a/b\""
    (err [ ("module", `String "a/b") ]);
  Alcotest.(check string)
    "invalid identifier" "invalid identifier: \"x y\""
    (err [ m; ("identifier", `String "x y") ]);
  Alcotest.(check string)
    "unknown kind"
    "unknown kind: \"function\"; expected one of any, value, type, \
     constructor, field, extension, exception, module, module-type, class, \
     class-type"
    (err [ m; ("kind", `String "function") ]);
  Alcotest.(check string)
    "max_versions range"
    "argument \"max_versions\" must be an integer from 1 to 60"
    (err [ m; ("max_versions", `Int 0) ]);
  Alcotest.(check string)
    "from after to" "from_version \"2.0\" is newer than to_version \"1.0\""
    (err [ m; ("from_version", `String "2.0"); ("to_version", `String "1.0") ]);
  Alcotest.(check string)
    "unknown version" "unknown version \"1.5\" of package \"lwt\""
    (err [ m; ("to_version", `String "1.5") ]);
  Alcotest.(check string)
    "unknown package" "unknown package: \"nope\""
    (match
       call
         (M.api_changes ~docs:(backend []) (lwt_state [ "1.0" ]))
         (`Assoc [ ("package", `String "nope"); m ])
     with
    | Error e -> e
    | Ok _ -> "ok")

(* --- changelog --- *)

let known l s = List.mem s l

let reads_heading_versions () =
  let hv ?(known_versions = []) s =
    match M.heading_version ~is_known:(known known_versions) s with
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
  Alcotest.(check string) "parenthesised" "like 0.4.0" (hv "cmarkit (0.4.0)");
  Alcotest.(check string) "no version" "none" (hv "Changes");
  Alcotest.(check string) "a date" "none" (hv "2024.01.15 release");
  Alcotest.(check string) "a year" "none" (hv "2025")

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

let changelog_call ?(versions = base_versions) ?(docs = None) args =
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
    (M.package_changelog ~docs:(backend docs) state)
    (`Assoc (("package", `String "base") :: args))

let v_prefixed_changelog () =
  List.iter
    (fun since ->
      let json, _ = payload (changelog_call [ ("since", `String since) ]) in
      Alcotest.(check string)
        "the latest documented version" "v0.17.0"
        (to_string (member "version" json));
      Alcotest.(check bool)
        ("since " ^ since) true
        (member "section_versions" json = `List [ `String "v0.17.0" ]))
    [ "v0.16.0"; "0.16.0" ];
  let json, _ =
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
  let json, _ =
    payload (changelog_call ~versions ~docs [ ("until", `String "2.0.0") ])
  in
  Alcotest.(check bool)
    "the old sections" true
    (member "section_versions" json = `List [ `String "2.0.0"; `String "1.0.0" ]);
  Alcotest.(check bool)
    "not truncated" false
    (member "truncated" json = `Bool true);
  let json, _ = payload (changelog_call ~versions ~docs []) in
  Alcotest.(check bool)
    "the whole file is" true
    (member "truncated" json = `Bool true)

let changelog_errors () =
  let err ?versions docs =
    match changelog_call ?versions ~docs:(Some docs) [] with
    | Error e -> e
    | Ok _ -> "ok"
  in
  Alcotest.(check string)
    "no docs"
    "no documentation of base.v0.17.0 on docs-ci: it was not built (yet), or \
     could not be fetched"
    (err []);
  Alcotest.(check string)
    "failed build"
    "the documentation build of base.v0.17.0 failed, so its changelog is not \
     available"
    (err [ ("base.v0.17.0", `Failed) ]);
  Alcotest.(check string)
    "no changelog"
    "the documentation of base.v0.17.0 has no changelog file (CHANGES, \
     CHANGELOG, ...)"
    (err [ ("base.v0.17.0", `Built ([], [], [])) ]);
  Alcotest.(check string)
    "unknown version" "unknown version \"v0.12.0\" of package \"base\""
    (match changelog_call [ ("version", `String "v0.12.0") ] with
    | Error e -> e
    | Ok _ -> "ok")

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
               Package.Info.uri = "https://example.org/pkg-2.0.tbz";
               checksum = [ "sha256=abc" ];
             }
           1_730_000_000.);
    ]

let lists_versions () =
  let json, _ =
    payload
      (call
         (M.package_versions versions_state)
         (`Assoc [ ("package", `String "pkg") ]))
  in
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
        "source url" "https://example.org/pkg-2.0.tbz"
        (to_string (member "url" (member "source" latest)));
      Alcotest.(check bool)
        "deprecated" true
        (member "statuses" deprecated = `List [ `String "deprecated" ])
  | _ -> Alcotest.fail "expected three versions"

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
      ( "api",
        [
          Alcotest.test_case "items" `Quick extracts_items;
          Alcotest.test_case "diff" `Quick diffs_pages;
          Alcotest.test_case "find entries" `Quick finds_entries;
          Alcotest.test_case "identifiers" `Quick parses_identifiers;
          Alcotest.test_case "select versions" `Quick selects_versions;
          Alcotest.test_case "summary" `Quick summarises_history;
          Alcotest.test_case "identifier history" `Quick tracks_an_identifier;
          Alcotest.test_case "partial" `Quick backend_failures_are_partial;
          Alcotest.test_case "two versions" `Quick compares_two_versions;
          Alcotest.test_case "ambiguous module" `Quick ambiguous_module;
          Alcotest.test_case "hostile signatures" `Quick hostile_signatures;
          Alcotest.test_case "errors" `Quick api_changes_errors;
        ] );
      ( "changelog",
        [
          Alcotest.test_case "heading versions" `Quick reads_heading_versions;
          Alcotest.test_case "sections" `Quick selects_sections;
          Alcotest.test_case "oldest first" `Quick oldest_first;
          Alcotest.test_case "v-prefixed versions" `Quick v_prefixed_changelog;
          Alcotest.test_case "long changelog" `Quick long_changelog;
          Alcotest.test_case "errors" `Quick changelog_errors;
        ] );
      ( "versions",
        [
          Alcotest.test_case "list" `Quick lists_versions;
          Alcotest.test_case "unknown package" `Quick unknown_package;
        ] );
    ]
