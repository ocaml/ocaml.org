
open OUnit2

module type Testable = sig
  val gcd : int -> int -> int
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "gcd" >::: [
    "nil" >:: (fun _ -> assert_equal 27 (Tested.gcd 0 27));
    "cons" >:: (fun _ -> assert_equal 2 (Tested.gcd 20536 7826));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
