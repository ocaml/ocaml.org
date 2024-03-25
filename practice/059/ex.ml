open OUnit2

module type Testable = sig
  type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
  val hbal_tree : int -> char binary_tree list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested
  let test_hbal_tree () =
    "hbal_tree" >::: [
      "Test Empty Tree" >:: (fun _ ->
        let trees = hbal_tree 0 in
        let expected_trees = [Empty] in
        assert_equal expected_trees trees
      );

      "Test Single Node Tree" >:: (fun _ ->
        let trees = hbal_tree 1 in
        let expected_trees = [Node ('x', Empty, Empty)] in
        assert_equal expected_trees trees
      ); 

      "Test Height 2 Tree" >:: (fun _ ->
        let trees = hbal_tree 2 in
        let expected_trees = [
          Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Empty));
          Node ('x', Node ('x', Empty, Empty), Empty);
          Node ('x', Empty, Node ('x', Empty, Empty))
        ] in
        assert_equal expected_trees trees;
      );

      "Test Height 3 Tree" >:: (fun _ ->
        let trees = hbal_tree 3 in
        let expected_trees = [
          Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Node ('x', Empty, Empty)));
          Node ('x', Node ('x', Empty, Node ('x', Empty, Empty)), Node ('x', Empty, Empty));
          Node ('x', Node ('x', Empty, Empty), Node ('x', Node ('x', Empty, Empty), Empty));
          Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Node ('x', Empty, Empty)));
          Node ('x', Node ('x', Empty, Node ('x', Empty, Empty)), Node ('x', Node ('x', Empty, Empty), Empty));
          Node ('x', Node ('x', Empty, Node ('x', Empty, Empty)), Node ('x', Empty, Node ('x', Empty, Empty)));
          Node ('x', Empty, Node ('x', Empty, Node ('x', Empty, Empty)));
          Node ('x', Node ('x', Empty, Empty), Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Empty)));
          Node ('x', Node ('x', Empty, Node ('x', Empty, Empty)), Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Empty)));
          Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Node ('x', Empty, Empty)));
          Node ('x', Node ('x', Empty, Empty), Node ('x', Node ('x', Empty, Empty), Empty));
          Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Node ('x', Empty, Empty)));
        ] in
        assert_equal expected_trees trees;
      )
    ]
  let v = "Height-Balanced Binary Trees" >::: [test_hbal_tree ()]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
