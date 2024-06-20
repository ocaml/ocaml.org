---
packages:
- name: shexp
  tested_version: v0.16.0
  used_libraries:
  - shexp
  - shexp.process
---
(* The module Shexp_process.Infix contains the `|-` (pipe) operator. *)
open Shexp_process.Infix

(* We use the pipe operator to build a sequence consisting of the single command
  `ps -x`, then `read_all` to obtain its standard output. *)
let () =
  let ps_output =
    let open Shexp_process in
      eval (run "ps" ["-x"] |- read_all)
  in
  print_endline ps_output
