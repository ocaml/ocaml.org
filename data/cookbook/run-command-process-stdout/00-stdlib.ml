---
packages: []
---

(*
  The function `Unix.open_process_in` runs the given command in parallel with the program.
  The standard output of the command is redirected to a pipe, which can be read via the returned input channel.
*)
let run cmd =
  let inp = Unix.open_process_in cmd in
  let r = In_channel.input_all inp in
  In_channel.close inp; r

(* We call the `ps` command with argument `-x` on the POSIX shell and print its standard output. *)
let () =
  let ps_output = run "ps -x" in
  ps_output
  |> print_endline
