(* Search snippets must never cut a UTF-8 character in half (issue #3910). *)

module S = Ocamlorg.Import.String

(* Characters of every UTF-8 length: 1, 2, 3 and 4 bytes. *)
let chars = [ "a"; "\xc3\xa9"; "\xe2\x86\x92"; "\xf0\x9f\x9a\x80" ]
let sample = String.concat "" (List.concat (List.init 3 (fun _ -> chars)))

let check_valid what s =
  if not (String.is_valid_utf_8 s) then
    Alcotest.failf "%s: invalid UTF-8 %S" what s

let test_prefix () =
  let len = String.length sample in
  for n = -1 to len + 1 do
    let p = S.utf_8_prefix sample n in
    let what = Printf.sprintf "utf_8_prefix %d" n in
    check_valid what p;
    Alcotest.(check string) what p (String.sub sample 0 (String.length p));
    Alcotest.(check bool) (what ^ " <= n") true (String.length p <= max n 0);
    if n >= 0 && n <= len then
      Alcotest.(check bool) (what ^ " >= n - 3") true (String.length p >= n - 3)
  done

let test_suffix () =
  let len = String.length sample in
  for n = -1 to len + 1 do
    let s = S.utf_8_suffix sample n in
    let what = Printf.sprintf "utf_8_suffix %d" n in
    let ls = String.length s in
    check_valid what s;
    Alcotest.(check string) what s (String.sub sample (len - ls) ls);
    Alcotest.(check bool) (what ^ " <= n") true (ls <= max n 0);
    if n >= 0 && n <= len then
      Alcotest.(check bool) (what ^ " >= n - 3") true (ls >= n - 3)
  done

(* Multi-byte filler, longer than the 200-byte snippet budget. *)
let filler = List.concat (List.init 25 (fun _ -> chars))
let filler_length = List.length filler

let rotate k =
  let k = k mod filler_length in
  String.concat ""
    (List.filteri (fun i _ -> i >= k) filler
    @ List.filteri (fun i _ -> i < k) filler)

(* For 1 to 5 occurrences of the search term (one per match arm of
   [display_surrounding_text]) and every rotation of the filler, the snippet is
   valid UTF-8. *)
let test_snippet () =
  for occurrences = 1 to 5 do
    for k = 0 to filler_length - 1 do
      (* The filler repeats every 10 bytes, so ASCII padding of varying length
         at both ends makes the cuts land at every offset within a character. *)
      let segment i =
        String.make ((k + i) mod 10) 'b'
        ^ rotate (k + (7 * i))
        ^ String.make (((3 * k) + i) mod 10) 'b'
      in
      let segments = List.init (occurrences + 1) segment in
      let text = String.concat "x" segments in
      let snippet =
        Ocamlorg_frontend.Search.display_surrounding_text ~search:"x" text
      in
      check_valid
        (Printf.sprintf "snippet, %d occurrences, rotation %d" occurrences k)
        snippet
    done
  done

let () =
  Alcotest.run "utf_8_snippet"
    [
      ( "helpers",
        [
          Alcotest.test_case "utf_8_prefix" `Quick test_prefix;
          Alcotest.test_case "utf_8_suffix" `Quick test_suffix;
        ] );
      ("search", [ Alcotest.test_case "snippet" `Quick test_snippet ]);
    ]
