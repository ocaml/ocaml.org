open OUnit2

module type Testable = sig
  val goldbach : int -> int * int
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "Goldbach's conjecture" >::: [
    "goldbach of 4" >:: (fun _ ->
      assert_equal (2, 2) (Tested.goldbach 4));
    "goldbach of 28" >:: (fun _ ->
      assert_equal (5, 23) (Tested.goldbach 28));
  ]

  let v = "Tests for Goldbach's Conjecture" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
