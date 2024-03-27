open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val leaves : 'a binary_tree -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct  
  let tests = [
     "empty_tree" >:: (fun _ -> assert_equal [] (Tested.leaves Empty));
     "one_internal" >:: (fun _ -> assert_equal [] (Tested.leaves (Node('a', Empty, Empty))));
     "two_internals" >:: (fun _ -> assert_equal ['a'] (Tested.leaves (Node('a', Node('b', Empty, Empty), Empty))));
     "three_internals" >:: (fun _ -> assert_equal ['b'; 'a'] (Tested.leaves (Node('a', Node('b', Node('c', Empty, Empty), Empty), Empty))));
  ]  
  let v = "leaves" >::: tests
end

module Work : Testable = Work.Impl

module Answer : Testable = Answer.Impl
