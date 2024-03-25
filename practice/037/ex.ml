open OUnit2

module type Testable = sig
  val phi : int -> int
end

(* Naive phi_naive implementation from exercise 034 for direct comparison *)
let phi_naive n =
  let rec gcd a b = if b = 0 then a else gcd b (a mod b) in
  let coprime a b = gcd a b = 1 in
  let rec count_coprime acc d =
    if d < n then count_coprime (if coprime n d then acc + 1 else acc) (d + 1)
    else acc in
  if n = 1 then 1 else count_coprime 0 1

let timeit f a =
  let t0 = Unix.gettimeofday () in
  ignore (f a);
  let t1 = Unix.gettimeofday () in
  t1 -. t0

  module Make(Tested: Testable) : sig val v : test end = struct
    let test_values = [10090; 100090; 1000090]

    let compare_phi_functions () =
      List.iter (fun n ->
        let result_phi = phi_naive n in
        let result_phi_improved = Tested.phi n in
        let time_phi = timeit phi_naive n in
        let time_phi_improved = timeit Tested.phi n in

        (* Ensuring the results are the same *)
        assert_equal ~msg:(Printf.sprintf "phi_naive and phi should return the same result for n=%d" n) result_phi result_phi_improved;

        (* Failing the test if phi_improved is not faster than phi_naive *)
        Printf.printf "For n=%d, phi_naive took %f seconds, phi took %f seconds\n" n time_phi time_phi_improved;
        let msg = Printf.sprintf "For n=%d, phi should be faster than phi_naive. phi_naive took %f seconds, phi took %f seconds" n time_phi time_phi_improved in
        assert_bool msg (time_phi_improved < time_phi)
      ) test_values

    let v = "Euler's Totient Function Performance Tests" >::: [
      "compare phi_naive and phi" >:: (fun _ -> compare_phi_functions ());
    ]
  end


module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
