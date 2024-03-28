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
  "flag_prime" >::: List.map (fun (n, p) ->
    let test_name = Printf.sprintf "Testing if %d is prime" n in
     test_name >:: (fun _ -> assert_equal p (Tested.is_prime n))
  ) (flag_prime 0 primes)

  let v = "is_prime Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
