module Package = Ocamlorg.Package

let dependencies =
  [ Package.Name.of_string "0install", Some "3.2"
  ; Package.Name.of_string "ocaml", None
  ; Package.Name.of_string "alcotest", Some "1.0.2"
  ; Package.Name.of_string "alcotest", Some "4.7"
  ; Package.Name.of_string "tnstall", None
  ; Package.Name.of_string "merlin", Some "2.8"
  ]

let packages : Package.t list =
  [ Package.create
      ~name:(Package.Name.of_string "0install")
      ~version:(Package.Version.of_string "2.1.0")
      { Package.Info.synopsis = "Decentralised installation system"
      ; description = ""
      ; authors = []
      ; maintainers = []
      ; license = "ISC"
      ; homepage = []
      ; tags = []
      ; dependencies = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ; Package.create
      ~name:(Package.Name.of_string "0install-gtk")
      ~version:(Package.Version.of_string "2.1.0")
      { Package.Info.synopsis = "Decentralised installation system - GTK UI"
      ; description = ""
      ; authors = []
      ; maintainers = []
      ; license = "ISC"
      ; homepage = []
      ; tags = []
      ; dependencies = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ; Package.create
      ~name:(Package.Name.of_string "abt")
      ~version:(Package.Version.of_string "2.1.0")
      { Package.Info.synopsis = "Package dependency solve"
      ; description = ""
      ; authors = []
      ; maintainers = []
      ; license = "ISC"
      ; homepage = []
      ; tags = []
      ; dependencies = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ; Package.create
      ~name:(Package.Name.of_string "ocaml")
      ~version:(Package.Version.of_string "2.1.0")
      { Package.Info.synopsis = "OCaml port of CMU's abstract binding trees"
      ; description = ""
      ; authors = []
      ; maintainers = []
      ; license = "ISC"
      ; homepage = []
      ; tags = []
      ; dependencies = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ; Package.create
      ~name:(Package.Name.of_string "absolute")
      ~version:(Package.Version.of_string "2.1.0")
      { Package.Info.synopsis =
          "Interactive theorem prover based on lambda-tree syntax"
      ; description = ""
      ; authors = []
      ; maintainers = []
      ; license = "ISC"
      ; homepage = []
      ; tags = []
      ; dependencies = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ]

let start_with_test str1 str2 cond () =
  Alcotest.(check bool)
    "is true or false"
    cond
    (Ocamlorg_web.Graphql.starts_with str1 str2)

let is_package_test name1 name2 cond () =
  Alcotest.(check bool)
    "is false"
    cond
    (Ocamlorg_web.Graphql.is_package name1 name2)

let get_packages_result_test () =
  let total_packages = List.length packages in
  let offset = 0 in
  let limit = 3 in
  let startswith = None in
  let all_packages =
    Ocamlorg_web.Graphql.get_packages_result
      total_packages
      offset
      limit
      startswith
      packages
  in
  let num_of_pakgs = List.length all_packages.packages in
  Alcotest.(check int) "returns 3 packages" limit num_of_pakgs

let get_info_test () =
  let deps = Ocamlorg_web.Graphql.get_info dependencies in
  let num_of_deps = List.length deps in
  Alcotest.(check int) "returns 6 dependencies" 6 num_of_deps

let get_single_package_test name () =
  let pkg = Ocamlorg_web.Graphql.get_single_package packages name in
  match pkg with
  | None ->
    Alcotest.fail "Expected a package"
  | Some package ->
    Alcotest.(check string)
      "Same name"
      name
      (Package.Name.to_string (Package.name package))

let () =
  Alcotest.run
    "ocamlorg"
    [ ( "test that starts_with function compares two similar strings"
      , [ Alcotest.test_case
            "and returns true"
            `Quick
            (start_with_test "OC" "oc" true)
        ] )
    ; ( "test that starts_with function compares two different strings"
      , [ Alcotest.test_case
            "and returns false"
            `Quick
            (start_with_test "gv" "Bt" false)
        ] )
    ; ( "test that is_package function compares the same names"
      , [ Alcotest.test_case
            "and returns true"
            `Quick
            (is_package_test "ocaml" "ocaml" true)
        ] )
    ; ( "test that is_package function compares two different names"
      , [ Alcotest.test_case
            "and returns false"
            `Quick
            (is_package_test "ocaml" "merlin" false)
        ] )
    ; ( "test get_packages_result function with limit to 3 option"
      , [ Alcotest.test_case
            "and it returns 3 packages"
            `Quick
            get_packages_result_test
        ] )
    ; ( "test that get_info function works"
      , [ Alcotest.test_case
            "and returns all 6 dependencies"
            `Quick
            get_info_test
        ] )
    ; ( "test to get a single package by name that exist"
      , [ Alcotest.test_case
            "returns true"
            `Quick
            (get_single_package_test "ocaml")
        ] )
    ]
