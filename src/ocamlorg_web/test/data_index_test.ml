(* The lookup tables built when [Data] is loaded (issue #3874) must agree with a
   linear scan of the underlying list: same element (physically), first one wins
   on duplicate keys, [None] for an absent key. *)

let absent = "no-such-key-\x00"

let check_index_with ~absent ~name ~key ~get all =
  List.iter
    (fun x ->
      let k = key x in
      let expected = List.find_opt (fun y -> key y = k) all in
      match (get k, expected) with
      | Some found, Some expected ->
          Alcotest.(check bool)
            (name ^ " finds the first match")
            true (found == expected)
      | _ -> Alcotest.failf "%s: lookup failed for an existing key" name)
    all;
  Alcotest.(check bool) (name ^ " absent key") true (get absent = None)

let check_index ~name ~key ~get all =
  check_index_with ~absent ~name ~key ~get all

let test_slug_indexes () =
  let open Data in
  check_index ~name:"Book" ~get:Book.get_by_slug
    ~key:(fun (x : Book.t) -> x.slug)
    Book.all;
  check_index ~name:"Exercise" ~get:Exercise.get_by_slug
    ~key:(fun (x : Exercise.t) -> x.slug)
    Exercise.all;
  check_index ~name:"News" ~get:News.get_by_slug
    ~key:(fun (x : News.t) -> x.slug)
    News.all;
  check_index ~name:"Success_story" ~get:Success_story.get_by_slug
    ~key:(fun (x : Success_story.t) -> x.slug)
    Success_story.all;
  check_index ~name:"Tutorial" ~get:Tutorial.get_by_slug
    ~key:(fun (x : Tutorial.t) -> x.slug)
    Tutorial.all;
  check_index ~name:"Conference" ~get:Conference.get_by_slug
    ~key:(fun (x : Conference.t) -> x.slug)
    Conference.all;
  check_index ~name:"Tool_page" ~get:Tool_page.get_by_slug
    ~key:(fun (x : Tool_page.t) -> x.slug)
    Tool_page.all;
  check_index ~name:"Backstage" ~get:Backstage.get_by_slug
    ~key:(function Backstage.Release x -> x.slug | Post x -> x.slug)
    Backstage.all;
  check_index ~name:"Changelog" ~get:Changelog.get_by_slug
    ~key:(function Changelog.Release x -> x.slug | Post x -> x.slug)
    Changelog.all

let test_other_indexes () =
  let open Data in
  check_index ~name:"Governance" ~get:Governance.get_by_id
    ~key:(fun (x : Governance.team) -> x.id)
    (Governance.teams @ Governance.working_groups);
  check_index ~name:"Is_ocaml_yet" ~get:Is_ocaml_yet.get_by_id
    ~key:(fun (x : Is_ocaml_yet.t) -> x.id)
    Is_ocaml_yet.all;
  check_index ~name:"Cookbook task" ~get:Cookbook.get_task_by_slug
    ~key:(fun (x : Cookbook.task) -> x.slug)
    Cookbook.tasks;
  check_index ~name:"Attribution" ~get:Attribution.get_by_path
    ~key:(fun (x : Attribution.t) -> x.path)
    Attribution.all;
  check_index_with ~name:"Cookbook recipe"
    ~get:(fun (task_slug, slug) -> Cookbook.get_by_slug ~task_slug slug)
    ~key:(fun (x : Cookbook.t) -> (x.task.slug, x.slug))
    ~absent:(absent, absent) Cookbook.all

(* No collection in data/ has duplicate keys, so check the first-wins rule on a
   list of our own. *)
let test_first_wins () =
  let xs = [ ("a", 1); ("b", 2); ("a", 3); ("c", 4); ("b", 5) ] in
  let tbl = Data.Lookup.index fst xs in
  let find k = Option.map snd (Hashtbl.find_opt tbl k) in
  Alcotest.(check (list (option int)))
    "first match per key, as List.find_opt"
    (List.map
       (fun k -> Option.map snd (List.find_opt (fun (k', _) -> k' = k) xs))
       [ "a"; "b"; "c"; "d" ])
    (List.map find [ "a"; "b"; "c"; "d" ]);
  Alcotest.(check int) "one binding per key" 3 (Hashtbl.length tbl)

(* The two accessors that raise [Not_found] rather than return an option. *)
let test_raising_accessors () =
  let open Data in
  Alcotest.(check string)
    "Code_example.get" "default.ml" (Code_example.get "default.ml").title;
  Alcotest.(check bool)
    "Code_example.get, absent" true
    (match Code_example.get absent with
    | _ -> false
    | exception Not_found -> true);
  Alcotest.(check string)
    "Page.get by slug" "governance" (Page.get "governance").slug;
  Alcotest.(check string)
    "Page.get by path" "carbon-footprint"
    (Page.get "/policies/carbon-footprint").slug;
  Alcotest.(check bool)
    "Page.get, absent" true
    (match Page.get absent with _ -> false | exception Not_found -> true)

let test_counts () =
  let open Data in
  Alcotest.(check int) "Book" (List.length Book.all) Book.count;
  Alcotest.(check int) "Job" (List.length Job.all) Job.count;
  Alcotest.(check int)
    "Industrial_user"
    (List.length Industrial_user.all)
    Industrial_user.count

let () =
  Alcotest.run "data_index"
    [
      ( "lookup tables",
        [
          Alcotest.test_case "slug indexes" `Quick test_slug_indexes;
          Alcotest.test_case "other indexes" `Quick test_other_indexes;
          Alcotest.test_case "first match wins" `Quick test_first_wins;
          Alcotest.test_case "raising accessors" `Quick test_raising_accessors;
          Alcotest.test_case "counts" `Quick test_counts;
        ] );
    ]
