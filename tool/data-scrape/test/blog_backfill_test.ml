(* Unit tests for the pure helpers of the Planet keyword backfill: the pieces
   where subtle bugs surfaced during development (accent handling, tokenisation,
   stopwords, YAML quoting, idempotent rewrite, url cleaning). *)

module B = Data_scrape.Blog_backfill

let test_case n = Alcotest.test_case n `Quick
let check_string = Alcotest.(check string)
let check_bool = Alcotest.(check bool)
let check_strings = Alcotest.(check (list string))

let fold_accents =
  [
    test_case "folds French accents to ASCII, keeping the word whole" (fun () ->
        check_string "genealogie" "genealogie" (B.fold_accents "généalogie");
        check_string "requete" "requete" (B.fold_accents "requête");
        check_string "cafe" "cafe" (B.fold_accents "café");
        check_string "naive" "naive" (B.fold_accents "naïve"));
    test_case "folds the OE ligature and assorted accents" (fun () ->
        check_string "oeuvre" "oeuvre" (B.fold_accents "œuvre");
        check_string "ca" "ca" (B.fold_accents "çà"));
    test_case "leaves ASCII untouched" (fun () ->
        check_string "unchanged" "opam-repository_1"
          (B.fold_accents "opam-repository_1"));
    test_case "non-Latin bytes become separators, never gluing words" (fun () ->
        (* a checkmark (U+2713) is three high bytes -> spaces, not a joined
           word *)
        check_bool "no high bytes remain" false
          (String.exists (fun c -> Char.code c >= 0x80) (B.fold_accents "a✓b")));
  ]

let tokenize =
  [
    test_case "lowercases, folds accents, splits on non-word chars" (fun () ->
        check_strings "french phrase"
          [ "genealogie"; "du"; "logiciel" ]
          (B.tokenize "Généalogie du logiciel"));
    test_case "keeps hyphen and digits inside a token" (fun () ->
        check_strings "identifiers"
          [ "opam-repository"; "and"; "dune3" ]
          (B.tokenize "opam-repository and Dune3"));
    test_case "command example splits on paths; keeps hyphens in flags"
      (fun () ->
        (* "-" is a word char, so "--fork" stays one token; [keep_token] later
           drops it because it does not start with a letter. *)
        check_strings "command"
          [ "day10"; "--fork"; "var"; "cache"; "day10" ]
          (B.tokenize "day10 --fork /var/cache/day10"));
    test_case "keep_token drops the hyphen-led flag token" (fun () ->
        check_bool "--fork dropped" false (B.keep_token "--fork"));
  ]

let keep_token =
  [
    test_case "keeps distinctive identifiers and content words" (fun () ->
        check_bool "day10" true (B.keep_token "day10");
        check_bool "genealogie" true (B.keep_token "genealogie");
        check_bool "arm64" true (B.keep_token "arm64"));
    test_case "drops English and French stopwords" (fun () ->
        check_bool "the" false (B.keep_token "the");
        check_bool "les" false (B.keep_token "les");
        check_bool "pour" false (B.keep_token "pour"));
    test_case "drops too-short tokens and digit-leading tokens" (fun () ->
        check_bool "ab" false (B.keep_token "ab");
        check_bool "7th" false (B.keep_token "7th");
        check_bool "2024" false (B.keep_token "2024"));
  ]

let yaml_quote =
  [
    test_case "double-quotes so values never decode as bool/number/null"
      (fun () ->
        check_string "yes" {|"yes"|} (B.yaml_quote "yes");
        check_string "day10" {|"day10"|} (B.yaml_quote "day10");
        check_string "phrase" {|"pattern matching"|}
          (B.yaml_quote "pattern matching"));
    test_case "escapes embedded quotes and backslashes" (fun () ->
        check_string "quote" {|"a\"b"|} (B.yaml_quote {|a"b|});
        check_string "backslash" {|"a\\b"|} (B.yaml_quote {|a\b|}));
  ]

let strip_keywords =
  [
    test_case "removes an existing keywords block, leaving other fields"
      (fun () ->
        let fm = "title: Foo\nkeywords:\n- \"a\"\n- \"b\"\nurl: x\n" in
        check_string "stripped" "title: Foo\nurl: x\n" (B.strip_keywords fm));
    test_case "is a no-op when there is no keywords block" (fun () ->
        let fm = "title: Foo\nurl: x\n" in
        check_string "unchanged" fm (B.strip_keywords fm));
  ]

let clean_url =
  [
    test_case "strips wrapping %20 and trims" (fun () ->
        check_string "wrapped" "https://frama-c.com/fc-versions/titanium.html"
          (B.clean_url "%20https://frama-c.com/fc-versions/titanium.html%20");
        check_string "trimmed" "https://a.com/b"
          (B.clean_url "  https://a.com/b  "));
    test_case "collapses a bogus /%20/ path segment" (fun () ->
        check_string "mid-path" "http://frama-c.com/jobs/a.html"
          (B.clean_url "http://frama-c.com/%20/jobs/a.html%20"));
    test_case "leaves a clean url untouched" (fun () ->
        check_string "unchanged" "https://normal.example/x"
          (B.clean_url "https://normal.example/x"));
  ]

module R = Data_scrape.Scrape_report

let aggregate_keywords =
  let post kws = R.New_post { source_id = "s"; title = "t"; keywords = kws } in
  [
    test_case "ranks by frequency across posts, ties alphabetical" (fun () ->
        check_strings "top keywords"
          [ "effects"; "dune"; "lwt" ]
          (R.aggregate_keywords
             [
               post [ "effects"; "lwt" ];
               post [ "effects"; "dune" ];
               post [ "effects"; "dune" ];
             ]));
    test_case "honours the top-n cap and ignores non-post entries" (fun () ->
        check_strings "capped" [ "effects"; "dune" ]
          (R.aggregate_keywords ~n:2
             [
               post [ "effects"; "effects"; "dune"; "gadt" ];
               R.Video_update { file = "v"; new_count = 1 };
             ]));
    test_case "empty when there are no post keywords" (fun () ->
        check_strings "empty" [] (R.aggregate_keywords [ post [] ]));
    test_case "commit subject is \"[posts] <keywords>\"" (fun () ->
        let buf = Buffer.create 64 in
        R.format_commit_message buf [ post [ "effects"; "dune" ] ];
        let subject =
          List.hd (String.split_on_char '\n' (Buffer.contents buf))
        in
        check_string "subject" "[posts] dune, effects" subject);
  ]

let () =
  Alcotest.run "planet-keywords"
    [
      ("fold_accents", fold_accents);
      ("tokenize", tokenize);
      ("keep_token", keep_token);
      ("yaml_quote", yaml_quote);
      ("strip_keywords", strip_keywords);
      ("clean_url", clean_url);
      ("aggregate_keywords", aggregate_keywords);
    ]
