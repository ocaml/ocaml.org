(* Tests for ocaml_module_changes. The item extraction runs on fragments of real
   odoc pages (lwt 5.9.0), and the tool runs end to end on a docs-ci stand-in
   (see [Mcp_fixtures.backend]). *)

open Mcp_fixtures
module M = Ocamlorg_web.Mcp_api_changes

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

let present signature =
  M.Present
    {
      kind = "value";
      name = "f";
      qualified = "f";
      signature;
      sig_key = M.signature_key signature;
    }

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
      ("1.1", present "val f : int");
      ("1.2", present "val f : int");
      ("1.3", present "val f : string");
      ("1.4", M.Unknown);
      ("2.0", M.Absent);
    ];
  check "present in the oldest version checked: not introduced there"
    ([ Some "1.8.0"; Some "1.8.2"; None; Some "1.9.0" ], true, [])
    [
      ("1.7.0", M.Unknown);
      ("1.8.0", present "x");
      ("1.8.2", present "x");
      ("1.9.0", M.Absent);
    ];
  check "present in the oldest version checked, removed and added back"
    ([ Some "1.0"; Some "3.0"; None; Some "2.0" ], true, [])
    [ ("1.0", present "x"); ("2.0", M.Absent); ("3.0", present "x") ];
  check "never present"
    ([ None; None; None; None ], false, [])
    [ ("1.0", M.Absent); ("2.0", M.Unknown) ]

(* --- ocaml_module_changes, end to end on a docs-ci stand-in --- *)

(* lwt with its documented versions: the sidebar of the fixture, and the Lwt
   page as given. *)
let built ?(sidebar = lwt_sidebar) pages = `Built (sidebar, pages, [])
let lwt_page html = [ ("lwt/Lwt/index.html", html) ]

let lwt_state versions =
  Package.mockup_state (List.map (fun ver -> package "lwt" ver) versions)

let api_call ?raising ?stalling ?deadline docs versions args =
  call_partial
    (M.api_changes
       ~docs:(backend ?raising ?stalling docs)
       ?deadline (lwt_state versions))
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
  Alcotest.(check bool)
    "deadline not reached" true
    (member "deadline_reached" json = `Bool false);
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
  Alcotest.(check string)
    "the first match" "Lwt.Infix"
    (to_string (member "resolved_module" json));
  Alcotest.(check string)
    "its page" "lwt/Lwt/Infix/index.html"
    (to_string (member "path" (member "to" json)));
  Alcotest.(check bool)
    "the other one" true
    (member "ambiguous_with" json = `List [ `String "Lwt_result.Infix" ])

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

(* --- the fixes of the second review --- *)

module Navmap = Ocamlorg_frontend.Navmap

let node ?(kind = Navmap.Module) ?(children = []) title href : Navmap.toc =
  { title; kind; href = Some ("/p/lwt/1.0/doc/" ^ href); children }

let library name children : Navmap.toc =
  {
    title = "Library <code>" ^ name ^ "</code>";
    kind = Navmap.Library;
    href = None;
    children;
  }

let value ?(signature = "int") id =
  Printf.sprintf
    {|<div class="odoc-spec"><div class="spec value anchored" id="val-%s"><code><span>val %s : %s</span></code></div></div>|}
    id id signature

(* A page that has the item, and one too large to be read whole that does not
   have it: the item is not absent there, only not found. *)
let truncated_page_is_unknown () =
  let big =
    String.concat "" (List.init 5001 (fun i -> value (Printf.sprintf "x%d" i)))
  in
  let json, partial =
    payload
      (api_call
         [
           ("lwt.1.0", built (lwt_page (page ())));
           ("lwt.2.0", built (lwt_page big));
         ]
         [ "1.0"; "2.0" ]
         [ ("module", `String "Lwt"); ("identifier", `String "state") ])
  in
  Alcotest.(check bool) "complete" false partial;
  Alcotest.(check strings)
    "statuses"
    [ "1.0 present"; "2.0 page-truncated" ]
    (statuses json);
  Alcotest.(check string)
    "not removed" "null"
    (to_string (member "removed_in" json))

(* Version 1.0 has only [Aaa.Result]; 2.0 adds a top-level [Result], which is
   what "Result" means there. Each version is read at that full path, so 1.0 is
   not about another module. *)
