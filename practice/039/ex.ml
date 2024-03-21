
open OUnit2

module type Testable = sig
   val all_primes : int -> int -> int list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested
  let tests = "all_primes" >::: [
    "test_single_prime" >:: (fun _ ->
      assert_equal [2] (all_primes 2 2));
    "test_primes_up_to_10" >:: (fun _ ->
      assert_equal [2; 3; 5; 7] (all_primes 2 10));
    "test_large_range" >:: (fun _ ->
      assert_equal 1000 (List.length (all_primes 2 7920)));

  ]

  let v = "List Primes" >::: [
    tests
]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl