---
packages: []
---
let run cmd =
  let inp = Unix.open_process_in cmd in
  let r = In_channel.input_all inp in
  In_channel.close inp; r

let ps_output = run "ps -x"

(* A simple processing *)
let () =
  ps_output
  |> String.split_on_char '\n'
  |> List.iter (fun l -> Printf.printf "%s\n" l)