let one_module_across_versions () =
  let result_page = value "map" in
  let sidebar top =
    [
      library "x"
        [
          node "Aaa" "x/Aaa/index.html"
            ~children:[ node "Result" "x/Aaa/Result/index.html" ];
        ];
    ]
    @
    if top then [ library "y" [ node "Result" "y/Result/index.html" ] ] else []
  in
  let docs =
    [
      ( "lwt.1.0",
        built ~sidebar:(sidebar false)
          [ ("x/Aaa/Result/index.html", result_page) ] );
      ( "lwt.2.0",
        built ~sidebar:(sidebar true)
          [
            ("x/Aaa/Result/index.html", result_page);
            ("y/Result/index.html", value "map");
          ] );
    ]
  in
  let json, _ =
    payload
      (api_call docs [ "1.0"; "2.0" ]
         [ ("module", `String "Result"); ("identifier", `String "map") ])
  in
  Alcotest.(check string)
    "resolved in the newest version" "Result"
    (to_string (member "resolved_module" json));
  Alcotest.(check string) "there" "2.0" (to_string (member "resolved_in" json));
  Alcotest.(check strings)
    "1.0 has no top-level Result"
    [ "1.0 module-not-found"; "2.0 present" ]
    (statuses json);
  Alcotest.(check string)
    "nothing removed" "null"
    (to_string (member "removed_in" json));
  (* The other way round: the module is found in 2.0 only under its full path,
     which 1.0 has too. *)
  let json, _ =
    payload
      (api_call docs [ "1.0"; "2.0" ]
         [ ("module", `String "Aaa.Result"); ("identifier", `String "map") ])
  in
  Alcotest.(check strings)
    "present in both"
    [ "1.0 present"; "2.0 present" ]
    (statuses json);
  let json, _ =
    payload
      (api_call docs [ "1.0"; "2.0" ]
         [ ("module", `String "Result"); ("from_version", `String "1.0") ])
  in
  Alcotest.(check string)
    "diff: the old version lacks the module" "module-not-found"
    (to_string (member "status" (member "from" json)));
  Alcotest.(check bool) "so no diff" true (member "added" json = `Null)

let truncated_ambiguity () =
  let sidebar =
    [
      library "x"
        (List.init 25 (fun i ->
             let m = Printf.sprintf "M%02d" i in
             node m
               (Printf.sprintf "x/%s/index.html" m)
               ~children:
                 [
                   node "S" ~kind:Navmap.Module_type
                     (Printf.sprintf "x/%s/module-type-S/index.html" m);
                 ]));
    ]
  in
  let json, _ =
    payload
      (api_call
         [
           ( "lwt.1.0",
             built ~sidebar [ ("x/M00/module-type-S/index.html", value "x") ] );
         ]
         [ "1.0" ]
         [ ("module", `String "S"); ("identifier", `String "x") ])
  in
  Alcotest.(check int)
    "19 others" 19
    (List.length (to_list (member "ambiguous_with" json)));
  Alcotest.(check bool)
    "said to be cut" true
    (member "ambiguous_with_truncated" json = `Bool true)

let named_operators () =
  let p s = match M.parse_identifier s with Ok s -> s | Error e -> e in
  Alcotest.(check string) "keyword operator" "(mod)" (p "mod");
  Alcotest.(check string) "in parentheses" "(land)" (p "( land )");
  Alcotest.(check string) "indexing operator" "(.%{})" (p ".%{}");
  Alcotest.(check string) "indexing assignment" "(.%()<-)" (p "(.%()<-)");
  Alcotest.(check string) "multi-index" "(.%{;..})" (p ".%{;..}");
  Alcotest.(check string) "a name in parentheses" "x" (p "(x)");
  let entries, _ =
    M.api_entries (value "(mod)" ^ value ~signature:"string" "(.%{})")
  in
  let find s =
    Option.map
      (fun (e : M.api_entry) -> e.signature)
      (M.find_entry ~kind:"value" ~name:(p s) entries)
  in
  Alcotest.(check opt) "mod" (Some "val (mod) : int") (find "mod");
  Alcotest.(check opt) "(.%{})" (Some "val (.%{}) : string") (find ".%{}")

