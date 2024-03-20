open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val layout_binary_tree_2 : 'a binary_tree -> ('a * int * int) binary_tree
end

module Make(Tested: Testable) : sig val v : OUnit2.test end = struct
  open Tested
  
  let v = "layout_binary_tree_2" >::: [
    "test_layout_binary_tree_2_works_correctly" >:: (fun _ ->
        let example_layout_tree =
          Node ('a', Node ('b', Empty, Empty), Node ('c', Empty, Empty)) in
        let expected_layout =
          Node (('a', 2, 1), Node (('b', 1, 2), Empty, Empty), Node (('c', 3, 2), Empty, Empty)) in
        assert_equal expected_layout (layout_binary_tree_2 example_layout_tree));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
