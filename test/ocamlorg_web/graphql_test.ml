module Ocamlorg_web = Ocamlorg_web
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

let packages_list_test contains offset limit () =
  let state = Package.state_of_package_list packages in
  let all_packages =
    Ocamlorg_web.Graphql.packages_list contains offset limit packages state
  in
  let num_of_packages_returned = List.length all_packages in
  Alcotest.(check int)
    "returns all the packages"
    (List.length packages)
    num_of_packages_returned

(* let all_packages_result_test contains offset limit () = let state =
   Package.state_of_package_list packages in let all_packages =
   Ocamlorg_web.Graphql.all_packages_result contains offset limit packages state
   in match all_packages with | Error _ -> [] | _ -> let
   num_of_packages_returned = List.length all_packages.packages in
   Alcotest.(check int) "returns all the packages" (List.length packages)
   num_of_packages_returned *)

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
            (is_in_range_test "3.12.0" "2.0.0" "5.9.2" true)
        ] )
    ; ( "test that is_in_range function checks if a current version is outside \
         the start and last version range specified"
      , [ Alcotest.test_case
            "and returns false"
            `Quick
            (is_in_range_test "3.12.0" "10.0.0" "2.97.2" false)
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
            (packages_list_test None 0 (List.length packages))
        ] )
      (* ; ( "test that all_packages_result function returns all packages" , [
         Alcotest.test_case "and returns false" `Quick (all_packages_result_test
         "ocaml" "merlin" false) ] ) *)
    ; ( "state test"
      , [ Alcotest.test_case "same package from state" `Quick state_test ] )
    ]
