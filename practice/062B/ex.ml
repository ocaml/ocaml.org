open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val at_level : 'a binary_tree -> int -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested
  
  let example_tree =
    Node ('a', Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty)),
         Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty)))

  let v = "at_level" >::: [
    "empty_tree" >:: (fun _ -> assert_equal [] (Tested.at_level Empty 1));
    "level_1_single_node" >:: (fun _ -> assert_equal ['a'] (Tested.at_level example_tree 1));
    "level_2_two_nodes" >:: (fun _ -> assert_equal ['b'; 'c'] (Tested.at_level example_tree 2));
    "level_3_four_nodes" >:: (fun _ -> assert_equal ['d'; 'e'; 'f'] (Tested.at_level example_tree 3));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
