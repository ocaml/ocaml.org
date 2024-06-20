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

(* We use the pipe operator and build a sequence of commands, then `read_all` to obtain its standard output. *)
let () =
  let sort_output =
    let open Shexp_process in
      eval (
        run "echo" ["t\nz\nu\na\nb"]
        |- run "sort" []
        |- read_all)
  in
  print_string sort_output
