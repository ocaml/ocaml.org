open OUnit2

module type Testable = sig
  val rotate : 'a list -> int -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "rotate" >::: [
    "rotate 3 places left" >:: (fun _ ->
      assert_equal ["d"; "e"; "f"; "g"; "h"; "a"; "b"; "c"]
        (Tested.rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 3));
    "rotate with negative n" >:: (fun _ ->
      assert_equal ["d"; "e"; "f"; "g"; "h"; "a"; "b"; "c"]
        (Tested.rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] (-5)));
    "rotate more than length" >:: (fun _ ->
      assert_equal ["d"; "e"; "f"; "g"; "h"; "a"; "b"; "c"]
        (Tested.rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 11));
    "rotate zero places" >:: (fun _ ->
      assert_equal ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"]
        (Tested.rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 0));
    "rotate empty list" >:: (fun _ ->
      assert_equal []
        (Tested.rotate [] 3));
  ]

  let v = "Rotate List Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
