let test_case n = Alcotest.test_case n `Quick

let () =
  Alcotest.run
    "ocamlorg"
    [ ( "GET /packages"
      , [ test_case "returns successfully" (fun () ->
              let req = Dream.request ~method_:`GET "/packages" in
              let res = Dream.test Ocamlorg_web.Handler.packages req in
              Dream.status res
              |> Dream.status_to_int
              |> Alcotest.(check int) "is 200" 200)
        ] )
    ]
