open OUnit2

module type Testable = sig
  val length : 'a list -> int
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "length" >::: [
    "nil" >:: (fun _ -> assert_equal 0 (Tested.length []));
    "cons" >:: (fun _ -> assert_equal 3 (Tested.length ["a"; "b"; "c"]));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
