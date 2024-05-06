---
packages: []
---
(* `with_open_text` opens a channel the file at the given path.
   `input_all` reads all data from the input channel.
   These functions can raise `Sys_error` exceptions.
   *)
let text =
  In_channel.(with_open_text "/etc/passwd" input_all)