(* The fields of inline records, as odoc anchors them: by the type for a
   constructor (base v0.17.3's Base.Sequence.Step has "type-t.state" twice, in
   [Skip of { state }] and [Yield of { value; state }]), and ".x" (odoc 3, top
   of the page), "module-M.x" (odoc 3, in the page of submodule [M]) or
   "field-x" (older odoc) for an exception or an extension constructor. *)
let inline_record ?(yield_state = "'s") () =
  Printf.sprintf
    {|<div class="odoc-spec"><div class="spec type anchored" id="type-t"><code><span>type t = </span></code><ol><li id="type-t.Skip" class="def variant constructor anchored"><a href="#type-t.Skip" class="anchor"></a><code><span>| </span><span><span class="constructor">Skip</span> <span class="keyword">of</span> </span><span>{</span></code><ol><li id="type-t.state" class="def record field anchored"><a href="#type-t.state" class="anchor"></a><code><span>state : <span class="type-var">'s</span>;</span></code></li></ol><code><span>}</span></code></li><li id="type-t.Yield" class="def variant constructor anchored"><a href="#type-t.Yield" class="anchor"></a><code><span>| </span><span><span class="constructor">Yield</span> <span class="keyword">of</span> </span><span>{</span></code><ol><li id="type-t.value" class="def record field anchored"><a href="#type-t.value" class="anchor"></a><code><span>value : <span class="type-var">'a</span>;</span></code></li><li id="type-t.state" class="def record field anchored"><a href="#type-t.state" class="anchor"></a><code><span>state : %s;</span></code></li></ol><code><span>}</span></code></li></ol></div></div>|}
    yield_state
  ^ {|<div class="odoc-spec"><div class="spec exception anchored" id="exception-E"><code><span>exception E of {</span></code><ol><li id=".x" class="def record field anchored"><code><span>x : int;</span></code></li></ol><code><span>}</span></code></div></div>|}
  ^ {|<div class="odoc-spec"><div class="spec exception anchored" id="exception-F"><code><span>exception F of {</span></code><ol><li id="module-M.w" class="def record field anchored"><code><span>w : int;</span></code></li></ol><code><span>}</span></code></div></div>|}
  ^ {|<div class="odoc-spec"><div class="spec type extension anchored" id="extension-decl-G"><code><span>type u += </span></code><ol><li id="extension-G" class="def variant extension anchored"><code><span>| G of {</span></code><ol><li id="field-y" class="def record field anchored"><code><span>y : int;</span></code></li></ol><code><span>}</span></code></li></ol></div></div>|}

let inline_record_fields () =
  let entries, _ = M.api_entries (inline_record ()) in
  Alcotest.(check strings)
    "each field named after its constructor"
    [
      "type t";
      "constructor t.Skip";
      "field t.Skip.state";
      "constructor t.Yield";
      "field t.Yield.value";
      "field t.Yield.state";
      "exception E";
      "field E.x";
      "exception F";
      "field F.w";
      "extension G";
      "field G.y";
    ]
    (List.map (fun (e : M.api_entry) -> e.kind ^ " " ^ e.qualified) entries);
  let find name =
    Option.map
      (fun (e : M.api_entry) -> e.kind ^ " " ^ e.qualified)
      (M.find_entry ~kind:"field" ~name entries)
  in
  Alcotest.(check opt)
    "by its own name: the first" (Some "field t.Skip.state") (find "state");
  Alcotest.(check opt)
    "with its constructor" (Some "field t.Yield.state") (find "Yield.state");
  Alcotest.(check opt)
    "qualified" (Some "field t.Yield.state") (find "t.Yield.state");
  Alcotest.(check opt) "of an exception" (Some "field E.x") (find "E.x");
  let after, _ = M.api_entries (inline_record ~yield_state:"int" ()) in
  let _, _, changed = M.api_diff ~before:entries ~after in
  Alcotest.(check strings)
    "a change of the second field of that name" [ "t.Yield.state" ]
    (List.map (fun ((e : M.api_entry), _) -> e.qualified) changed)

let duplicate_ids () =
  let entries, _ =
    M.api_entries (value "x" ^ value ~signature:"string" "x" ^ value "y")
  in
  let added, removed, changed = M.api_diff ~before:entries ~after:entries in
  Alcotest.(check int)
    "a page does not change from itself" 0
    (List.length added + List.length removed + List.length changed)

(* A status that could not be read is a backend failure (partial, not cached),
   not a version without documentation. *)
