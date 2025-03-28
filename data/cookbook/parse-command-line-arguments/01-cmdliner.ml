---
packages:
- name: cmdliner
  tested_version: "1.3.0"
  used_libraries:
  - cmdliner
---
(* In this example, we define a parser for a command-line like this:

   ```
   mycmd --verbose input_file -o output_file
   ```

   `--verbose` and `-o` are optional, and the command should accept multiple
   input files.

   We can find more examples on
   [this page](https://erratique.ch/software/cmdliner/doc/examples.html).
 *)
let cmdliner_parser () =
(* `Cmdliner` is a library that allows the declarative definition of
   command-line interfaces
   ([documentation page](https://erratique.ch/software/cmdliner/doc/index.html)).
 *)
  let open Cmdliner in
(* First we declare the expected arguments of our command-line, and how
   `Cmdliner` should parse them. *)
  let verbose =
    let doc = "Output debug information" in
(* `&` is a right associative composition operator
   ([documentation](https://erratique.ch/software/cmdliner/doc/Cmdliner/Arg/index.html#val-(&))).
 *)
    Arg.(value & flag & info ["v" ; "verbose"] ~doc)
  and input_files =
    let doc = "Input file(s)" in
    Arg.(non_empty & pos_all file []
         & info [] ~docv:"INPUT" ~doc)
  and output_file =
    let doc = "Output file"
    and docv = "OUTPUT" in
    Arg.(value & opt (some string) None
         & info ["o"] ~docv ~doc)
(* `mycmd` is the function that the program will apply to the parsed
   arguments. *)
  and mycmd verbose input_files output_file =
    Printf.printf "verbose: %b\n" verbose;
    Printf.printf "input files: %s\n"
      (input_files |> String.concat ", ");
    Printf.printf "output file: %s\n"
      (Option.value ~default:"" output_file)
  in
(* Declaration of the complete command, including its man-like
   documentation. *)
  let cmd =
    let doc = "An example command"
    and man = [
        `S Manpage.s_description;
        `P "A command that can take multiple files
            and outputs a file (optional)."
      ]
    in
    Cmd.v (Cmd.info "mycmd" ~doc ~man)
      Term.(const mycmd $ verbose $ input_files $ output_file)
  in
  Cmd.eval cmd


(* Given a command-line like
   `mycmd --verbose -o somefile ./dune-project ./cmd_cookbook.opam`, we should
   expect the following output:

   ```
   verbose: true
   input files: ./dune-project, ./cmd_cookbook.opam
   output file: somefile
   ``` *)
let () =
  exit @@ cmdliner_parser ()
