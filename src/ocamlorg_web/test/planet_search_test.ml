(* [Data.Planet.search] matches without allocating (issue #3874). It must rank
   exactly like the original implementation, kept here as the reference. *)

module P = Data.Planet

let reference_search q =
  let count_sub ~sub s =
    let ls = String.length s and lsub = String.length sub in
    if lsub = 0 then 0
    else
      let rec loop i acc =
        if i + lsub > ls then acc
        else if String.sub s i lsub = sub then loop (i + lsub) (acc + 1)
        else loop (i + 1) acc
      in
      loop 0 0
  in
  let terms =
    String.lowercase_ascii q
    |> String.map (fun c ->
        if
          (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c = '_' || c = '-'
        then c
        else ' ')
    |> String.split_on_char ' '
    |> List.filter (fun t -> String.length t >= 2)
  in
  match terms with
  | [] -> []
  | terms ->
      let docs =
        List.map
          (fun e ->
            ( e,
              [
                (String.lowercase_ascii (P.entry_title e), 3.0);
                ( String.lowercase_ascii (String.concat " " (P.entry_keywords e)),
                  2.5 );
                (String.lowercase_ascii (P.entry_description e), 1.2);
                (String.lowercase_ascii (P.entry_source e), 0.6);
                ( String.lowercase_ascii (String.concat " " (P.entry_authors e)),
                  0.6 );
              ] ))
          P.all
      in
      let n = List.length docs in
      let idf term =
        let df =
          List.fold_left
            (fun acc (_, fields) ->
              if List.exists (fun (f, _) -> count_sub ~sub:term f > 0) fields
              then acc + 1
              else acc)
            0 docs
        in
        Float.log (float_of_int (1 + n) /. float_of_int (1 + df))
      in
      let weighted_terms = List.map (fun t -> (t, idf t)) terms in
      let score fields =
        List.fold_left
          (fun acc (term, idf) ->
            List.fold_left
              (fun a (f, w) ->
                let c = count_sub ~sub:term f in
                if c = 0 then a
                else a +. (Float.log (1. +. float_of_int c) *. w *. idf))
              acc fields)
          0.0 weighted_terms
      in
      docs
      |> List.filter_map (fun (e, fields) ->
          let s = score fields in
          if s > 0.0 then Some (e, s) else None)
      |> List.stable_sort (fun (_, s1) (_, s2) -> Float.compare s2 s1)
      |> List.map fst

let fixed_queries =
  [
    "effects";
    "multicore domains";
    "OCaml";
    "Dune";
    "of the";
    "a";
    "";
    "  ";
    "mirage unikernel xen";
    "ocaml_5";
    "x-ray";
    "Café";
    "c++";
    "jane street";
    "tarides";
    "effects effects";
    "MiRaGe";
    "zzzzzz-no-such-word";
  ]

(* Words taken from the data itself: the first word of every 80th title, plus a
   two-word title prefix, every 160th author, and the keywords of every 500th
   entry (keywords and authors are the fields counted one item at a time). *)
let data_queries =
  let every n = List.filteri (fun i _ -> i mod n = 0) P.all in
  let titles =
    every 80
    |> List.concat_map (fun e ->
        match String.split_on_char ' ' (P.entry_title e) with
        | w1 :: w2 :: _ -> [ w1; w1 ^ " " ^ w2 ]
        | [ w ] -> [ w ]
        | [] -> [])
  in
  titles
  @ List.concat_map P.entry_authors (every 160)
  @ List.concat_map P.entry_keywords (every 500)

(* Index of the first position where the two lists differ, if any. *)
let rec first_difference i expected got =
  match (expected, got) with
  | [], [] -> None
  | e :: es, g :: gs when e == g -> first_difference (i + 1) es gs
  | _ -> Some i

let same_results ?(reference = reference_search) q =
  let expected = reference q and got = P.search q in
  match first_difference 0 expected got with
  | None -> ()
  | Some i ->
      let title l =
        match List.nth_opt l i with
        | Some e -> P.entry_title e
        | None -> "(end of list)"
      in
      Alcotest.failf
        "query %S: results differ at position %d: got %S, reference has %S (%d \
         results, reference has %d)"
        q i (title got) (title expected) (List.length got)
        (List.length expected)

let test_fixed () =
  Alcotest.(check bool) "non-trivial" true (P.search "effects" <> []);
  List.iter same_results fixed_queries

let test_data () =
  Alcotest.(check bool) "enough queries" true (List.length data_queries > 40);
  Alcotest.(check bool)
    "a keyword with a space" true
    (List.exists (fun q -> String.contains q ' ') data_queries);
  List.iter same_results data_queries

(* Only the first [max_query_terms] terms count: a longer query ranks like its
   prefix, and a huge one stays cheap. *)
let test_term_cap () =
  Alcotest.(check int) "cap" 16 P.max_query_terms;
  let words =
    [
      "ocaml";
      "effects";
      "dune";
      "opam";
      "mirage";
      "lwt";
      "eio";
      "domains";
      "multicore";
      "compiler";
      "types";
      "modules";
      "functors";
      "records";
      "variants";
      "arrays";
      "lists";
      "maps";
      "sets";
      "hashtables";
    ]
  in
  let first_16 = String.concat " " (List.filteri (fun i _ -> i < 16) words) in
  same_results
    ~reference:(fun _ -> reference_search first_16)
    (String.concat " " words);
  let huge = String.concat "." (List.init 3000 (fun _ -> "ab")) in
  same_results
    ~reference:(fun _ ->
      reference_search (String.concat " " (List.init 16 (fun _ -> "ab"))))
    huge

let () =
  Alcotest.run "planet_search"
    [
      ( "same ranking as the reference",
        [
          Alcotest.test_case "fixed queries" `Quick test_fixed;
          Alcotest.test_case "queries from the data" `Quick test_data;
          Alcotest.test_case "at most max_query_terms terms" `Quick
            test_term_cap;
        ] );
    ]
