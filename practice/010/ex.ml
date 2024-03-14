open OUnit2

module type Testable = sig
  val encode : 'a list -> (int * 'a) list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "encode" >::: [
    "non-empty list" >:: (fun _ ->
      assert_equal [(4, "a"); (1, "b"); (2, "c"); (2, "a"); (1, "d"); (4, "e")]
        (Tested.encode ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"]));
    "empty list" >:: (fun _ ->
      assert_equal [] (Tested.encode []));
  ]

  let v = "Run-Length Encoding" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
