---
packages:
- name: feather
  tested_version: 0.3.0
  used_libraries:
  - feather
---
(* The `|.` can be used to pipe different commands. *)
let sort_output = Feather.(echo "t\nz\nu\na\nb" |. process "sort" [""] |> collect stdout)

(* A simple processing *)
let () =
  print_string sort_output

