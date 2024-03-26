open OUnit2

module type Testable = sig
  type 'a binary_tree =
    | Empty
    | Node of 'a * 'a binary_tree * 'a binary_tree
  val hbal_tree_nodes : int -> char binary_tree list
  val min_nodes : int -> int
  val max_nodes : int -> int
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

  let test_min_nodes () =
    "min_nodes" >::: [
      "Test for h = 0" >:: (fun _ ->
        assert_equal 0 (min_nodes 0)
      );
      "Test for h = 1" >:: (fun _ ->
        assert_equal 1 (min_nodes 1)
      );
      "Test for h = 2" >:: (fun _ ->
        assert_equal 2 (min_nodes 2)
      );
      "Test for h = 3" >:: (fun _ ->
        assert_equal 4 (min_nodes 3)
      );
      "Boundary Cases" >:: (fun _ ->
        assert_equal 0 (min_nodes 0);  
        assert_equal 1 (min_nodes 1);  
      );
    ]

  let test_max_nodes () =
    "max_nodes" >::: [
      "Test for h = 0" >:: (fun _ ->
        assert_equal 0 (max_nodes 0)
      );
      "Test for h = 1" >:: (fun _ ->
        assert_equal 1 (max_nodes 1)
      );
      "Test for h = 2" >:: (fun _ ->
        assert_equal 3 (max_nodes 2)
      );
      "Test for h = 3" >:: (fun _ ->
        assert_equal 7 (max_nodes 3)
      );
      "Test for h = 5" >:: (fun _ ->
        assert_equal 31 (max_nodes 5)
        );
      "Test for h = 6" >:: (fun _ ->
        assert_equal 63 (max_nodes 6)
        );
      "Boundary Cases" >:: (fun _ ->
        assert_equal 0 (max_nodes 0);
        assert_equal 1 (max_nodes 1);
      );
      "boundary tests h = 31" >:: (fun _ ->
        assert_equal 2147483647 (max_nodes 31)
      );
      "boundary Test for h = 32" >:: (fun _ ->
        assert_raises (Invalid_argument "max_nodes") (fun () -> max_nodes 32)
      );
      "boundary Test for large input" >:: (fun _ ->
        assert_raises (Invalid_argument "max_nodes") (fun () -> max_nodes max_int)
      );
    ]


  let v = "Height-Balanced Binary Trees" >::: [
    test_hbal_tree_nodes ();
    test_min_nodes ();
    test_max_nodes();  
    ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl

