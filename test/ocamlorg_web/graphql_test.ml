let start_with_test () =
  Alcotest.(check bool)
    "is true"
    true
    (Ocamlorg_web.Graphql.starts_with "Oc" "oc")

let is_package_test () =
  Alcotest.(check bool)
    "is false"
    false
    (Ocamlorg_web.Graphql.is_package "Oc" "ogg")

let get_packages_result_test () =
  let packages = Ocamlorg.Package.all_packages_latest () in
  let total_packages = List.length packages in
  let offset = 0 in
  let limit = total_packages in
  let filter = None in
  let all_packages =
    Ocamlorg_web.Graphql.get_packages_result
      total_packages
      offset
      limit
      filter
      packages
  in
  let num_of_pakgs = List.length all_packages.packages in
  Alcotest.(check int) "returns 5 packages" 5 num_of_pakgs

let () =
  let open Alcotest in
  run
    "Tests"
    [ ( "Test starts_with function"
      , [ test_case "returns true" `Quick start_with_test ] )
    ; ( "Test is_package function"
      , [ test_case "returns false" `Quick is_package_test ] )
    ; ( "Test get_packages_result function"
      , [ test_case "returns false" `Quick get_packages_result_test ] )
    ]
