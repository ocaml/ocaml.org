open OUnit2

module type Testable = sig
  type 'a binary_tree =
    | Empty
    | Node of 'a * 'a binary_tree * 'a binary_tree
  val cbal_tree : int -> char binary_tree list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let test_cbal_tree () =
    "cbal_tree" >::: [
      "Example Test" >:: (fun _ ->
        let result = cbal_tree 4 in
        let expected_result = [
          Node ('x', Node ('x', Empty, Empty), Node ('x', Node ('x', Empty, Empty), Empty));
          Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Node ('x', Empty, Empty)));
          Node ('x', Node ('x', Node ('x', Empty, Empty), Empty), Node ('x', Empty, Empty));
          Node ('x', Node ('x', Empty, Node ('x', Empty, Empty)), Node ('x', Empty, Empty))
        ] in
        assert_equal expected_result result);

      "Empty Tree Test" >:: (fun _ ->
        let result = cbal_tree 0 in
        let expected_result = [Empty] in
        assert_equal expected_result result);

      "Single Node Test" >:: (fun _ ->
        let result = cbal_tree 1 in
        let expected_result = [Node ('x', Empty, Empty)] in
        assert_equal expected_result result);

      "Multi Nodes Test" >:: (fun _ ->
        let result = cbal_tree 3 in
        let expected_result = [
          Node ('x', Node ('x', Empty, Empty), Node ('x', Empty, Empty))
        ] in
        assert_equal expected_result result)
    ]

  let v = "Completely Balanced Binary Trees" >::: [test_cbal_tree ()]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
