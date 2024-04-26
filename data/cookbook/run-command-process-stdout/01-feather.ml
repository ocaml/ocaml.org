---
packages:
- name: feather
  tested_version: 0.3.0
  used_libraries:
  - feather
---
(* `process` executes a program and `collect` returns a single string containing the whole stdout *)
let ps_output = Feather.(process "ps" ["-x"] |> collect stdout)

(* A simple processing *)
let () =
  ps_output
  |> String.split_on_char '\n'
  |> List.iter (fun l -> Printf.printf "%s\n" l)

