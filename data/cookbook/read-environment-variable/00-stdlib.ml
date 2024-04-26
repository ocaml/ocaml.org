---
packages: []
discussion: |
  - **Understanding `Sys.getenv` and `Sys.getenv_opt`:** Both `Sys.getenv` and `Sys.getenv_opt` functions take a environment variable name and return its value. `Sys.getenv` returns directly the value, but raises a `Not_found` exception if the variable doesn't exist. `Sys.getenv_opt` returns an `option` type: `Some value` if the variable exists and `None` if not.
---

let path = Sys.getenv "PATH"
let () =
  Printf.printf "The path is %s\n" path

let () =
  match Sys.getenv_opt "OPAM_SWITCH_PREFIX" with
  | Some p ->
      Printf.printf "The Opam switch prefix is %s\n" p
  | None ->
      print_string "The Opam switch prefix is not set.\n"
