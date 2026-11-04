(* Unit tests for Planet post descriptions: choosing a source, shortening, and
   the front-matter rewrite of the backfill. *)

module D = Data_scrape.Description
module DB = Data_scrape.Description_backfill

let test_case n = Alcotest.test_case n `Quick
let check_string = Alcotest.(check string)
let check_bool = Alcotest.(check bool)
let check_opt = Alcotest.(check (option string))
let no_page () = None
let sentence = "This sentence is exactly fifty characters long, ok."
let long_text n = String.concat " " (List.init n (fun _ -> sentence))

let shorten =
  [
    test_case "short text is only normalised" (fun () ->
        check_string "collapsed" "a b c" (D.shorten "  a\n\n b\t\xc2\xa0c "));
    test_case "long text is cut after the last fitting sentence" (fun () ->
        let s = D.shorten (long_text 20) in
        check_bool "fits" true (String.length s <= D.max_length);
        check_bool "ends a sentence" true (String.ends_with ~suffix:"ok." s);
        (* 7 sentences of 50 chars plus separators = 356 bytes *)
        check_string "seven sentences" (long_text 7) s);
    test_case "without a sentence end, cut at a word with an ellipsis"
      (fun () ->
        let s =
          D.shorten (String.concat " " (List.init 200 (fun _ -> "word")))
        in
        check_bool "fits" true (String.length s <= D.max_length);
        check_bool "ellipsis" true (String.ends_with ~suffix:D.ellipsis s);
        check_bool "whole words" true
          (String.ends_with ~suffix:("word" ^ D.ellipsis) s));
    test_case "a word cut never splits a UTF-8 sequence" (fun () ->
        let s =
          D.shorten (String.concat " " (List.init 200 (fun _ -> "été")))
        in
        check_bool "valid UTF-8" true (String.is_valid_utf_8 s));
  ]

let lead =
  [
    test_case "takes paragraphs, skipping code, tables, headings, figures"
      (fun () ->
        let html =
          "<h2>Title</h2><p>First <code>alice</code> para.</p><pre>-----\n\
           ---\n\
           </pre><table><tr><td>cell</td></tr></table><figure><figcaption>cap</figcaption></figure><p>Second \
           para.</p>"
        in
        check_opt "lead" (Some "First alice para. Second para.")
          (D.lead_of_html html));
    test_case "plain text content without paragraphs is used whole" (fun () ->
        check_opt "text" (Some "just text") (D.lead_of_html "just  text"));
    test_case "block elements separate words, inline ones do not" (fun () ->
        check_opt "list" (Some "one two-three")
          (D.lead_of_html "<ul><li>one</li><li>two-<em>three</em></li></ul>"));
    test_case "empty content gives nothing" (fun () ->
        check_opt "none" None (D.lead_of_html ""));
  ]

let meta =
  [
    test_case "prefers og:description" (fun () ->
        check_opt "og" (Some "og text")
          (D.meta_of_html
             {|<head><meta name="description" content="plain"><meta property="og:description" content="og text"></head>|}));
    test_case "falls back to the description meta tag" (fun () ->
        check_opt "name" (Some "plain")
          (D.meta_of_html {|<meta name="description" content="plain">|}));
    test_case "ignores empty values" (fun () ->
        check_opt "none" None
          (D.meta_of_html {|<meta property="og:description" content="  ">|}));
  ]

let choose =
  let page_with m () =
    Some (Printf.sprintf {|<meta property="og:description" content="%s">|} m)
  in
  [
    test_case "a short feed summary is kept, without fetching" (fun () ->
        let page () = Alcotest.fail "page fetched" in
        check_opt "summary" (Some "A short summary.")
          (D.choose ~summary:(Some " A short\nsummary. ") ~content:"" ~page));
    test_case "a long summary gives way to the page meta description" (fun () ->
        check_opt "meta" (Some "From the page.")
          (D.choose
             ~summary:(Some (long_text 20))
             ~content:"<p>Body.</p>"
             ~page:(page_with "From the page.")));
    test_case "then to the lead of the body" (fun () ->
        check_opt "lead" (Some "Body.")
          (D.choose
             ~summary:(Some (long_text 20))
             ~content:"<p>Body.</p>" ~page:no_page));
    test_case "a missing summary also uses the page" (fun () ->
        check_opt "meta" (Some "From the page.")
          (D.choose ~summary:None ~content:""
             ~page:(page_with "From the page.")));
    test_case "last resort: the summary, shortened" (fun () ->
        check_opt "shortened"
          (Some (long_text 7))
          (D.choose ~summary:(Some (long_text 20)) ~content:"" ~page:no_page));
  ]

let backfill =
  [
    test_case "replaces only the description entry" (fun () ->
        let fm =
          "title: T\ndescription: \"long\\nfolded\n  continued\"\nurl: u\n"
        in
        check_string "patched" "title: T\ndescription: new\nurl: u\n"
          (DB.replace_description fm "description: new"));
    test_case "drops blank lines inside a multi-line value" (fun () ->
        let fm = "title: T\ndescription: 'para one\n\n  para two'\nurl: u\n" in
        check_string "patched" "title: T\ndescription: new\nurl: u\n"
          (DB.replace_description fm "description: new"));
    test_case "keeps the trailing newline when description is last" (fun () ->
        check_string "patched" "title: T\ndescription: new\n"
          (DB.replace_description "title: T\ndescription: x\n  y\n"
             "description: new"));
    test_case "the written entry decodes back to the description" (fun () ->
        let d = {|Quotes " and: colons, # hashes — and ünïcode…|} in
        match Yaml.of_string (DB.description_entry d) with
        | Ok (`O [ ("description", `String d') ]) -> check_string "round" d d'
        | _ -> Alcotest.fail "bad YAML");
  ]

let () =
  Alcotest.run "description"
    [
      ("shorten", shorten);
      ("lead", lead);
      ("meta", meta);
      ("choose", choose);
      ("backfill", backfill);
    ]
