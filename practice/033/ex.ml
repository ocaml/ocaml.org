open OUnit2

module type Testable = sig
  val coprime : int -> int -> bool
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "coprime" >::: [
    "coprime numbers" >:: (fun _ ->
      assert_bool "13 and 27 should be coprime" (Tested.coprime 13 27));
    "not coprime numbers" >:: (fun _ ->
      assert_bool "20536 and 7826 should not be coprime" (not (Tested.coprime 20536 7826)));
  ]

  let v = "Coprime Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
