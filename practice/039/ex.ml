
open OUnit2

module type Testable = sig
   val all_primes : int -> int -> int list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let primes = [2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71;
  73; 79; 83; 89; 97; 101; 103; 107; 109; 113; 127; 131; 137; 139; 149; 151;
  157; 163; 167; 173; 179; 181; 191; 193; 197; 199]

  let v = "List_primes" >::: [
    "all_primes" >::: [
      "all" >:: (fun _ -> assert_equal primes (Tested.all_primes 0 200));
      "some" >:: (fun _ -> assert_equal (List.filter (fun n -> 50 <= n && n <= 150) primes) (Tested.all_primes 50 150));
      "none" >:: (fun _ -> assert_equal [] (Tested.all_primes 150 50));
    ]
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
