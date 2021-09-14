[@@@part "0"]

let usage_msg = "append [-verbose] <file1> [<file2>] ... -o <output>"

[@@@part "1"]

let verbose = ref false

let input_files = ref []

let output_file = ref ""

[@@@part "2"]

let anon_fun filename = input_files := filename :: !input_files

[@@@part "3"]

let speclist =
  [ "-verbose", Arg.Set verbose, "Output debug information"
  ; "-o", Arg.Set_string output_file, "Set output file name"
  ]

[@@@part "4"]

let () = Arg.parse speclist anon_fun usage_msg

(* Main functionality here *)
