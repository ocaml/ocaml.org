open OUnit2

module type Testable = sig
  type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

  val hbal_tree : int -> char binary_tree list

  val tree_height : 'a binary_tree -> int
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
    ]

    let test_tree_height () =
      "tree_height" >::: [
        "Test Empty Tree" >:: (fun _ ->
          let height = tree_height Empty in
          assert_equal 0 height
        );
        "Test Single Node Tree" >:: (fun _ ->
          let tree = Node ('x', Empty, Empty) in
          let height = tree_height tree in
          assert_equal 1 height
        );
        "Test Multi Node Height 3 Tree" >:: (fun _ ->
          let tree = Node ('x', Node ('x', Empty, Node ('x', Empty, Empty)), Node ('x', Empty, Node ('x', Empty, Empty))) in
          let height = tree_height tree in
          assert_equal 3 height
        );
        "Test Different Heights Tree on both sides" >:: (fun _ ->
          let tree = Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Node ('x', Empty, Empty))) in
          let height = tree_height tree in
          assert_equal 3 height
        );
        "Test Asymmetric Heights Tree" >:: (fun _ ->
          let tree = Node ('x', Node ('x', Node ('x', Empty, Empty), Empty), Empty) in
          let height = tree_height tree in
          assert_equal 3 height
        );
        "Test Large Height Tree" >:: (fun _ ->
          let tree = 
            Node ('x',
              Node ('x',
                Node ('x', Empty, Empty),
                Node ('x', Empty, Empty)
              ),
              Node ('x',
                Node ('x', Empty, Empty),
                Node ('x', Empty, Empty)
              )
            ) 
          in
          let height = tree_height tree in
          assert_equal 3 height
        );
        "Test Random Tree" >:: (fun _ ->
          let tree =
            Node (
              'x',
              Node (
                'x',
                Node ('x', Empty, Node ('x', Empty, Empty)),
                Node ('x', Empty, Node ('x', Empty, Empty))
              ),
              Node (
                'x',
                Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Empty)),
                Node ('x', Empty, Node ('x', Empty, Empty))
              )
            ) 
          in
          let height = tree_height tree in
          assert_bool "Height is greater than or equal to 0" (height >= 0)
        );
      ]
    
  let v = "Height-Balanced Binary Trees" >::: [test_hbal_tree (); test_tree_height();]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
