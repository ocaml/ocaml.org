open OUnit2

module type Testable = sig
  type 'a binary_tree = | Empty | Node of 'a * 'a binary_tree * 'a binary_tree
  val layout_binary_tree_1 : 'a binary_tree -> ('a * int * int) binary_tree
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested
  
  let v = "layout_binary_tree_1" >::: [
    "empty_tree" >:: (fun _ -> assert_equal Empty (Tested.layout_binary_tree_1 Empty));
    "example_tree" >:: (fun _ ->
        let expected_layout =
          Node (('n', 8, 1),
                Node (('k', 6, 2),
                      Node (('c', 2, 3),
                            Node (('a', 1, 4), Empty, Empty),
                            Node (('h', 5, 4),
                                  Node (('g', 4, 5),
                                        Node (('e', 3, 6), Empty, Empty), Empty), Empty)),
                      Node (('m', 7, 3), Empty, Empty)),
                Node (('u', 12, 2),
                      Node (('p', 9, 3), Empty,
                            Node (('s', 11, 4),
                                  Node (('q', 10, 5), Empty, Empty), Empty)),
                      Empty))
        in
        let example_layout_tree =
          let leaf x = Node (x, Empty, Empty) in
          Node ('n', Node ('k', Node ('c', leaf 'a',
                                       Node ('h', Node ('g', leaf 'e', Empty), Empty)),
                            leaf 'm'),
                Node ('u', Node ('p', Empty, Node ('s', leaf 'q', Empty)), Empty))
        in
        assert_equal expected_layout (Tested.layout_binary_tree_1 example_layout_tree)
      )
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
