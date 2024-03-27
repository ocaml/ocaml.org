open OUnit2

module type Testable = sig
  val extract : int -> 'a list -> 'a list list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "extract" >::: [
    "nil" >:: (fun _ -> assert_equal [[]] (Tested.extract 0 ["a"]));
    "cons" >:: (fun _ -> assert_equal [["a"; "b"]; ["a"; "c"]; ["a"; "d"]; ["b"; "c"]; ["b"; "d"]; ["c"; "d"]] (Tested.extract 2 ["a"; "b"; "c"; "d"]));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
