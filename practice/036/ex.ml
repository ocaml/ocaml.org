open OUnit2

module type Testable = sig
  val factors : int -> (int * int) list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "factors" >::: [
    "prime factors with multiplicities of 315" >:: (fun _ ->
      assert_equal [(3, 2); (5, 1); (7, 1)] (Tested.factors 315));
    "prime factors with multiplicities of 1 (edge case)" >:: (fun _ ->
      assert_equal [] (Tested.factors 1));
    "prime factors with multiplicities of a prime number" >:: (fun _ ->
      assert_equal [(13, 1)] (Tested.factors 13));
  ]

  let v = "Prime Factors with Multiplicities Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
