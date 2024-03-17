open OUnit2

module type Testable = sig
  val permutation : 'a list -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "permutation" >::: [
    "nil" >:: (fun _ -> assert_equal [] (Tested.permutation []));
    "cons" >:: (fun _ -> assert_equal ["c"; "d"; "f"; "e"; "b"; "a"] (Tested.permutation ["a"; "b"; "c"; "d"; "e"; "f"]));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
