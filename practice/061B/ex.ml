open OUnit2

module type Testable = sig
  val leaves : 'a binary_tree -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "leaves" >::: [
    "empty_tree" >:: (fun _ -> assert_equal [] (Tested.leaves Empty));
  ]
end

module Work : Testable = Work.Impl

module Answer : Testable = Answer.Impl
