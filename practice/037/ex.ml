open OUnit2

module type Testable = sig
  val phi_improved : int -> int
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "phi_improved" >::: [
    "phi_improved of 10" >:: (fun _ ->
      assert_equal 4 (Tested.phi_improved 10));
    "phi_improved of 13" >:: (fun _ ->
      assert_equal 12 (Tested.phi_improved 13));
    "phi_improved of 1 (edge case)" >:: (fun _ ->
      assert_equal 1 (Tested.phi_improved 1));
  ]

  let v = "Improved Euler's Totient Function Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
