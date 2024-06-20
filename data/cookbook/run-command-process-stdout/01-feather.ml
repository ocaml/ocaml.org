---
packages:
- name: feather
  tested_version: 0.3.0
  used_libraries:
  - feather
---

(* `Feather.process` executes a program and `Feather.collect` returns a single string containing the whole standard output. *)
let () =
  let ps_output =
    Feather.(process "ps" ["-x"]
    |> collect stdout)
  in
  print_endline ps_output
