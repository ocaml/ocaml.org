(* Plain-text excerpts of changelog entries, shown on the home page. *)

let excerpt ?max_bytes md =
  Data_packer.Markdown.Excerpt.of_doc ?max_bytes
    (Cmarkit.Doc.of_string ~strict:true md)

let check name expected md = Alcotest.(check string) name expected (excerpt md)
let ellipsis = "\xe2\x80\xa6"

let markdown () =
  check "first paragraph, headings skipped" "Some text with code and a link."
    "## TL;DR\n\n\
     Some *text* with `code` and a [link](https://ocaml.org).\n\n\
     More.";
  check "soft breaks become spaces" "one two" "one\ntwo";
  check "list item" "Fix a bug (#1, @someone)" "- Fix a bug (#1, @someone)";
  check "paragraph without text skipped" "Real text."
    "<img src=\"a.png\"></img>\n\nReal text.";
  check "empty document" "" ""

let html () =
  check "tags stripped, entities decoded"
    "CHANGES: Fixed Fix #1, which broke a < b & c (@someone)"
    "<p>CHANGES:</p>\n\
     <h3>Fixed</h3>\n\
     <ul>\n\
     <li>Fix <a href=\"x\">#1</a>, which broke <code>a &lt; b &amp; c</code> \
     (<a href=\"y\">@someone</a>)</li>\n\
     </ul>";
  check "numeric references" "caf\xc3\xa9 \xe2\x86\x92"
    "<p>caf&#233; &#x2192;</p>"

let cut () =
  let words = String.concat " " (List.init 40 (fun _ -> "caf\xc3\xa9")) in
  let e = excerpt ~max_bytes:50 words in
  Alcotest.(check bool) "valid UTF-8" true (String.is_valid_utf_8 e);
  Alcotest.(check bool)
    "ends with an ellipsis" true
    (String.ends_with ~suffix:ellipsis e);
  Alcotest.(check bool)
    "cut between words" true
    (String.ends_with ~suffix:("caf\xc3\xa9" ^ ellipsis) e);
  Alcotest.(check bool) "bounded" true (String.length e <= 50 + 3);
  (* No space to cut at: the cut still falls on a character boundary. *)
  let one_word = String.concat "" (List.init 40 (fun _ -> "\xe2\x86\x92")) in
  for max_bytes = 10 to 20 do
    let e = excerpt ~max_bytes one_word in
    Alcotest.(check bool)
      (Printf.sprintf "valid UTF-8 at max_bytes %d" max_bytes)
      true (String.is_valid_utf_8 e)
  done;
  check "short text is not cut" "Short." "Short."

let () =
  Alcotest.run "excerpt"
    [
      ( "excerpt",
        [
          Alcotest.test_case "markdown" `Quick markdown;
          Alcotest.test_case "html" `Quick html;
          Alcotest.test_case "cut" `Quick cut;
        ] );
    ]
