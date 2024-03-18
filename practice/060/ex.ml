open OUnit2

module type Testable = sig
  type 'a binary_tree =
    | Empty
    | Node of 'a * 'a binary_tree * 'a binary_tree
  val hbal_tree_nodes : int -> char binary_tree list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let test_hbal_tree_nodes () =
    "hbal_tree_nodes" >::: [
      "Test Height-Balanced Trees for Height 1" >:: (fun _ ->
          let trees = hbal_tree_nodes 1 in
          assert_equal [Node ('x', Empty, Empty)] trees
        );
        "Test Height-Balanced Trees for Height 2" >:: (fun _ ->
          let trees = hbal_tree_nodes 2 in
          let expected_result = [
            Node ('x', Node ('x', Empty, Empty), Empty);
            Node ('x', Empty, Node ('x', Empty, Empty))
          ] in
          assert_equal expected_result trees
        );
        "Test Height-Balanced Trees for Height 0" >:: (fun _ ->
          let trees = hbal_tree_nodes 0 in
          let expected_result = [Empty] in
          assert_equal expected_result trees
        );
        
    ]

  let v = "Height-Balanced Binary Trees" >::: [test_hbal_tree_nodes ()]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
