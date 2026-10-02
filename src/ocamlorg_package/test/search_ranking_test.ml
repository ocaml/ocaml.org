module Package = Ocamlorg_package

let info ?(synopsis = "") ?(description = "") ?(tags = []) ?(authors = [])
    ?(rev_deps = []) () =
  {
    Package.Info.synopsis;
    description;
    authors;
    maintainers = [];
    license = "";
    homepage = [];
    tags;
    dependencies = [];
    rev_deps;
    depopts = [];
    conflicts = [];
    url = None;
    publication = 0.;
    flags = [];
  }

let package ?synopsis ?description ?tags ?authors ?rev_deps name =
  Package.create
    ~name:(Package.Name.of_string name)
    ~version:(Package.Version.of_string "1.0.0")
    (info ?synopsis ?description ?tags ?authors ?rev_deps ())

(* No author matching exercised by these name/synopsis queries. *)
let is_author_match _ _ = false

let big_rev_deps n =
  List.init n (fun i ->
      ( Package.Name.of_string (Printf.sprintf "dep%d" i),
        None,
        Package.Version.of_string "1.0.0" ))

(* Realistic corpus: "foo" is the known item; distractors match "foo" only
   weakly (substring / synopsis), and the popular package does NOT match the
   query (so it is filtered out of the matched set, as a real popular-but-
   unrelated package would be). This is the common navigational case. *)
let corpus_realistic () =
  Package.mockup_state
    [
      package "foo" ~synopsis:"a small widget library";
      package "foobar" ~synopsis:"compatible helpers" ~tags:[ "foo" ];
      package "popular" ~synopsis:"an unrelated but widely used library"
        ~rev_deps:(big_rev_deps 500);
      package "unrelated" ~synopsis:"nothing to see here";
    ]

(* Adversarial corpus: the popular package ALSO matches "foo" heavily and
   carries 500 rev_deps, so the popularity prior genuinely fights the exact-name
   match. Used to show the exact-name bonus is load-bearing. *)
let corpus_adversarial () =
  Package.mockup_state
    [
      package "foo" ~synopsis:"a small widget library";
      package "popular" ~synopsis:"built on foo, foo everywhere, foo foo foo"
        ~description:"foo foo foo foo foo" ~rev_deps:(big_rev_deps 500);
    ]

let top_name ?(sort_by_popularity = false) ~ranking state query =
  match
    Package.search ~is_author_match ~sort_by_popularity ~ranking state query
  with
  | top :: _ -> Some (Package.Name.to_string (Package.name top))
  | [] -> None

let test_case name fn = Alcotest.test_case name `Quick fn

(* Core guard: the exact-name package ranks #1 on a realistic corpus under the
   production [Default] ranker (both with and without the popularity prior, the
   latter being what the handler uses) and under the [Bm25f] arm. *)
let test_known_item_ranks_first () =
  let state = corpus_realistic () in
  let bm25f = Package.Bm25f Package.default_bm25f_params in
  Alcotest.(check (option string))
    "Default (textual): foo ranks first" (Some "foo")
    (top_name ~ranking:Package.Default state "foo");
  Alcotest.(check (option string))
    "Default (popularity): foo ranks first" (Some "foo")
    (top_name ~sort_by_popularity:true ~ranking:Package.Default state "foo");
  Alcotest.(check (option string))
    "Bm25f: foo ranks first" (Some "foo")
    (top_name ~ranking:bm25f state "foo")

(* The exact-name bonus is load-bearing, and makes Bm25f *more* robust than the
   current popularity-weighted ranker: against a hugely-popular package that
   also matches the query, Bm25f (bonus on) still ranks the exact match #1,
   whereas with the bonus off it does not. *)
let test_exact_bonus_is_load_bearing () =
  let state = corpus_adversarial () in
  let on = Package.default_bm25f_params in
  let off = { Package.default_bm25f_params with exact_bonus = false } in
  Alcotest.(check (option string))
    "Bm25f (bonus on): foo still #1 vs a 500-revdep matcher" (Some "foo")
    (top_name ~ranking:(Package.Bm25f on) state "foo");
  Alcotest.(check bool)
    "Bm25f (bonus off): foo no longer guaranteed #1" false
    (top_name ~ranking:(Package.Bm25f off) state "foo" = Some "foo")

let () =
  Alcotest.run "search ranking"
    [
      ( "known-item guard",
        [
          test_case "exact-name package ranks first (Default + Bm25f)"
            test_known_item_ranks_first;
          test_case "exact-name bonus is load-bearing"
            test_exact_bonus_is_load_bearing;
        ] );
    ]
