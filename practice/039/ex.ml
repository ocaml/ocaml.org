
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
  
  let rec generate_primes n acc upper_limit =
    if n > upper_limit then acc
    else generate_primes (n + 1) ((n, is_prime n) :: acc) upper_limit
  
  let primes_list = generate_primes 2 [] 7920
  
  let tests =
    "all_primes" >::: List.map (fun (p, is_prime) ->
      let prime_test = Printf.sprintf "Testing if %d is prime" p in
      prime_test >:: (fun _ -> assert_equal is_prime (List.mem p (Tested.all_primes 2 7920)))
    ) primes_list
     let v = "List_primes" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
