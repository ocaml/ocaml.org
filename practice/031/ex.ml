open OUnit2

module type Testable = sig
  val is_prime : int -> bool
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "is_prime" >::: [
    "nil" >:: (fun _ -> assert_equal false (Tested.(not (is_prime 7))));
    "cons" >:: (fun _ -> assert_equal true (Tested.is_prime 7));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
