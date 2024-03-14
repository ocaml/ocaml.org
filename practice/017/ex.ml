open OUnit2

module type Testable = sig
  val split : 'a list -> int -> 'a list * 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "split" >::: [
    "split into two parts" >:: (fun _ ->
      assert_equal (["a"; "b"; "c"], ["d"; "e"; "f"; "g"; "h"; "i"; "j"])
        (Tested.split ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 3));
    "first part longer than list" >:: (fun _ ->
      assert_equal (["a"; "b"; "c"; "d"], [])
        (Tested.split ["a"; "b"; "c"; "d"] 5));
    "empty list" >:: (fun _ ->
      assert_equal ([], [])
        (Tested.split [] 3));
    "split at 0" >:: (fun _ ->
      assert_equal ([], ["a"; "b"; "c"; "d"])
        (Tested.split ["a"; "b"; "c"; "d"] 0));
    "split at list's length" >:: (fun _ ->
        assert_equal (["a"; "b"; "c"; "d"], [])
          (Tested.split ["a"; "b"; "c"; "d"] 4)) 
  ]

  let v = "Split a List into Two Parts Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
