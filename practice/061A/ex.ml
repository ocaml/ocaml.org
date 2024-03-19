open OUnit2

module type Testable = sig
  val count_leaves : 'a binary_tree -> int
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "count_leaves" >::: [
    "empty_tree" >:: (fun _ -> assert_equal 0 (Tested.count_leaves Empty));
    "single_leaf" >:: (fun _ -> assert_equal 1 (Tested.count_leaves (Node(1, Empty, Empty))));
  ]
end

module Work : Testable = Work.Impl

module Answer : Testable = Answer.Impl
