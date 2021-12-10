module Ocamlorg_web = Ocamlorg_web
module Package = Ocamlorg_package

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
      ; dependencies
      ; rev_deps = []
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
      ; dependencies
      ; rev_deps = []
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
      ; dependencies
      ; rev_deps = []
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
      ; rev_deps = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ; Package.create
      ~name:(Package.Name.of_string "merlin")
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
      ; rev_deps = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ; Package.create
      ~name:(Package.Name.of_string "merlin")
      ~version:(Package.Version.of_string "3.5.0")
      { Package.Info.synopsis =
          "Interactive theorem prover based on lambda-tree syntax"
      ; description = ""
      ; authors = []
      ; maintainers = []
      ; license = "ISC"
      ; homepage = []
      ; tags = []
      ; dependencies = []
      ; rev_deps = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ; Package.create
      ~name:(Package.Name.of_string "merlin")
      ~version:(Package.Version.of_string "1.1.0")
      { Package.Info.synopsis =
          "Interactive theorem prover based on lambda-tree syntax"
      ; description = ""
      ; authors = []
      ; maintainers = []
      ; license = "ISC"
      ; homepage = []
      ; tags = []
      ; dependencies = []
      ; rev_deps = []
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ]

let get_info_test () =
  let deps = Ocamlorg_web.Graphql.get_info dependencies in
  let num_of_deps_returned = List.length deps in
  Alcotest.(check int)
    "returns 6 dependencies"
    (List.length dependencies)
    num_of_deps_returned

let is_in_range_test current_version from_version upto_version cond () =
  let is_in_range =
    Ocamlorg_web.Graphql.is_in_range current_version from_version upto_version
  in
  Alcotest.(check bool) "returns true or false" cond is_in_range

let is_valid_params_test limit offset cond () =
  let total_packages = List.length packages in
  let is_valid_params =
    Ocamlorg_web.Graphql.is_valid_params limit offset total_packages
  in
  let is_valid_params =
    match is_valid_params with
    | Wrong_limit ->
      "wrong_limit"
    | Wrong_offset ->
      "wrong_offset"
    | _ ->
      "valid_params"
  in
  Alcotest.(check string) ("returns " ^ cond) cond is_valid_params

let packages_list_test ?contains offset limit total_length () =
  let state = Package.state_of_package_list packages in
  let all_packages =
    Ocamlorg_web.Graphql.packages_list ?contains offset limit packages state
  in
  let num_of_packages_returned = List.length all_packages in
  Alcotest.(check int)
    "returns all matched packages"
    total_length
    num_of_packages_returned

let all_packages_result_test ?contains offset limit () =
  let state = Package.state_of_package_list packages in
  let all_packages =
    Ocamlorg_web.Graphql.all_packages_result ?contains offset limit state
  in
  let num_of_packages_returned =
    match all_packages with
    | Error _ ->
      0
    | Ok all_packages ->
      List.length all_packages.packages
  in
  Alcotest.(check int) "returns all the packages" 5 num_of_packages_returned

let package_result_test name version expect () =
  let state = Package.state_of_package_list packages in
  let package = Ocamlorg_web.Graphql.package_result name version state in
  let result =
    match package with
    | Error _ ->
      "Not Found"
    | Ok package ->
      package |> Package.name |> Package.Name.to_string
  in
  Alcotest.(check string) "same package" expect result

let package_versions_result_test name from upto total_packages () =
  let state = Package.state_of_package_list packages in
  let package_versions =
    Ocamlorg_web.Graphql.package_versions_result name from upto state
  in
  let num_of_packages_returned =
    match package_versions with
    | Error _ ->
      0
    | Ok package_versions ->
      List.length package_versions.packages
  in
  Alcotest.(check int)
    "returns all package versions"
    total_packages
    num_of_packages_returned

let state_test () =
  let state = Package.state_of_package_list packages in
  let pkg =
    Package.search_package state "abt"
    |> List.map Package.name
    |> List.map Package.Name.to_string
  in
  let expect = [ "abt" ] in
  Alcotest.(check (list string)) "same package" expect pkg

let () =
  Alcotest.run
    "ocamlorg"
    [ ( "get_info_test"
      , [ Alcotest.test_case
            "returns the number of dependencies found"
            `Quick
            get_info_test
        ] )
    ; ( "is_in_range_test_within_range"
      , [ Alcotest.test_case
            "returns true"
            `Quick
            (is_in_range_test
               (Package.Version.of_string "3.12.0")
               (Some (Package.Version.of_string "2.0.0"))
               (Some (Package.Version.of_string "5.9.2"))
               true)
        ] )
    ; ( "is_in_range_test_outside_range"
      , [ Alcotest.test_case
            "returns false"
            `Quick
            (is_in_range_test
               (Package.Version.of_string "3.12.0")
               None
               (Some (Package.Version.of_string "2.97.2"))
               false)
        ] )
    ; ( "is_valid_params_test_valid_params"
      , [ Alcotest.test_case
            "returns valid_params"
            `Quick
            (is_valid_params_test (List.length packages) 0 "valid_params")
        ] )
    ; ( "is_valid_params_test_wrong_limit"
      , [ Alcotest.test_case
            "returns wrong_limit"
            `Quick
            (is_valid_params_test 0 0 "wrong_limit")
        ] )
    ; ( "is_valid_params_test_wrong_offset"
      , [ Alcotest.test_case
            "returns wrong_offset"
            `Quick
            (is_valid_params_test (List.length packages) 200 "wrong_offset")
        ] )
    ; ( "packages_list_test_no_contains"
      , [ Alcotest.test_case
            "returns all packages"
            `Quick
            (packages_list_test 0 (List.length packages) (List.length packages))
        ] )
    ; ( "packages_list_test_with_contains"
      , [ Alcotest.test_case
            "returns the number of packages that has 'abt' in its name"
            `Quick
            (packages_list_test ~contains:"abt" 0 (List.length packages) 1)
        ] )
    ; ( "all_packages_result_test"
      , [ Alcotest.test_case
            "returns the number of packages found"
            `Quick
            (all_packages_result_test 0 None)
        ] )
    ; ( "package_result_test_with_valid_name"
      , [ Alcotest.test_case
            "returns package name"
            `Quick
            (package_result_test "ocaml" None "ocaml")
        ] )
    ; ( "package_result_test_with_invalid_name"
      , [ Alcotest.test_case
            "returns error message"
            `Quick
            (package_result_test "ocdfggaml" None "Not Found")
        ] )
    ; ( "package_result_test_with_valid_name_and_version"
      , [ Alcotest.test_case
            "returns the package name"
            `Quick
            (package_result_test "0install-gtk" (Some "2.1.0") "0install-gtk")
        ] )
    ; ( "package_versions_result_test"
      , [ Alcotest.test_case
            "returns number of package versions found"
            `Quick
            (package_versions_result_test
               "merlin"
               (Some "1.0.0")
               (Some "4.1.0")
               3)
        ] )
    ; ( "state_test"
      , [ Alcotest.test_case "returns same package from state" `Quick state_test
        ] )
    ]
