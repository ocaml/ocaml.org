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
  let performance_comparison () =
    let time_phi = timeit Tested.phi 10090 in
    let time_phi_improved = timeit Tested.phi_improved 10090 in
    Printf.printf "\nComparing naive phi with phi_improved\n";
    Printf.printf "Time for phi(10090): %f seconds\n" time_phi;
    Printf.printf "Time for phi_improved(10090): %f seconds\n\n" time_phi_improved;
    assert_bool "phi_improved should be faster than phi for large n" (time_phi_improved < time_phi)

  let tests = "Improved Euler's Totient Function Tests" >::: [
    "phi_improved of 10" >:: (fun _ ->
      assert_equal 4 (Tested.phi_improved 10));
    "phi_improved of 13" >:: (fun _ ->
      assert_equal 12 (Tested.phi_improved 13));
    "phi_improved of 1 (edge case)" >:: (fun _ ->
      assert_equal 1 (Tested.phi_improved 1));
    "performance comparison" >:: (fun _ ->
      performance_comparison ());
  ]

  let v = "Improved Euler's Totient Function Tests" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
