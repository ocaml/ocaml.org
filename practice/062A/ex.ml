open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val internals : 'a binary_tree -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct

  let tests = [
     "empty_tree" >:: (fun _ -> assert_equal [] (Tested.internals Empty));
     "one_internal" >:: (fun _ -> assert_equal [] (Tested.internals (Node('a', Empty, Empty))));
     "two_internals" >:: (fun _ -> assert_equal ['a'] (Tested.internals (Node('a', Node('b', Empty, Empty), Empty))));
     "three_internals" >:: (fun _ -> assert_equal ['b'; 'a'] (Tested.internals (Node('a', Node('b', Node('c', Empty, Empty), Empty), Empty))));
  ]  
  let v = "internals" >::: tests
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
