open OUnit2

module type Testable = sig
  val range : int -> int -> int list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "range" >::: [
    "ascending order" >:: (fun _ ->
      assert_equal [4; 5; 6; 7; 8; 9]
        (Tested.range 4 9));
    "descending order" >:: (fun _ ->
      assert_equal [9; 8; 7; 6; 5; 4]
        (Tested.range 9 4));
    "equal boundaries" >:: (fun _ ->
      assert_equal [4]
        (Tested.range 4 4));
  ]

  let v = "Create List from Range Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
