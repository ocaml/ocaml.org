(* Package search matches on fields case-folded once per state (its search
   index), not on every query. *)

module Package = Ocamlorg_package

let info ?(synopsis = "") ?(description = "") ?(tags = []) ?(authors = [])
    ?(rev_deps = 0) () =
  {
    Package.Info.synopsis;
    description;
    authors;
    maintainers = [];
    license = "";
    homepage = [];
    tags;
    dependencies = [];
    rev_deps =
      List.init rev_deps (fun i ->
          ( Package.Name.of_string (Printf.sprintf "user%d" i),
            None,
            Package.Version.of_string "1.0" ));
    depopts = [];
    conflicts = [];
    url = None;
    publication = 0.;
    flags = [];
  }

let package ?synopsis ?description ?tags ?authors ?rev_deps name =
  Package.create
    ~name:(Package.Name.of_string name)
    ~version:(Package.Version.of_string "1.0")
    (info ?synopsis ?description ?tags ?authors ?rev_deps ())

let packages =
  [
    package "http-client" ~synopsis:"An HTTP client";
    package "lwt" ~synopsis:"Promises and I/O" ~rev_deps:10;
    package "web-kit"
      ~description:"Serves pages over HTTP. Caf\xc3\xa9 friendly."
      ~tags:[ "Web" ];
    package "logs" ~authors:[ "Daniel B\xc3\xbcnzli" ];
    package "http" ~synopsis:"HTTP types";
    package "async" ~synopsis:"Promises, the other way";
  ]

(* The is_author_match the web server passes needs Data; matching the folded
   author is enough here. *)
let is_author_match author pattern =
  Ocamlorg.Import.String.contains_s author pattern

let search ?sort_by_popularity state query =
  Package.search ~is_author_match ?sort_by_popularity state query
  |> List.map (fun p -> Package.Name.to_string (Package.name p))

let test_fields () =
  let state = Package.mockup_state packages in
  let check what expected query =
    Alcotest.(check (list string))
      what expected
      (List.sort compare (search state query))
  in
  check "name, synopsis and description, ignoring case"
    [ "http"; "http-client"; "web-kit" ]
    "HTTP";
  check "tag" [ "web-kit" ] "tag:web";
  check "non-ASCII description" [ "web-kit" ] "CAF\xc3\x89";
  check "non-ASCII author" [ "logs" ] "author:B\xc3\x9cNZLI";
  check "no match" [] "zzz"

let test_ranking () =
  let state = Package.mockup_state packages in
  Alcotest.(check (list string))
    "exact name first, then name, then synopsis or description"
    [ "http"; "http-client"; "web-kit" ]
    (search state "http");
  Alcotest.(check (list string))
    "equal scores keep name order" [ "async"; "lwt" ] (search state "promises");
  Alcotest.(check (list string))
    "popularity breaks the tie" [ "lwt"; "async" ]
    (search ~sort_by_popularity:true state "promises")

(* The index is cached in the state: searching again gives the same results, and
   another state gets its own. *)
let test_index_per_state () =
  let a = Package.mockup_state packages in
  let first = search a "http" in
  Alcotest.(check (list string)) "same results again" first (search a "http");
  let b = Package.mockup_state [ package "http-other" ] in
  Alcotest.(check (list string))
    "other state" [ "http-other" ] (search b "http");
  Alcotest.(check (list string)) "first state unchanged" first (search a "http")

let () =
  Alcotest.run "search"
    [
      ( "search",
        [
          Alcotest.test_case "fields" `Quick test_fields;
          Alcotest.test_case "ranking" `Quick test_ranking;
          Alcotest.test_case "index per state" `Quick test_index_per_state;
        ] );
    ]
