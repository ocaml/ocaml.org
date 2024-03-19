open OUnit2

module type Testable = sig
  type 'a binary_tree =
    | Empty
    | Node of 'a * 'a binary_tree * 'a binary_tree
  val is_symmetric : 'a binary_tree -> bool
  val construct : 'a list -> 'a binary_tree
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let test_construct () =
    "construct_test" >:: (fun _ ->
      let tree = construct [3; 2; 5; 7; 1] in
      let expected_tree =
        Node (3, Node (2, Node (1, Empty, Empty), Empty),
              Node (5, Empty, Node (7, Empty, Empty)))
      in
      assert_equal expected_tree tree
    )

  let test_symmetric () =
    "symmetric_test" >:: (fun _ ->
      assert_equal true (is_symmetric (construct [5; 3; 18; 1; 4; 12; 21]));
      assert_equal true (not (is_symmetric (construct [3; 2; 5; 7; 4])))
    )

  let v = "Binary Search Trees Tests" >::: [test_construct (); test_symmetric ()]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
