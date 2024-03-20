open OUnit2

module type Testable = sig
  type 'a rle = One of 'a | Many of int * 'a
  val encode : 'a list -> 'a rle list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let example_tests = "encode" >::: [
    "single elements" >:: (fun _ ->
      assert_equal [Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d"; Many (4, "e")]
        (encode ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"]));
    "empty list" >:: (fun _ ->
      assert_equal [] (encode []));
  ]
  
  let v = "Run-Length Encoding Tests" >::: [
    example_tests;
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
