open OUnit2

module type Testable = sig
  val factors : int -> int list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "factors" >::: [
    "prime factors of 315" >:: (fun _ ->
      assert_equal [3; 3; 5; 7] (Tested.factors 315));
    "prime factors of 1 (edge case)" >:: (fun _ ->
      assert_equal [] (Tested.factors 1));
    "prime factors of a prime number" >:: (fun _ ->
      assert_equal [13] (Tested.factors 13));
  ]

  let v = "Prime Factors Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
