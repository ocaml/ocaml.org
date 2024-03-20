open OUnit2

module type Testable = sig
  type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
  
  val sym_cbal_trees : int -> char binary_tree list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let test_sym_cbal_trees () =
    "sym_cbal_trees" >::: [
      "Test Symmetric Completely Balanced Binary Trees" >:: (fun _ ->
        let trees = sym_cbal_trees 5 in
        let expected_result = [
          Node ('x', Node ('x', Node ('x', Empty, Empty), Empty),
               Node ('x', Empty, Node ('x', Empty, Empty)));
          Node ('x', Node ('x', Empty, Node ('x', Empty, Empty)),
               Node ('x', Node ('x', Empty, Empty), Empty))
        ] in
        assert_equal expected_result trees
      );

      "Test Number of Symmetric Trees with 57 Nodes" >:: (fun _ ->
        let num_trees = List.length (sym_cbal_trees 57) in
        assert_equal 256 num_trees
      )
    ]

  let v = "Symmetric Completely Balanced Binary Trees" >::: [test_sym_cbal_trees ()]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
