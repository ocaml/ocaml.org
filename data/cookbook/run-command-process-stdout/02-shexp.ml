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
let ps_output =
  let open Shexp_process in
    eval (run "ps" ["-x"] |- read_all)

(* A simple processing *)
let () =
  ps_output
  |> String.split_on_char '\n'
  |> List.iter (fun l -> Printf.printf "%s\n" l)
