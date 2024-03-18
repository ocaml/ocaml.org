open OUnit2

module type Testable = sig
  val is_prime : int -> bool
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "is_prime" >::: [
    "is_prime 2" >:: (fun _ -> assert_equal true (Tested.is_prime 2));
    "is_prime 3" >:: (fun _ -> assert_equal true (Tested.is_prime 3));
    "is_prime 5" >:: (fun _ -> assert_equal true (Tested.is_prime 5));
    "is_prime 7" >:: (fun _ -> assert_equal true (Tested.is_prime 7));
    "is_prime 11" >:: (fun _ -> assert_equal true (Tested.is_prime 11));
    "is_prime 13" >:: (fun _ -> assert_equal true (Tested.is_prime 13));
    "is_prime 17" >:: (fun _ -> assert_equal true (Tested.is_prime 17));
    "is_prime 19" >:: (fun _ -> assert_equal true (Tested.is_prime 19));
    "is_prime 23" >:: (fun _ -> assert_equal true (Tested.is_prime 23));
    "is_prime 29" >:: (fun _ -> assert_equal true (Tested.is_prime 29));
    "is_prime 31" >:: (fun _ -> assert_equal true (Tested.is_prime 31));
    "is_prime 37" >:: (fun _ -> assert_equal true (Tested.is_prime 37));
    "is_prime 41" >:: (fun _ -> assert_equal true (Tested.is_prime 41));
    "is_prime 43" >:: (fun _ -> assert_equal true (Tested.is_prime 43));
    "is_prime 47" >:: (fun _ -> assert_equal true (Tested.is_prime 47));
    "is_prime 53" >:: (fun _ -> assert_equal true (Tested.is_prime 53));
    "is_prime 59" >:: (fun _ -> assert_equal true (Tested.is_prime 59));
    "is_prime 61" >:: (fun _ -> assert_equal true (Tested.is_prime 61));
    "is_prime 73" >:: (fun _ -> assert_equal true (Tested.is_prime 73));
    "is_prime 79" >:: (fun _ -> assert_equal true (Tested.is_prime 79));
    "is_prime 83" >:: (fun _ -> assert_equal true (Tested.is_prime 83));
    "is_prime 89" >:: (fun _ -> assert_equal true (Tested.is_prime 89));
    "is_prime 97" >:: (fun _ -> assert_equal true (Tested.is_prime 97))
]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
