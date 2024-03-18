open OUnit2

module type Testable = sig
  val phi : int -> int
  val phi_improved : int -> int
  val timeit : (int -> int) -> int -> float
end

module Make(Tested: Testable) : sig val v : test end = struct
  let tests = "Compare Euler's Totient Function Methods" >::: [
    "timing phi vs. phi_improved" >:: (fun _ ->
      let time_phi = Tested.timeit Tested.phi 10090 in
      let time_phi_improved = Tested.timeit Tested.phi_improved 10090 in
      Printf.printf "\nTime for phi: %f\n" time_phi;
      Printf.printf "Time for phi_improved: %f\n" time_phi_improved;
      assert_bool "phi_improved should be faster than phi" (time_phi_improved < time_phi))
  ]

  let v = "Totient Function Performance Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
