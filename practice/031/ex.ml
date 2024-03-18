open OUnit2

module type Testable = sig
  val flag_prime : 'a -> int list -> (int * bool) list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "flag_prime" >::: [
    "flag_prime" >:: (fun _ -> assert_equal [(2, true); (3, true); (5, true); (7, true); (11, true)] (Tested.flag_prime 0 [2;3;5;7;11]))
]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
