---
packages:
- name: lwt
  tested_version: 5.7.0
  used_libraries:
  - lwt
  - lwt.unix
discussion: |
  Lwt is a scheduler that permits concurrent execution of promises on a
  single thread. Promise switching is performed at each long I/O (using the
  `Lwt_io` module), timing pause (`Lwt_unix.sleep`), or explicit promise
  switching (`Lwt.pause ()`). Promises are typically composed with the `Lwt.bind`
  function. More details about the monad `bind` function is given in the [monad
  section](/docs/monads). The `let` operators are detailed in the [operator
  section](/docs/operators). Refer to [the Lwt manual](https://ocsigen.org/lwt/latest/manual/manual).

  [`ppx_let`](https://ocaml.org/p/ppx_let/latest) can be used
  to enable the syntax `let%lwt` instead of defining `let*` as a shorthand for `Lwt.bind.
  This makes it obvious on first glance which monad we're operating in.
---

(* We define shorthands for the Lwt binding operators to make our concurrent code more readable.
  `let* a = <Lwt promise> in b` schedules the Lwt promise, waits for its result,
  then excutes `b`. In contrast, `let*? a = <promise> in b` short-circuits on error
  by using a `Result` type: execution continues if the result is `Ok x`, and stops
  if the result was `Error err`.
  *)
let ( let* ) = Lwt.bind
let ( let*? ) = Lwt_result.bind

(* Example task with return value to demonstrate concurrent execution. *)
let task n =
  let* () = Lwt_io.printf "Task %d - first line\n" n in
  let* () = Lwt.pause () in
  let* () = Lwt_io.printf "Task %d - second line\n" n in
  Lwt.return n

(* Example task that only produces side effects, without a return value.
  *)
let task' n =
  let* result = task n in
  Lwt.return_unit

let () =
(* Run two tasks in parallel and collect the results. *)
  let run_two_parallel_tasks () =
    Lwt_main.run @@ Lwt.both (task 1) (task 2)
  in
  Printf.printf "\n= Running Two Parallel Tasks =\n";
  let (result1, result2) = run_two_parallel_tasks () in
  Printf.printf "Results: (%s, %s)\n"
    (string_of_int result1)
    (string_of_int result2);

(* Run tasks in parallel and collect results. *)
  let parallel_map () =
    Lwt_main.run @@ Lwt_list.map_p task [1; 2; 3]
  in
  Printf.printf "\n= Parallel Map Example =\n";
  let parallel_results = parallel_map () in
  Printf.printf "Results: [%s]\n"
    (String.concat "; "
      (List.map string_of_int parallel_results));

(* Run tasks sequentially and collect results. *)
  let sequential_map () =
    Lwt_main.run @@ Lwt_list.map_s task [1; 2; 3]
  in
  Printf.printf "\n= Sequential Map Example =\n";
  let sequential_results = sequential_map () in
  Printf.printf "Results: [%s]\n"
    (String.concat "; "
      (List.map string_of_int sequential_results));

(* Run tasks in parallel for side effects. *)
  let parallel_iter () =
    Lwt_main.run @@ Lwt_list.iter_p task' [1; 2; 3]
  in
  Printf.printf "\n= Parallel Iteration Example =\n";
  parallel_iter ();

(* Run tasks sequentially for side effects. *)
  let sequential_iter () =
    Lwt_main.run @@ Lwt_list.iter_s task' [1; 2; 3]
  in
  Printf.printf "\n= Sequential Iteration Example =\n";
  sequential_iter ();

  let sleep_task () =
    Lwt_main.run @@ (Lwt_unix.sleep 1.)
  in
  Printf.printf "\n= Sleep Example (1 second) =\n";
  sleep_task ();
  Printf.printf "Finished sleeping\n"
