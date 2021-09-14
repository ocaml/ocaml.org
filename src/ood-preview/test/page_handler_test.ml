(** Test suite for the Utils module. *)

let test_case n = Alcotest.test_case n `Quick

let () =
  Alcotest.run
    "ood-preview"
    [ ( "GET /"
      , [ test_case "returns successfully" (fun () ->
              let req = Dream.request ~method_:`GET "/" in
              let res = Dream.test Ood_preview.Handlers.Page.index req in
              Dream.status res
              |> Dream.status_to_int
              |> Alcotest.(check int) "is 200" 200)
        ] )
    ]
