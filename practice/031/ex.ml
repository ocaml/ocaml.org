open OUnit2

module type Testable = sig
  val is_prime : int -> bool
end

module Make(Tested: Testable) : sig val v : test end = struct
  let rec flag_prime n lst_n =
    match lst_n with 
    | [] -> []
    | hd :: tl -> (hd, is_prime tl) :: flag_prime n tl

  let primes = [2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71; 73; 79; 83; 89; 97]

  let tests = "flag_prime" >::: List.map (fun (n, is_prime) ->
        let test_name = Printf.sprintf "Testing if %d is prime" n in
        test_name >:: (fun _ -> assert_equal is_prime (Tested.is_prime n))
      ) primes

  let v = "is_prime Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
