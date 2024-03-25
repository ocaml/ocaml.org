open OUnit2

module type Testable = sig
  val compress : 'a list -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "compress" >::: [
    "non-empty list" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"; "a"; "d"; "e"]
        (Tested.compress ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"]));
    "empty list" >:: (fun _ -> assert_equal [] (Tested.compress []));
  ]

  let v = "Remove Duplicates" >::: [ tests ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
