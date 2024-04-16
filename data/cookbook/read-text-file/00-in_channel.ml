---
packages: []
---
(** Read the text file. *)
let text = In_channel.(with_open_text "/etc/passwd" input_all)
