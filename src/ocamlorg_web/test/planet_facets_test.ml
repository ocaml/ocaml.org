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

(* [sub] is [all] with some elements left out, in the same order (by [==]). *)
let rec is_subsequence sub all =
  match (sub, all) with
  | [], _ -> true
  | _, [] -> false
  | s :: ss, a :: aa ->
      if s == a then is_subsequence ss aa else is_subsequence sub aa

(* Checked by properties rather than against a copy of the implementation. *)
let test_of_kind () =
  let is_article = function P.BlogPost _ -> true | Video _ -> false in
  let articles = P.of_kind `Article and videos = P.of_kind `Video in
  Alcotest.(check bool) "all is Planet.all" true (P.of_kind `All == P.all);
  Alcotest.(check bool) "articles non-empty" true (articles <> []);
  Alcotest.(check bool) "videos non-empty" true (videos <> []);
  Alcotest.(check bool)
    "articles are blog posts" true
    (List.for_all is_article articles);
  Alcotest.(check bool)
    "videos are videos" true
    (List.for_all (fun e -> not (is_article e)) videos);
  Alcotest.(check bool)
    "articles keep all's order" true
    (is_subsequence articles P.all);
  Alcotest.(check bool)
    "videos keep all's order" true
    (is_subsequence videos P.all);
  Alcotest.(check int)
    "every entry is an article or a video" (List.length P.all)
    (List.length articles + List.length videos)

let test_facets_of_kind () =
  List.iter
    (fun (name, k) ->
      check_facets name
        (reference_facets (reference_of_kind k))
        (P.facets_of_kind k))
    kinds;
  List.iter
    (fun (name, k) ->
      let f = P.facets_of_kind k in
      Alcotest.(check bool)
        (name ^ " non-trivial") true
        (f.sources <> [] && f.years <> [] && f.authors <> []))
    kinds

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
