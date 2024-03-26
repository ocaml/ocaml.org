open OUnit2

module type Testable = sig
  val rev : 'a list -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "rev" >::: [
    "nil" >:: (fun _ -> assert_equal [] (Tested.rev []));
    "cons" >:: (fun _ -> assert_equal ["c"; "b"; "a"] (Tested.rev ["a"; "b"; "c"]));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
