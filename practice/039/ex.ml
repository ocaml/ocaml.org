
open OUnit2

module type Testable = sig
   val all_primes : int -> int -> int list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let is_prime n =
    let n = max n (-n) in
    let rec is_not_divisor d =
      d * d > n || (n mod d <> 0 && is_not_divisor (d + 1))
    in
      is_not_divisor 2

  let rec prime_bool_list start_num end_num =
    let rec primes list n =
      if n > end_num then list else
        primes ((n, is_prime n) :: list) (n + 1)
    in
    primes [] start_num
     let v = "List_primes" >::: [
    "all_primes" >:::List.map (fun (prime_bool_list) -> (fun _ ->
      assert_equal 1000 (List.length (prime_bool_list( all_primes 2 7920)))));

  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
