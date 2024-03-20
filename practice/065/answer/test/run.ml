module Test = Ex.Make(Ex.Answer)

let () = OUnit2.run_test_tt_main Test.v
