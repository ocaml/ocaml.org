module Ocamlorg_web = Ocamlorg_web
module Package = Ocamlorg.Package

type packages_success =
  { total_packages : int
  ; packages : Package.t list
  }

type packages_result = (packages_success, [ `Msg of string ]) result

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
      ; depopts = []
      ; conflicts = []
      ; url = None
      }
  ]

let get_info_test () =
  let deps = Ocamlorg_web.Graphql.get_info dependencies in
  let num_of_deps_returned = List.length deps in
  Alcotest.(check int) "returns 6 dependencies" 6 num_of_deps_returned

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
  Alcotest.(check string) ("returns " ^ cond) cond is_valid_params

let packages_list_test contains offset limit total_length () =
  let state = Package.state_of_package_list packages in
  let all_packages =
    Ocamlorg_web.Graphql.packages_list contains offset limit packages state
  in
  let num_of_packages_returned = List.length all_packages in
  Alcotest.(check int)
    "returns all the packages"
    total_length
    num_of_packages_returned

let all_packages_result_test contains offset limit total_packages () =
  let state = Package.state_of_package_list packages in
  let all_packages =
    Ocamlorg_web.Graphql.all_packages_result
      contains
      offset
      limit
      packages
      state
  in
  let num_of_packages_returned =
    match all_packages with
    | Error _ ->
      0
    | Ok all_packages ->
      List.length all_packages.packages
  in
  Alcotest.(check int)
    "returns all the packages"
    total_packages
    num_of_packages_returned

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
    [ ( "test that get_info function returns all the dependencies"
      , [ Alcotest.test_case
            "and returns all 6 dependencies"
            `Quick
            get_info_test
        ] )
    ; ( "test that is_in_range function checks if a current version is within \
         the start and last version range specified"
      , [ Alcotest.test_case
            "and returns true"
            `Quick
            (is_in_range_test
               (Package.Version.of_string "3.12.0")
               (Package.Version.of_string "2.0.0")
               (Package.Version.of_string "5.9.2")
               true)
        ] )
    ; ( "test that is_in_range function checks if a current version is outside \
         the start and last version range specified"
      , [ Alcotest.test_case
            "and returns false"
            `Quick
            (is_in_range_test
               (Package.Version.of_string "3.12.0")
               (Package.Version.of_string "10.0.0")
               (Package.Version.of_string "2.97.2")
               false)
        ] )
    ; ( "test that is_valid_params function takes a limit, offset and \
         total_packages and checks that limit or offset are both greater than \
         or equal to 0 and less than or equal to total_packages"
      , [ Alcotest.test_case
            "and returns true"
            `Quick
            (is_valid_params_test (List.length packages) 0 "true")
        ] )
    ; ( "test that is_valid_params function takes a limit, offset and \
         total_packages and confirms that limit is wrong because it is greater \
         than the total_packages"
      , [ Alcotest.test_case
            "and returns wrong_limit"
            `Quick
            (is_valid_params_test 100 0 "wrong_limit")
        ] )
    ; ( "test that is_valid_params function takes a limit, offset and \
         total_packages and confirms that offset is wrong because it is \
         greater than the total_packages"
      , [ Alcotest.test_case
            "and returns wrong_offset"
            `Quick
            (is_valid_params_test (List.length packages) 200 "wrong_offset")
        ] )
    ; ( "test that packages_list function returns all packages if contains \
         parameter is not specified and offset set to 0"
      , [ Alcotest.test_case
            "and returns true"
            `Quick
            (packages_list_test
               None
               0
               (List.length packages)
               (List.length packages))
        ] )
    ; ( "test that packages_list function returns all packages that has 'abt'\n\
        \         as part of its name"
      , [ Alcotest.test_case
            "and returns true"
            `Quick
            (packages_list_test (Some "abt") 0 (List.length packages) 1)
        ] )
    ; ( "test that all_packages_result function returns all packages"
      , [ Alcotest.test_case
            "and returns length of packages"
            `Quick
            (all_packages_result_test None 0 None (List.length packages))
        ] )
    ; ( "test that package_result function returns the latest version of \
         package with name ocaml"
      , [ Alcotest.test_case
            "and returns length of packages"
            `Quick
            (package_result_test "ocaml" None "ocaml")
        ] )
    ; ( "test that package_result function returns an error for an invalid \
         package name"
      , [ Alcotest.test_case
            "and returns length of packages"
            `Quick
            (package_result_test "ocdfggaml" None "Not Found")
        ] )
    ; ( "test that package_result function returns the package with name \
         0install-gtk and version 2.1.0"
      , [ Alcotest.test_case
            "and returns length of packages"
            `Quick
            (package_result_test "0install-gtk" (Some "2.1.0") "0install-gtk")
        ] )
    ; ( "test that package_versions_result function returns all versions of \
         package with name merlin"
      , [ Alcotest.test_case
            "and returns length of packages"
            `Quick
            (package_versions_result_test
               "merlin"
               (Some "1.0.0")
               (Some "4.1.0")
               3)
        ] )
    ; ( "state test"
      , [ Alcotest.test_case "same package from state" `Quick state_test ] )
    ]
