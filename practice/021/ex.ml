open OUnit2

module type Testable = sig
  val insert_at : 'a -> int -> 'a list -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "insert_at" >::: [
    "insert in the middle" >:: (fun _ ->
      assert_equal ["a"; "alfa"; "b"; "c"; "d"]
        (Tested.insert_at "alfa" 1 ["a"; "b"; "c"; "d"]));
    "insert at the beginning" >:: (fun _ ->
      assert_equal ["beta"; "a"; "b"; "c"; "d"]
        (Tested.insert_at "beta" 0 ["a"; "b"; "c"; "d"]));
    "insert at the end" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"; "d"; "alfa"]
        (Tested.insert_at "alfa" 4 ["a"; "b"; "c"; "d"]));
    "insert beyond the end" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"; "d"; "beta"]
        (Tested.insert_at "beta" 6 ["a"; "b"; "c"; "d"]));
    "insert into empty list" >:: (fun _ ->
      assert_equal ["alfa"]
        (Tested.insert_at "alfa" 0 []));
  ]

  let v = "Insert Element at Position Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
