open OUnit2

module type Testable = sig
  val last : 'a list -> 'a option
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "last" >::: [
    "nil" >:: (fun _ -> assert_equal None (Tested.last []));
    "cons" >:: (fun _ -> assert_equal (Some "d") (Tested.last ["a"; "b"; "c"; "d"]));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
