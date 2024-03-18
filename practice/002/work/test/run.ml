module Test = Ex.Make(Ex.Work)

let () = OUnit2.run_test_tt_main Test.v
