(* Case-insensitive matching uses Unicode case folding (issue #3912). *)

module S = Ocamlorg.Import.String

let e_acute = "\xc3\xa9" (* é *)
let e_acute_upper = "\xc3\x89" (* É *)
let sharp_s = "\xc3\x9f" (* ß *)
let u3a40 = "\xe3\xa9\x80" (* U+3A40, whose bytes start like "é" in Latin-1 *)

let pieces =
  Alcotest.testable
    (fun ppf l ->
      List.iter
        (function
          | `Text s -> Format.fprintf ppf "Text %S; " s
          | `Delim s -> Format.fprintf ppf "Delim %S; " s)
        l)
    ( = )

let test_fold () =
  Alcotest.(check string) "ASCII" "hello, world" (S.fold "Hello, WORLD");
  Alcotest.(check string)
    "accented" ("caf" ^ e_acute)
    (S.fold ("CAF" ^ e_acute_upper));
  Alcotest.(check string) "sharp s" "strasse" (S.fold ("Stra" ^ sharp_s ^ "e"));
  Alcotest.(check string) "Greek" "\xcf\x83" (S.fold "\xce\xa3");
  Alcotest.(check string) "invalid UTF-8" "a\xef\xbf\xbd" (S.fold "A\xff")

let test_is_sub_ignore_case () =
  Alcotest.(check bool) "ASCII" true (S.is_sub_ignore_case "caml" "OCaml");
  Alcotest.(check bool)
    "accented" true
    (S.is_sub_ignore_case ("universit" ^ e_acute)
       ("Universit" ^ e_acute_upper ^ " Paris"));
  Alcotest.(check bool) "no match" false (S.is_sub_ignore_case "rust" "OCaml")

let test_fold_split () =
  let split terms text = S.fold_split ~terms text in
  Alcotest.check pieces "no terms" [ `Text "abc" ] (split [] "abc");
  Alcotest.check pieces "ASCII, ignoring case"
    [ `Text "Learn "; `Delim "OCaml"; `Text " and "; `Delim "ocaml" ]
    (split [ "ocaml" ] "Learn OCaml and ocaml");
  Alcotest.check pieces "accented, original case kept"
    [ `Text "Une "; `Delim (e_acute_upper ^ "cole") ]
    (split [ e_acute ^ "cole" ] ("Une " ^ e_acute_upper ^ "cole"));
  (* Latin-1 folding made "é" match the start of U+3A40 and split it. *)
  Alcotest.check pieces "no match inside a character"
    [ `Text u3a40 ]
    (split [ e_acute ] u3a40);
  Alcotest.check pieces
    "partial match of an expanding fold covers the character"
    [ `Delim "S"; `Text "tra"; `Delim sharp_s; `Text "e" ]
    (split [ "s" ] ("Stra" ^ sharp_s ^ "e"));
  Alcotest.check pieces "match across an expanding fold"
    [ `Delim ("Stra" ^ sharp_s ^ "e") ]
    (split [ "strasse" ] ("Stra" ^ sharp_s ^ "e"));
  Alcotest.check pieces "several terms"
    [ `Delim "a"; `Text "-"; `Delim "B" ]
    (split [ "a"; "b" ] "a-B")

let test_uppercase_first () =
  Alcotest.(check string) "empty" "" (S.utf_8_uppercase_first "");
  Alcotest.(check string) "ASCII" "A" (S.utf_8_uppercase_first "alice");
  Alcotest.(check string)
    "accented" e_acute_upper
    (S.utf_8_uppercase_first (e_acute ^ "milie"));
  Alcotest.(check string)
    "no case" "\xe6\x9d\x8e"
    (S.utf_8_uppercase_first "\xe6\x9d\x8e\xe5\x9b\x9b")

let test_tutorial_search () =
  (* Highlighting is built from fold_split pieces, so it keeps characters whole
     and matches regardless of case. *)
  let html =
    Ocamlorg_frontend.Search.highlight_search_terms ~class_:"h"
      ~search:e_acute_upper
      (u3a40 ^ " " ^ e_acute)
  in
  Alcotest.(check string)
    "highlight"
    (u3a40 ^ {| <span class="h">|} ^ e_acute ^ "</span>")
    html

let test_sectionless_search () =
  (* A missing section used to score log 0 = -inf, so these documents (the
     preamble of each tutorial) never matched any query (issue #3918). *)
  let sectionless =
    List.filter
      (fun (doc : Data.Tutorial.search_document) -> doc.section = None)
      Data.Tutorial.all_search_documents
  in
  Alcotest.(check bool) "some documents" true (sectionless <> []);
  List.iter
    (fun (doc : Data.Tutorial.search_document) ->
      Alcotest.(check bool)
        doc.title true
        (List.memq doc (Data.Tutorial.search_documents doc.title)))
    sectionless

let () =
  Alcotest.run "case_fold"
    [
      ( "case folding",
        [
          Alcotest.test_case "fold" `Quick test_fold;
          Alcotest.test_case "is_sub_ignore_case" `Quick test_is_sub_ignore_case;
          Alcotest.test_case "fold_split" `Quick test_fold_split;
          Alcotest.test_case "utf_8_uppercase_first" `Quick test_uppercase_first;
          Alcotest.test_case "search highlighting" `Quick test_tutorial_search;
          Alcotest.test_case "sectionless search documents" `Quick
            test_sectionless_search;
        ] );
    ]
