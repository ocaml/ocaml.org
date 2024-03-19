open OUnit2

module type Testable = sig
  val string_of_tree : 'a binary_tree -> string
  val tree_of_string : string -> 'a binary_tree
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "string_of_tree & tree_of_string" >::: [
    "test_string_of_tree_works_correctly" >:: (fun _ ->
        let open BinaryTree in
        let example_tree =
          Node ('a', Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty)),
               Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty))) in
        let expected_string = "a(b(d,e),c(,f(g,)))" in
        assert_equal expected_string (Tested.string_of_tree example_tree));

    "test_tree_of_string_works_correctly" >:: (fun _ ->
        let open BinaryTree in
        let example_string = "a(b(d,e),c(,f(g,)))" in
        let expected_tree =
          Node ('a', Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty)),
               Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty))) in
        assert_equal expected_tree (Tested.tree_of_string example_string))
  ]
end

module Work : Testable = Work.Impl

module Answer : Testable = Answer.Impl
