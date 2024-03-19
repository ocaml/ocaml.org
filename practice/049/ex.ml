open OUnit2

module type Testable = sig
  val gray : int -> string list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let example_tests = "gray" >::: [
    "n = 1" >:: (fun _ ->
      assert_equal ["0"; "1"] (Tested.gray 1));
    "n = 2" >:: (fun _ ->
      assert_equal ["00"; "01"; "11"; "10"] (Tested.gray 2));
    "n = 3" >:: (fun _ ->
      assert_equal ["000"; "001"; "011"; "010"; "110"; "111"; "101"; "100"] (Tested.gray 3));
  ]

let v = "Gray Code Tests" >::: [example_tests]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
