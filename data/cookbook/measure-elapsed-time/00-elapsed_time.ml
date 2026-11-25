---
packages: []
---

(* A simple test function that counts from 0 to n *)
let count_to n =
  let rec aux i =
    if i < n then aux (i + 1)
    else print_endline "Done!"
  in
  Printf.printf "Counting to %d...\n" n;
  aux 0

(* We use the `Unix` library (which is part of OCaml's standard library), which provides the function `Unix.gettimeofday` to get the current time in seconds since the Unix epoch. *)
let () =
  let start_time = Unix.gettimeofday () in
  count_to 1_000_000_000;
  Printf.printf "Elapsed time: %f seconds\n" (Unix.gettimeofday () -. start_time)

(* We can also create a function that executes another function and prints the elapsed time *)
let exec_and_print_elapsed_time f name =
  let start_time = Unix.gettimeofday () in
  let result = f () in
  Printf.printf "Elapsed time for %s: %f seconds\n" name (Unix.gettimeofday () -. start_time);
  result

(* An example usage of this function *)
let () = exec_and_print_elapsed_time (fun () -> count_to 1_000_000_000) "counting up to a billion"