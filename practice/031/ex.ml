open OUnit2

module type Testable = sig
  val is_prime : int -> bool
end

module Make(Tested: Testable) : sig val v : test end = struct
  let rec flag_prime n = function
    | [] -> []
    | p :: u ->
      if n = p then
        (p, true) :: flag_prime (n + 1) u
      else
        (n, false) :: flag_prime (n + 1) (p :: u)

  let primes = [2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71; 73; 79; 83; 89; 97]

  let tests =
  "flag_prime" >::: List.map (fun n ->
    let is_prime = Tested.is_prime n in
    let test_name = Printf.sprintf "Testing if %d is prime" n in
    test_name >:: (fun _ -> assert_equal is_prime (Tested.is_prime n))
  ) primes

  let v = "is_prime Tests" >::: [
    tests
  ]

  let _ = flag_prime 0 primes
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
