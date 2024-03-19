open OUnit2

module type Testable = sig
  val slice : 'a list -> int -> int -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "slice" >::: [
    "slice from list" >:: (fun _ ->
      assert_equal ["c"; "d"; "e"; "f"; "g"]
        (Tested.slice ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 2 6));
    "slice entire list" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"]
        (Tested.slice ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 0 9));
    "slice with zero elements" >:: (fun _ ->
      assert_equal []
        (Tested.slice ["a"; "b"; "c"; "d"] 2 1));
    "slice with indices beyond list length" >:: (fun _ ->
      assert_equal []
        (Tested.slice ["a"; "b"; "c"; "d"] 4 5));
  ]

  let v = "Extract a Slice From a List Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
