---
packages:
- name: shexp
  tested_version: v0.16.0
  used_libraries:
  - shexp
  - shexp.process
---
(* We just declare the `|-` (pipe) operator *)
open Shexp_process.Infix

(* We use the pipe operator and build a sequence of commands, then `eval` it *)
let sort_output =
  let open Shexp_process in
    eval (
      run "echo" ["t\nz\nu\na\nb"]
      |- run "sort" []
      |- read_all)

(* A simple processing *)
let () =
  print_string sort_output
