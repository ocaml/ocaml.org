let test_parse_date_from_slug =
  let test ~name ~expected s =
    ( name,
      `Quick,
      fun () ->
        let got = Ood_gen.Slug.parse_slug s in
        Alcotest.(check (option (pair string (option string))))
          __LOC__ expected got )
  in
  [
    test ~name:"ok" "2020-03-02-something.md"
      ~expected:(Some ("2020-03-02", None));
    test ~name:"no date" "something.md" ~expected:None;
    test ~name:"day not padded correctly" "2021-1-2-title.md"
      ~expected:(Some ("2021-01-02", None));
    test ~name:"ok with project-version" "2025-01-31-project-1.2.3"
      ~expected:(Some ("2025-01-31", Some "1.2.3"));
    test ~name:"ok with project.version" "2025-01-31-project.1.2.3"
      ~expected:(Some ("2025-01-31", Some "1.2.3"));
    test ~name:"ok with project.version-suffix"
      "2025-01-31-project.1.2.3-something"
      ~expected:(Some ("2025-01-31", Some "1.2.3-something"));
  ]

let tests = [ ("parse_date_from_slug", test_parse_date_from_slug) ]
let () = Alcotest.run __FILE__ tests
