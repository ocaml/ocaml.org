---
packages:
- name: feather
  tested_version: 0.3.0
  used_libraries:
  - feather
---

(* The `|.` operator from the `Feather` module can be used to pipe different commands. *)
let () =
  let sort_output =
    Feather.(echo "t\nz\nu\na\nb" |. process "sort" [""] |> collect stdout)
  in
  print_string sort_output
