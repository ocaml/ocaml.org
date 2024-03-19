open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val leaves : 'a binary_tree -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested
  
  let tests = [
    "empty_tree" >:: (fun _ -> assert_equal [] (leaves Empty));
    "single_leaf" >:: (fun _ -> assert_equal [1] (leaves (Node(1, Empty, Empty))));
  ]
  
  let v = "leaves" >::: tests
end

module Work : Testable = Work.Impl

module Answer : Testable = Answer.Impl
