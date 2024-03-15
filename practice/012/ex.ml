open OUnit2

module type Testable = sig
  type 'a rle = One of 'a | Many of int * 'a
  val decode : 'a rle list -> 'a list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let example_tests = "decode" >::: [
  "Single Element" >:: (fun _ ->
    assert_equal ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"]
      (decode [Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d"; Many (4, "e")]));

  "empty list" >:: (fun _ ->
    assert_equal [] (decode []))
]
  
  let v = "Run-Length Decoding Tests" >::: [
    example_tests;
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
