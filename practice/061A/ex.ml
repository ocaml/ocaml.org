open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val count_leaves : 'a binary_tree -> int
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested
  
  let tests = [
    "empty_tree", (fun _ -> assert_equal 0 (count_leaves Empty));
    "single_leaf", (fun _ -> assert_equal 1 (count_leaves (Node(1, Empty, Empty))));
  ]

  let v = "count_leaves" >::: List.map (fun (name, _) -> name >:: fun _ -> ()) tests
end

module Work : Testable = Work.Impl

module Answer : Testable = Answer.Impl
