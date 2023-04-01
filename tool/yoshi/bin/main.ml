open Cmdliner

let read_file f = In_channel.with_open_text f In_channel.input_all

let write_file f s =
  Out_channel.with_open_text f (fun oc -> Out_channel.output_string oc s)

let generate_module config_file input_file =
  let config_string = read_file config_file in
  let input_yaml_string = read_file input_file in
  Yoshi.generate_module config_string input_yaml_string

(* Command-line options *)
let input_file =
  let doc = "Path to the input YAML containing the data." in
  Arg.(required & pos 0 (some file) None & info [] ~docv:"INPUT_FILE" ~doc)

let output_file =
  let doc = "Path to the output OCaml module file." in
  Arg.(
    value
    & opt (some string) None
    & info [ "o"; "output" ] ~docv:"OUTPUT_FILE" ~doc)

let config_file =
  let doc = "Path to the YAML configuration file." in
  Arg.(
    value
    & opt (some file) None
    & info [ "c"; "config" ] ~docv:"CONFIG_FILE" ~doc)

(* Main command *)
let main input_file output_file config_file =
  let config_file =
    match config_file with
    | Some x -> x
    | None -> failwith "expected a configuration file"
  in
  let generated_code = generate_module config_file input_file in
  match output_file with
  | Some file -> write_file file generated_code
  | None -> print_endline generated_code

let main_t = Term.(const main $ input_file $ output_file $ config_file)

(* Command info *)
let info =
  let doc = "Generate OCaml modules from YAML data." in
  let man =
    [
      `S Manpage.s_description;
      `P
        "This tool generates OCaml modules from YAML data based on a provided \
         configuration file.";
    ]
  in
  Cmd.info "yoshi" ~version:"1.0.0" ~doc ~exits:Cmd.Exit.defaults ~man

(* Main function *)
let () =
  Printexc.record_backtrace true;
  exit @@ Cmd.eval (Cmd.v info main_t)
