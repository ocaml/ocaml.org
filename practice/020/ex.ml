open OUnit2

module type Testable = sig
  val remove_at : int -> 'a list -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "remove_at" >::: [
    "remove element at 1" >:: (fun _ ->
      assert_equal ["a"; "c"; "d"]
        (Tested.remove_at 1 ["a"; "b"; "c"; "d"]));
    "remove beyond list length" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"; "d"]
        (Tested.remove_at 4 ["a"; "b"; "c"; "d"]));
    "remove from empty list" >:: (fun _ ->
      assert_equal []
        (Tested.remove_at 1 []));
  ]

  let v = "Remove the K'th Element Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
