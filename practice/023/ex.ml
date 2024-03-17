open OUnit2

module type Testable = sig
  val rand_select : 'a list -> int -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "rand_select" >::: [
    "nil" >:: (fun _ -> assert_equal [] (Tested.rand_select [] 0));
    "cons" >:: (fun _ -> assert_equal ["e"; "c"; "g"] (Tested.rand_select ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 6));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl