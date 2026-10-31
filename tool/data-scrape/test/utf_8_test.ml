let replace = Data_scrape.Utf_8.replace_invalid

let check name expected input =
  let got = replace input in
  Alcotest.(check string) name expected got;
  Alcotest.(check bool) (name ^ ", valid") true (String.is_valid_utf_8 got)

let rep = "\xef\xbf\xbd" (* U+FFFD *)

let test_valid () =
  let s = "plain ASCII, caf\xc3\xa9, \xe2\x86\x92, \xf0\x9f\x9a\x80" in
  check "valid input" s s;
  Alcotest.(check bool) "valid input is returned as is" true (replace s == s);
  check "empty" "" ""

let test_invalid () =
  check "Latin-1 byte" ("caf" ^ rep) "caf\xe9";
  check "stray continuation byte" ("a" ^ rep ^ "b") "a\x80b";
  check "truncated sequence at end" ("a" ^ rep) "a\xe2\x86";
  check "truncated sequence before ASCII" ("a" ^ rep ^ "b") "a\xe2\x86b";
  check "overlong encoding of /" (rep ^ rep) "\xc0\xaf";
  check "surrogate" (rep ^ rep ^ rep) "\xed\xa0\x80";
  check "invalid byte" (rep ^ "x") "\xffx"

let () =
  Alcotest.run "data_scrape utf_8"
    [
      ( "replace_invalid",
        [
          Alcotest.test_case "valid input" `Quick test_valid;
          Alcotest.test_case "invalid input" `Quick test_invalid;
        ] );
    ]
