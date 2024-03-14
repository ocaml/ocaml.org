open OUnit2

module type Testable = sig
  val replicate : 'a list -> int -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "replicate" >::: [
    "list with replication" >:: (fun _ ->
      assert_equal ["a"; "a"; "a"; "b"; "b"; "b"; "c"; "c"; "c"]
        (Tested.replicate ["a"; "b"; "c"] 3));
    "empty list" >:: (fun _ ->
      assert_equal []
        (Tested.replicate [] 3));
    "zero replication" >:: (fun _ ->
      assert_equal []
        (Tested.replicate ["a"; "b"; "c"] 0));
    "replication factor of 1" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"]
        (Tested.replicate ["a"; "b"; "c"] 1));
  ]

  let v = "Replicate the elements of a list a given number of times." >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
