let print = {|let () = print_endline "Welcome to the OCaml Playground"|}

let adts =
  {|type ('a, 'b) res = Ok of 'a | Err of 'b

let pp_res = function
  | Ok _ -> print_endline "OK!"
  | Err _ -> print_endline "Error!!"

let () = pp_res (Ok 10)|}