let unreadable_status () =
  let json, partial =
    payload
      (api_call
         [ ("lwt.1.0", built (lwt_page (page ()))); ("lwt.2.0", `Unreadable) ]
         [ "1.0"; "2.0" ]
         [ ("module", `String "Lwt"); ("identifier", `String "state") ])
  in
  Alcotest.(check bool) "partial" true partial;
  Alcotest.(check strings)
    "statuses"
    [ "1.0 present"; "2.0 docs-unavailable" ]
    (statuses json);
  (* The default versions of a comparison: the latest documented version is not
     known. *)
  match
    api_call
      [ ("lwt.1.0", built (lwt_page (page ()))); ("lwt.2.0", `Unreadable) ]
      [ "1.0"; "2.0" ]
      [ ("module", `String "Lwt") ]
  with
  | Error e ->
      Alcotest.(check string)
        "comparison"
        "the documentation status of lwt.2.0 could not be read from docs-ci: \
         call again later"
        e
  | Ok _ -> Alcotest.fail "expected an error"

(* docs-ci accepts the connection and says nothing: a version is skipped at the
   deadline, and so are the default-version probes of a comparison. *)
(* The deadline only bounds the wait for the stalled version: long enough for
   the other one to be read on a slow CI machine. *)
let stalled_docs_ci () =
  let docs =
    [ ("lwt.1.0", built (lwt_page (page ()))); ("lwt.2.0", `Missing) ]
  in
  let json, partial =
    payload
      (api_call ~stalling:[ "lwt.2.0" ] ~deadline:2. docs [ "1.0"; "2.0" ]
         [ ("module", `String "Lwt"); ("identifier", `String "state") ])
  in
  Alcotest.(check bool) "partial" true partial;
  Alcotest.(check strings)
    "statuses"
    [ "1.0 present"; "2.0 skipped" ]
    (statuses json);
  Alcotest.(check bool)
    "deadline reached" true
    (member "deadline_reached" json = `Bool true);
  match
    api_call ~stalling:[ "lwt.2.0" ] ~deadline:2. docs [ "1.0"; "2.0" ]
      [ ("module", `String "Lwt") ]
  with
  | Error e ->
      Alcotest.(check string)
        "comparison" "docs-ci did not answer within 2 s: call again later" e
  | Ok _ -> Alcotest.fail "expected an error"

(* --- the fixes of the third review --- *)

let big_page =
  String.concat "" (List.init 5001 (fun i -> value (Printf.sprintf "x%d" i)))

(* A page too large to be read whole lacks items: the items of the other page
   missing from it are neither added nor removed, as far as is known. *)
let truncated_page_in_a_diff () =
  let diff ~from_page ~to_page =
    payload
      (api_call
         [
           ("lwt.1.0", built (lwt_page from_page));
           ("lwt.2.0", built (lwt_page to_page));
         ]
         [ "1.0"; "2.0" ]
         [ ("module", `String "Lwt"); ("from_version", `String "1.0") ])
  in
  let json, partial = diff ~from_page:(page ()) ~to_page:big_page in
  Alcotest.(check bool) "complete" false partial;
  Alcotest.(check bool) "removed unknown" true (member "removed" json = `Null);
  Alcotest.(check bool) "added known" true (to_list (member "added" json) <> []);
  Alcotest.(check bool) "truncated" true (member "truncated" json = `Bool true);
  let json, _ = diff ~from_page:big_page ~to_page:(page ()) in
  Alcotest.(check bool) "added unknown" true (member "added" json = `Null);
  Alcotest.(check bool)
    "removed known" true
    (to_list (member "removed" json) <> [])

(* Version 1.0 has a value [label] and a field [r.label]; 2.0 has the field
   only. The item followed is the same in every version. *)
let one_item_across_versions () =
  let docs =
    [
      ("lwt.1.0", built (lwt_page (value "label" ^ record ~field_type:"int")));
      ("lwt.2.0", built (lwt_page (record ~field_type:"int")));
    ]
  in
  let history args =
    payload
      (api_call docs [ "1.0"; "2.0" ]
         (("module", `String "Lwt") :: ("identifier", `String "label") :: args))
    |> fst
  in
  let json = history [] in
  Alcotest.(check string)
    "the item of the newest version" "field"
    (to_string (member "kind" json));
  Alcotest.(check string)
    "its full name" "r.label"
    (to_string (member "resolved_identifier" json));
  Alcotest.(check strings)
    "the field in both"
    [ "1.0 present"; "2.0 present" ]
    (statuses json);
  Alcotest.(check strings)
    "unchanged" []
    (to_list (member "changed_in" json) |> List.map to_string);
  let json = history [ ("kind", `String "value") ] in
  Alcotest.(check string) "the value" "value" (to_string (member "kind" json));
  Alcotest.(check string)
    "removed, not changed into the field" "2.0"
    (to_string (member "removed_in" json))

