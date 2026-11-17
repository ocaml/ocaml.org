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

(* Words taken from the data itself: the first word of every 80th title and
   every 160th author, plus a two-word title prefix. *)
let data_queries =
  List.filteri (fun i _ -> i mod 80 = 0) P.all
  |> List.concat_map (fun e ->
      match String.split_on_char ' ' (P.entry_title e) with
      | w1 :: w2 :: _ -> [ w1; w1 ^ " " ^ w2 ]
      | [ w ] -> [ w ]
      | [] -> [])
  |> ( @ )
       (List.filteri (fun i _ -> i mod 160 = 0) P.all
       |> List.concat_map P.entry_authors)

let same_results q =
  let expected = reference_search q and got = P.search q in
  if
    List.length expected <> List.length got
    || not (List.for_all2 ( == ) expected got)
  then
    Alcotest.failf "query %S: %d results, reference has %d (or order differs)" q
      (List.length got) (List.length expected)

let test_fixed () =
  Alcotest.(check bool) "non-trivial" true (P.search "effects" <> []);
  List.iter same_results fixed_queries

let test_data () =
  Alcotest.(check bool) "enough queries" true (List.length data_queries > 40);
  List.iter same_results data_queries

let () =
  Alcotest.run "planet_search"
    [
      ( "same ranking as the reference",
        [
          Alcotest.test_case "fixed queries" `Quick test_fixed;
          Alcotest.test_case "queries from the data" `Quick test_data;
        ] );
    ]
