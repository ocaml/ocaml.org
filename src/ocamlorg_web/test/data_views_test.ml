(* Views built once in [Data] (issue #3874) must equal what the handlers used to
   compute on every request, kept here as the reference. *)

open Data

let same name expected got =
  Alcotest.(check bool)
    name true
    (List.length expected = List.length got && List.for_all2 ( == ) expected got)

let sections : (string * Tutorial.section) list =
  [
    ("GetStarted", GetStarted);
    ("Language", Language);
    ("Platform", Platform);
    ("Guides", Guides);
  ]

(* The grouping helpers, on a list with repeated keys, an element listing a key
   twice, an element with no key, and an absent key. *)
let test_group () =
  let xs =
    [ ("p", [ "a"; "b" ]); ("q", [ "b"; "b" ]); ("r", []); ("s", [ "a" ]) ]
  in
  let by_key = Lookup.group_many snd xs in
  List.iter
    (fun k -> same k (List.filter (fun x -> List.mem k (snd x)) xs) (by_key k))
    [ "a"; "b"; "c" ];
  let by_first = Lookup.group (fun (name, _) -> name.[0] < 'r') xs in
  same "group true" (List.filteri (fun i _ -> i < 2) xs) (by_first true);
  same "group false" (List.filteri (fun i _ -> i >= 2) xs) (by_first false)

let test_tutorial_sections () =
  List.iter
    (fun (name, s) ->
      let expected =
        List.filter (fun (t : Tutorial.t) -> t.section = s) Tutorial.all
      in
      same name expected (Tutorial.by_section s);
      match expected with
      | first :: _ ->
          Alcotest.(check bool)
            (name ^ " first") true
            (first == Tutorial.first_in_section s)
      | [] -> Alcotest.failf "section %s is empty" name)
    sections

let test_tutorial_links () =
  List.iter
    (fun (tutorial : Tutorial.t) ->
      let resolve slugs =
        List.filter
          (fun (t : Tutorial.t) -> List.exists (fun r -> r = t.slug) slugs)
          Tutorial.all
      in
      same
        (tutorial.slug ^ " recommended next")
        (resolve tutorial.recommended_next_tutorials)
        (Tutorial.recommended_next tutorial);
      same
        (tutorial.slug ^ " prerequisites")
        (resolve tutorial.prerequisite_tutorials)
        (Tutorial.prerequisites tutorial))
    Tutorial.all

let test_exercises_for_tutorial () =
  let slugs =
    "no-such-tutorial" :: List.map (fun (t : Tutorial.t) -> t.slug) Tutorial.all
  in
  List.iter
    (fun slug ->
      same slug
        (List.filter
           (fun (e : Exercise.t) -> List.mem slug e.tutorials)
           Exercise.all)
        (Exercise.for_tutorial slug))
    slugs;
  Alcotest.(check bool)
    "non-trivial" true
    (List.exists
       (fun (t : Tutorial.t) -> Exercise.for_tutorial t.slug <> [])
       Tutorial.all)

let test_cookbook () =
  List.iter
    (fun (task : Cookbook.task) ->
      same task.slug
        (List.filter
           (fun (x : Cookbook.t) -> String.equal task.slug x.task.slug)
           Cookbook.all)
        (Cookbook.get_by_task ~task_slug:task.slug))
    Cookbook.tasks;
  same "no-such-task" [] (Cookbook.get_by_task ~task_slug:"no-such-task");
  let rec category_slugs (cats : Cookbook.category list) =
    List.concat_map
      (fun (c : Cookbook.category) -> c.slug :: category_slugs c.subcategories)
      cats
  in
  List.iter
    (fun category_slug ->
      same category_slug
        (List.filter
           (fun (x : Cookbook.task) ->
             List.(x.category_path |> rev |> hd) = category_slug)
           Cookbook.tasks)
        (Cookbook.get_tasks_by_category ~category_slug))
    ("no-such-category" :: category_slugs Cookbook.top_categories)

let test_success_stories () =
  same "by priority"
    (List.sort
       (fun (a : Success_story.t) (b : Success_story.t) ->
         compare a.priority b.priority)
       Success_story.all)
    Success_story.by_priority

let test_events () =
  Alcotest.(check (list string))
    "types"
    (Event.all
    |> List.map (fun (e : Event.t) -> Event.string_of_event_type e.event_type)
    |> List.sort_uniq String.compare)
    Event.types;
  Alcotest.(check (list string))
    "cities"
    (Event.all
    |> List.map (fun (e : Event.t) -> e.city)
    |> List.sort_uniq String.compare)
    Event.cities;
  let reference ~today (e : Event.t) =
    e.starts.yyyy_mm_dd >= today
    || Option.is_some e.ends
       && e.ends
          |> Option.map (fun (e : Event.utc_datetime) -> e.yyyy_mm_dd)
          |> Option.get >= today
  in
  let days =
    "0000-01-01" :: "9999-12-31"
    :: List.concat_map
         (fun (e : Event.t) ->
           e.starts.yyyy_mm_dd
           :: Option.fold ~none:[]
                ~some:(fun (d : Event.utc_datetime) -> [ d.yyyy_mm_dd ])
                e.ends)
         Event.all
  in
  List.iter
    (fun today ->
      List.iter
        (fun (e : Event.t) ->
          Alcotest.(check bool)
            (e.slug ^ " upcoming on " ^ today)
            (reference ~today e)
            (Event.is_upcoming ~today e))
        Event.all)
    days

let test_learn () =
  let book_slugs = List.map (fun (b : Book.t) -> b.slug) in
  let exercise_slugs = List.map (fun (e : Exercise.t) -> e.slug) in
  let b1, b2 = Learn.beginner_books and i1, i2 = Learn.intermediate_books in
  Alcotest.(check (list string))
    "books"
    [
      "ocaml-programming-cs3110";
      "ocaml-from-the-very-beginning";
      "real-world-ocaml";
      "more-ocaml-algorithms-methods-diversions";
      "ocaml-scientific-computing";
    ]
    (book_slugs [ b1; b2; i1; i2; Learn.advanced_book ]);
  Alcotest.(check (list string))
    "exercises"
    [ "1"; "5"; "6"; "8"; "55"; "64"; "68"; "81" ]
    (exercise_slugs (Learn.beginner_exercises @ Learn.intermediate_exercises))

let () =
  Alcotest.run "data_views"
    [
      ( "same as the handlers' computations",
        [
          Alcotest.test_case "grouping helpers" `Quick test_group;
          Alcotest.test_case "tutorial sections" `Quick test_tutorial_sections;
          Alcotest.test_case "tutorial links" `Quick test_tutorial_links;
          Alcotest.test_case "exercises per tutorial" `Quick
            test_exercises_for_tutorial;
          Alcotest.test_case "cookbook" `Quick test_cookbook;
          Alcotest.test_case "success stories" `Quick test_success_stories;
          Alcotest.test_case "events" `Quick test_events;
          Alcotest.test_case "learn page" `Quick test_learn;
        ] );
    ]
