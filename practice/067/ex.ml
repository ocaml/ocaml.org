open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val string_of_tree : char binary_tree -> string
  val tree_of_string : string -> char binary_tree
end

module Make(Tested: Testable) : sig val v : OUnit2.test end = struct
  open Tested
  
  let v = "string_of_tree and tree_of_string" >::: [
    "test_string_of_tree" >:: (fun _ ->
        let example_tree =
          Node ('a', Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty)), Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty)))
        in
        assert_equal ~printer:(fun x -> x) "a(b(d,e),c(,f(g,)))" (string_of_tree example_tree));
    
    "test_tree_of_string" >:: (fun _ ->
        let example_string = "a(b(d,e),c(,f(g,)))" in
        let expected_tree =
          Node ('a', Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty)), Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty)))
        in
        assert_equal ~printer:(fun x -> string_of_tree x) expected_tree (tree_of_string example_string));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
