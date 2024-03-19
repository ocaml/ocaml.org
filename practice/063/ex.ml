open OUnit2

module type Testable = sig
  val complete_binary_tree : 'a list -> 'a binary_tree
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "complete_binary_tree" >::: [
    "empty_list" >:: (fun _ -> assert_equal Empty (Tested.complete_binary_tree []));
    "single_node" >:: (fun _ -> assert_equal (Node(1, Empty, Empty)) (Tested.complete_binary_tree [1]));
    "small_list" >:: (fun _ -> assert_equal (Node(1, Node(2, Empty, Empty), Node(3, Empty, Empty))) (Tested.complete_binary_tree [1; 2; 3]));
    "larger_list" >:: (fun _ -> assert_equal (Node(1, Node(2, Node(4, Empty, Empty), Node(5, Empty, Empty)), Node(3, Node(6, Empty, Empty), Empty))) (Tested.complete_binary_tree [1; 2; 3; 4; 5; 6]));
  ]
end

module Work : Testable = Work.Impl

module Answer : Testable = Answer.Impl
