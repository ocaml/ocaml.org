open OUnit2

module type Testable = sig
  val phi : int -> int
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "phi" >::: [
    "phi of 10" >:: (fun _ ->
      assert_equal 4 (Tested.phi 10));
    "phi of 1 (edge case)" >:: (fun _ ->
      assert_equal 1 (Tested.phi 1));
    "phi of a prime number" >:: (fun _ ->
      assert_equal 12 (Tested.phi 13));
  ]

  let v = "Euler's Totient Function Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
