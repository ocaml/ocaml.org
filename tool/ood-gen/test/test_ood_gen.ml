let test_parse_date_from_slug =
  let test ~name ~expected s =
    ( name,
      `Quick,
      fun () ->
        let got = Ood_gen.Changelog.parse_date_from_slug s in
        Alcotest.check (Alcotest.option Alcotest.string) __LOC__ expected got )
  in
  [
    test ~name:"ok" "2020-03-02-something.md" ~expected:(Some "2020-03-02");
    test ~name:"no date" "something.md" ~expected:None;
  ]

let tests = [ ("parse_date_from_slug", test_parse_date_from_slug) ]
let () = Alcotest.run __FILE__ tests
