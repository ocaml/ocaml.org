open OUnit2

module type Testable = sig
  val phi : int -> int
  val phi_improved : int -> int
end

let timeit f a =
  let t0 = Unix.gettimeofday () in
  ignore (f a);
  let t1 = Unix.gettimeofday () in
  t1 -. t0

module Make(Tested: Testable) : sig val v : test end = struct
  let compare_performance n =
    let time_phi = timeit Tested.phi n in
    let time_phi_improved = timeit Tested.phi_improved n in
    Printf.printf "\nTime for phi(%d): %f seconds\n" n time_phi;
    Printf.printf "Time for phi_improved(%d): %f seconds\n" n time_phi_improved;
    assert_bool "phi_improved should be faster than phi for large n" (time_phi_improved < time_phi)

  let tests = "Euler's Totient Function Performance Comparison" >::: [
    "compare phi and phi_improved performance for n=10090" >:: (fun _ -> compare_performance 10090);
  ]

  let v = "Performance Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
