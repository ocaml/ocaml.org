open OUnit2

module type Testable = sig
  val drop : 'a list -> int -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "drop" >::: [
    "drop every 3rd from list" >:: (fun _ ->
      assert_equal ["a"; "b"; "d"; "e"; "g"; "h"; "j"]
        (Tested.drop ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 3));
    "drop with empty list" >:: (fun _ ->
      assert_equal []
        (Tested.drop [] 3));
    "drop with n larger than list length" >:: (fun _ ->
      assert_equal ["a"; "b"]
        (Tested.drop ["a"; "b"] 3));
    "drop with n equal to 0 (edge case)" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"]
        (Tested.drop ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 0));
    "drop with n equal to 1" >:: (fun _ ->
      assert_equal []
        (Tested.drop ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 1))
  ]

  let v = "Drop Every N'th Element Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
