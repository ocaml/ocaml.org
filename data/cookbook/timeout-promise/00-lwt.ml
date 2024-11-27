---
packages:
- name: lwt
  tested_version: 5.7.0
  used_libraries:
  - lwt
  - lwt.unix
discussion: |
    [`ppx_let`](https://ocaml.org/p/ppx_let/latest) can be used
    to enable the syntax `let%lwt` instead of defining `let*` as a shorthand for `Lwt.bind.
    This makes it obvious on first glance which monad we're operating in.
---
(*
   We use monadic binding (let*) to chain promises together in a readable way.
*)
let (let*) = Lwt.bind

(*
Attempt to read a line of input from stdin using `Lwt_io.read_line`.
- We use `Lwt.finalize` to ensure cleanup (flushing stdin) happens regardless of success/failure
- `Lwt.catch` handles any exceptions during reading
*)
let read_name () =
  Lwt.finalize
    (fun () ->
      Lwt.catch
        (fun () ->
          let* name = Lwt_io.(read_line stdin) in
          Lwt.return (Some name))
        (fun _ -> Lwt.return None))
(* Flush ensures no pending input is left in the buffer  *)
    (fun () ->
      Lwt_io.flush Lwt_io.stdin)

(*
We create a promise that resolves to None after waiting for the specified
duration using `Lwt_unix.sleep`.

The `Lwt_unix` library provides the operating-system (not just "unix") and scheduling modules for Lwt.
*)
let timeout ?(duration = 6.0) () =
  let* () = Lwt_unix.sleep duration in
  Lwt.return None

(*
`Lwt.pick` starts both the `read_name` and `timeout` promises simultaneously,
keeps the first promise to complete (user input or timeout), and
automatically cancels the other promise.

All the promises given to a `Lwt.pick` need to have the same type, in this case
`string option Lwt.t`.
*)
let main () =
  print_endline "Enter your name (don't take too long)";
  let* result = Lwt.pick [ read_name (); timeout () ] in
  (match result with
  | Some name -> Printf.printf "Hello %s\n" name
  | None -> print_endline "Too slow!");
  Lwt.return_unit

(*
To run the event-loop we use a single `Lwt_main.run` which processes a single top-level promise.
*)
let () = Lwt_main.run (main ())
