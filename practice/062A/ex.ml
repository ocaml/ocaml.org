open OUnit2

module type Testable = sig
  val internals : 'a binary_tree -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "internals" >::: [
    "empty_tree" >:: (fun _ -> assert_equal [] (Tested.internals Empty));
    "one_internal" >:: (fun _ -> assert_equal ['a'] (Tested.internals (Node('a', Empty, Empty))));
    "two_internals" >:: (fun _ -> assert_equal ['b'; 'a'] (Tested.internals (Node('a', Node('b', Empty, Empty), Empty))));
    "three_internals" >:: (fun _ -> assert_equal ['c'; 'b'; 'a'] (Tested.internals (Node('a', Node('b', Node('c', Empty, Empty), Empty), Empty))));
  ]
end

module Work : Testable = Work.Impl

module Answer : Testable = Answer.Impl
