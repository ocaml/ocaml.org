---
packages: []
---
(* `Sys.argv` is the command-line arguments as an array of strings
   ([standard library documentation](https://ocaml.org/manual/5.3/api/Sys.html#VALargv)).
   Here we print each argument with its corresponding index in the array. *)
let simplest_parser () =
  Sys.argv
  |> Array.to_list
  |> List.iteri (Printf.printf "argument %d: %s\n")

(* `Arg` is a module for parsing command-line arguments, and it is part of
   OCaml's standard library
   ([documentation](https://ocaml.org/manual/5.3/api/Arg.html)).
   In this function we define the structure of the command-line arguments we
   expect, the argument types types and their documentation. This is basically
   the same function defined in the module's documentation. *)
let arg_module_parser () =
  let usage_msg =
    "mycmd [--verbose] <file1> [<file2>] ... -o <output>"
  and verbose = ref false
  and input_files = ref []
  and output_file = ref "" in
(* This function is called once for each anonymous argument. *)
  let anonymous_args_f filename =
    input_files := filename :: !input_files
(* The spec list defines argument keywords, "setter" functions to handle the
   values, and their corresponding documentation. *)
  and spec_list =
    [("--verbose", Arg.Set verbose, "Output debug information");
     ("-o", Arg.Set_string output_file, "Set output file name")]
  in
  Arg.parse spec_list anonymous_args_f usage_msg;
  Printf.printf "verbose: %b\n" !verbose;
  Printf.printf "input files: %s\n"
    (!input_files |> String.concat ", ");
  Printf.printf "output file: %s\n" !output_file

(* Given a command-line like `mycmd --verbose file1 -o /tmp/out`, we should
   expect the following output:

   ```
   === Simplest parser ===
   argument 0: mycmd
   argument 1: --verbose
   argument 2: file1
   argument 3: -o
   argument 4: /tmp/out

   === Arg.parse ===
   verbose: true
   input files: file1
   output file: /tmp/out
   ``` *)
let () =
  print_endline "=== Simplest parser ===";
  simplest_parser ();

  Printf.printf "\n%!";

  print_endline "=== Arg.parse ===";
  arg_module_parser ()
