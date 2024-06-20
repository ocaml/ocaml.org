---
packages: []
---

(*
  Both `Sys.getenv` and `Sys.getenv_opt` are functions that take the name of an environment and read its value.

  `Sys.getenv` returns the value directly, but raises a `Not_found` exception if the variable doesn't exist.
*)
let () =
  try
    let path = Sys.getenv "PATH" in
    Printf.printf "The path is %s\n" path
  with Not_found ->
    print_string "The path is not set.\n"

(*
  In contrast, `Sys.getenv_opt` returns a value of type `string option`: `Some value` if the variable exists and `None` if it doesn't.
*)
let () =
  match Sys.getenv_opt "API_KEY" with
  | Some p ->
      Printf.printf "Api key is %s\n" p
  | None ->
      print_string "Api key is not set.\n"

