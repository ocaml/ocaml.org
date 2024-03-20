
open OUnit2

module type Testable = sig
  val is_prime : int -> bool
  val all_primes : int -> int -> int list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let is_prime_tests = "is_prime" >::: [
    "test_positive_prime" >:: (fun _ ->
      assert_equal true (is_prime 2));
    "test_negative_prime" >:: (fun _ ->
      assert_equal true (is_prime (-2)));
    "test_positive_non_prime" >:: (fun _ ->
      assert_equal false (is_prime 4));
    "test_negative_non_prime" >:: (fun _ ->
      assert_equal false (is_prime (-4)));

  ]

  let all_primes_tests = "all_primes" >::: [
    "test_single_prime" >:: (fun _ ->
      assert_equal [2] (all_primes 2 2));
    "test_primes_up_to_10" >:: (fun _ ->
      assert_equal [2; 3; 5; 7] (all_primes 2 10));
    "test_large_range" >:: (fun _ ->
      assert_equal 1000 (List.length (all_primes 2 7920)));

  ]
  let v = "prime_tests" >::: [
    is_prime_tests;
    all_primes_tests;
]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl

