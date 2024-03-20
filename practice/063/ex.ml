open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val complete_binary_tree : 'a list -> 'a binary_tree
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "complete_binary_tree" >::: [
    "empty_list" >:: (fun _ -> assert_equal Tested.Empty (Tested.complete_binary_tree []));

    "single_node" >:: (fun _ ->
      let result = Tested.complete_binary_tree [1] in
      assert_equal (Tested.Node(1, Tested.Empty, Tested.Empty)) result);

    "small_list" >:: (fun _ ->
      let result = Tested.complete_binary_tree [1; 2; 3] in
      assert_equal (Tested.Node(1, Tested.Node(2, Tested.Empty, Tested.Empty), Tested.Node(3, Tested.Empty, Tested.Empty))) result);

    "larger_list" >:: (fun _ ->
      let result = Tested.complete_binary_tree [1; 2; 3; 4; 5; 6] in
      let expected_tree =
        Tested.Node(1,
          Tested.Node(2, Tested.Node(4, Tested.Empty, Tested.Empty), Tested.Node(5, Tested.Empty, Tested.Empty)),
          Tested.Node(3, Tested.Node(6, Tested.Empty, Tested.Empty), Tested.Empty))
      in
      assert_equal expected_tree result);
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
