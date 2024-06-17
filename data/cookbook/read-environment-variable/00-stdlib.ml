---
packages: []
---

(*
  Both `Sys.getenv` and `Sys.getenv_opt` are functions that take the name of an environment and read its value.

  `Sys.getenv` returns the value directly, but raises a `Not_found` exception if the variable doesn't exist.
*)
let path = Sys.getenv "PATH"
let () =
  Printf.printf "The path is %s\n" path

(*
  In contrast, `Sys.getenv_opt` returns a value of type `string option`: `Some value` if the variable exists and `None` if it doesn't.
*)
let () =
  match Sys.getenv_opt "API_KEY" with
  | Some p ->
      Printf.printf "Ahpi key is %s\n" p
  | None ->
      print_string "Api key is not set.\n"

