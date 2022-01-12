let test_case n = Alcotest.test_case n `Quick

let packages_state =
  Ocamlorg_package.state_of_package_list Graphql_test.packages

let () =
  Alcotest.run
    "ocamlorg"
    [ ( "GET /packages"
      , [ test_case "returns successfully" (fun () ->
              let req = Dream.request ~method_:`GET "/packages" in
              let res =
                Dream.test (Ocamlorg_web.Handler.packages packages_state) req
              in
              Dream.status res
              |> Dream.status_to_int
              |> Alcotest.(check int) "is 200" 200)
        ] )
    ]
