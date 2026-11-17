(* Planet facet counts (issue #3874): [Data.Planet.facets], and the counts
   computed once per kind, must equal what the handler used to compute on every
   request, kept here as the reference. *)

module P = Data.Planet

let reference_tally key_fn entries =
  let tbl = Hashtbl.create 256 in
  List.iter
    (fun e ->
      List.iter
        (fun v ->
          if v <> "" then
            Hashtbl.replace tbl v
              (1 + Option.value ~default:0 (Hashtbl.find_opt tbl v)))
        (key_fn e))
    entries;
  Hashtbl.fold (fun v c acc -> (v, c) :: acc) tbl []

let reference_by_count =
  List.sort (fun (v1, c1) (v2, c2) ->
      if c1 <> c2 then compare c2 c1 else compare v1 v2)

let reference_facets entries : P.facets =
  {
    sources =
      reference_by_count
        (reference_tally (fun e -> [ P.entry_source e ]) entries);
    keywords = reference_by_count (reference_tally P.entry_keywords entries);
    years =
      List.sort
        (fun (a, _) (b, _) -> compare b a)
        (reference_tally (fun e -> [ P.entry_year e ]) entries);
    authors = reference_by_count (reference_tally P.entry_authors entries);
  }

let reference_of_kind = function
  | `All -> P.all
  | `Article ->
      List.filter (function P.BlogPost _ -> true | Video _ -> false) P.all
  | `Video ->
      List.filter (function P.Video _ -> true | BlogPost _ -> false) P.all

let check_facets name expected (got : P.facets) =
  let pairs = Alcotest.(list (pair string int)) in
  Alcotest.check pairs (name ^ " sources") expected.P.sources got.sources;
  Alcotest.check pairs (name ^ " keywords") expected.keywords got.keywords;
  Alcotest.check pairs (name ^ " years") expected.years got.years;
  Alcotest.check pairs (name ^ " authors") expected.authors got.authors

let kinds = [ ("all", `All); ("articles", `Article); ("videos", `Video) ]

let test_of_kind () =
  List.iter
    (fun (name, k) ->
      let expected = reference_of_kind k and got = P.of_kind k in
      Alcotest.(check bool)
        (name ^ " same entries, same order")
        true
        (List.length expected = List.length got
        && List.for_all2 ( == ) expected got))
    kinds

let test_facets_of_kind () =
  List.iter
    (fun (name, k) ->
      check_facets name
        (reference_facets (reference_of_kind k))
        (P.facets_of_kind k))
    kinds;
  Alcotest.(check bool)
    "non-trivial" true
    ((P.facets_of_kind `All).authors <> [])

let test_facets_of_search () =
  List.iter
    (fun q ->
      let results = P.search q in
      check_facets q (reference_facets results) (P.facets results))
    [ "effects"; "multicore domains"; "ocaml"; "zzzzzz-no-such-word" ]

let () =
  Alcotest.run "planet_facets"
    [
      ( "same counts as the reference",
        [
          Alcotest.test_case "of_kind" `Quick test_of_kind;
          Alcotest.test_case "facets_of_kind" `Quick test_facets_of_kind;
          Alcotest.test_case "facets of search results" `Quick
            test_facets_of_search;
        ] );
    ]
