---
packages: []
---
(* `In_channel.with_open_text` opens a channel the file at the given path.
   `input_all` reads all data from the input channel and returns it as a string.
   These functions can raise `Sys_error` exceptions.
   *)
let read_text_from_file filename =
  try
    In_channel.with_open_text
      filename
      In_channel.input_all
  with Sys_error msg ->
    failwith ("Failed to read from file: " ^ msg)

(*  `Out_channel.with_open_text` safely opens the file, writes text to it, and closes it automatically.*)
let write_text_to_file filename text =
  Out_channel.with_open_text
    filename
    (fun out_channel ->
      Out_channel.output_string out_channel text)
 