let from_version_after_latest_documented () =
  match
    api_call
      [
        ("lwt.1.0", built (lwt_page (page ())));
        ("lwt.2.0", built (lwt_page (page ())));
        ("lwt.2.1", `Missing);
      ]
      [ "1.0"; "2.0"; "2.1" ]
      [ ("module", `String "Lwt"); ("from_version", `String "2.1") ]
  with
  | Error e ->
      Alcotest.(check string)
        "error"
        "from_version \"2.1\" is newer than the latest documented version \
         \"2.0\""
        e
  | Ok _ -> Alcotest.fail "expected an error"

(* Signatures are compared whole, past the part shown, and without the spaces
   odoc lays out differently from one version to the next. *)
let compares_signatures () =
  let long = String.make 3000 'a' in
  let entries sigs =
    fst
      (M.api_entries
         (String.concat ""
            (List.mapi
               (fun i signature -> value ~signature (Printf.sprintf "f%d" i))
               sigs)))
  in
  let _, _, changed =
    M.api_diff
      ~before:(entries [ "f:(int -> int) -> int"; long ^ " -> int" ])
      ~after:(entries [ "f: ( int -> int ) -> int"; long ^ " -> bool" ])
  in
  Alcotest.(check strings)
    "only the change past the part shown" [ "f1" ]
    (List.map (fun ((e : M.api_entry), _) -> e.qualified) changed)

let identifier_forms () =
  let p s = match M.parse_identifier s with Ok s -> s | Error e -> e in
  Alcotest.(check string) "polymorphic variant tag" "Null" (p "`Null");
  match
    api_call [] [ "1.0" ]
      [ ("module", `String "Lwt"); ("identifier", `String "Lwt.run") ]
  with
  | Error e ->
      Alcotest.(check string)
        "module path"
        "identifier \"Lwt.run\" starts with the module path: give it as \"run\""
        e
  | Ok _ -> Alcotest.fail "expected an error"

(* Many large changes: the lists stop at a total size. *)
let diff_size_is_bounded () =
  let page =
    String.concat ""
      (List.init 150 (fun i ->
           value ~signature:(String.make 1000 'a') (Printf.sprintf "x%d" i)))
  in
  let json, _ =
    payload
      (api_call
         [
           ("lwt.1.0", built (lwt_page page)); ("lwt.2.0", built (lwt_page ""));
         ]
         [ "1.0"; "2.0" ]
         [ ("module", `String "Lwt"); ("from_version", `String "1.0") ])
  in
  let n = List.length (to_list (member "removed" json)) in
  Alcotest.(check bool) "some, not all" true (n > 0 && n < 150);
  Alcotest.(check bool) "truncated" true (member "truncated" json = `Bool true)

(* --- the fixes of the fourth review --- *)

let diff_of ?(args = []) ~from_page ~to_page () =
  payload
    (api_call
       [
         ("lwt.1.0", built (lwt_page from_page));
         ("lwt.2.0", built (lwt_page to_page));
       ]
       [ "1.0"; "2.0" ]
       (("module", `String "Lwt") :: ("from_version", `String "1.0") :: args))
  |> fst

(* The "to" page has too many items to be read whole, so the items removed are
   not known: they leave the whole budget to the one item changed. *)
let unknown_list_takes_no_budget () =
  let values ?signature prefix n =
    String.concat ""
      (List.init n (fun i -> value ?signature (Printf.sprintf "%s%d" prefix i)))
  in
  let json =
    diff_of
      ~from_page:
        (value ~signature:(String.make 1500 'a') "x"
        ^ values ~signature:(String.make 1000 'a') "y" 500)
      ~to_page:(value ~signature:(String.make 1500 'b') "x" ^ values "z" 5001)
      ()
  in
  Alcotest.(check bool) "removed unknown" true (member "removed" json = `Null);
  Alcotest.(check strings)
    "changed" [ "x" ]
    (List.map
       (fun e -> to_string (member "name" e))
       (to_list (member "changed" json)))

(* The budget is the size of the text given, after "<" becomes "&lt;". *)
let budget_counts_sanitised_text () =
  let page =
    String.concat ""
      (List.init 150 (fun i ->
           value
             ~signature:(String.concat "" (List.init 1000 (fun _ -> "&lt;")))
             (Printf.sprintf "x%d" i)))
  in
  let json = diff_of ~from_page:page ~to_page:"" () in
  let size =
    List.fold_left
      (fun n e ->
        n
        + String.length (to_string (member "name" e))
        + String.length (to_string (member "signature" e)))
      0
      (to_list (member "removed" json))
  in
  Alcotest.(check bool) "at most 100 KB" true (size <= 100_000)

let same_version () =
  let docs =
    [
      ("lwt.1.0", built (lwt_page (page ())));
      ("lwt.2.0", built (lwt_page (page ())));
    ]
  in
  let err args =
    match
      api_call docs [ "1.0"; "2.0" ] (("module", `String "Lwt") :: args)
    with
    | Error e -> e
    | Ok _ -> "ok"
  in
  Alcotest.(check string)
    "both given"
    "from_version and to_version are both \"2.0\": nothing to compare"
    (err [ ("from_version", `String "2.0"); ("to_version", `String "2.0") ]);
  Alcotest.(check string)
    "to_version by default"
    "from_version \"2.0\" is the latest documented version, the default \
     to_version: nothing to compare"
    (err [ ("from_version", `String "2.0") ])

let identifier_not_found () =
  let docs =
    [
      ("lwt.1.0", built (lwt_page (page ())));
      ("lwt.1.1", `Missing);
      ("lwt.2.0", built (lwt_page (page ())));
    ]
  in
  let err ident =
    match
      api_call docs [ "1.0"; "1.1"; "2.0" ]
        [ ("module", `String "Lwt"); ("identifier", `String ident) ]
    with
    | Error e -> e
    | Ok _ -> "ok"
  in
  Alcotest.(check string)
    "a typo" "identifier \"stat\" not found in Lwt in versions 1.0 to 2.0"
    (err "stat");
  Alcotest.(check string)
    "an item of a submodule"
    "identifier \"Infix.map\" not found in Lwt in versions 1.0 to 2.0; if \
     \"Infix\" is a submodule, pass \"module\": \"Lwt.Infix\" and \
     \"identifier\": \"map\""
    (err "Infix.map")

let () =
  Alcotest.run "mcp_api_changes"
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
      ( "second review",
        [
          Alcotest.test_case "truncated page" `Quick truncated_page_is_unknown;
          Alcotest.test_case "one module across versions" `Quick
            one_module_across_versions;
          Alcotest.test_case "truncated ambiguity" `Quick truncated_ambiguity;
          Alcotest.test_case "named operators" `Quick named_operators;
          Alcotest.test_case "inline record fields" `Quick inline_record_fields;
          Alcotest.test_case "duplicate ids" `Quick duplicate_ids;
          Alcotest.test_case "unreadable status" `Quick unreadable_status;
          Alcotest.test_case "stalled docs-ci" `Quick stalled_docs_ci;
        ] );
      ( "third review",
        [
          Alcotest.test_case "truncated page in a diff" `Quick
            truncated_page_in_a_diff;
          Alcotest.test_case "one item across versions" `Quick
            one_item_across_versions;
          Alcotest.test_case "from_version after the latest" `Quick
            from_version_after_latest_documented;
          Alcotest.test_case "signature comparison" `Quick compares_signatures;
          Alcotest.test_case "identifier forms" `Quick identifier_forms;
          Alcotest.test_case "diff size" `Quick diff_size_is_bounded;
        ] );
      ( "fourth review",
        [
          Alcotest.test_case "unknown list and budget" `Quick
            unknown_list_takes_no_budget;
          Alcotest.test_case "budget after sanitising" `Quick
            budget_counts_sanitised_text;
          Alcotest.test_case "same version" `Quick same_version;
          Alcotest.test_case "identifier not found" `Quick identifier_not_found;
        ] );
    ]
