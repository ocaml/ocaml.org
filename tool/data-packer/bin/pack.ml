(* data-pack: Pack YAML/Markdown data into binary format *)

open Cmdliner

let output =
  let doc = "Output binary file" in
  Arg.(value & opt string "data.bin" & info [ "o"; "output" ] ~docv:"FILE" ~doc)

let pack output =
  let data = Data_packer.Packer.load_all () in
  Data_packer.Packer.pack_to_file ~output data;
  `Ok ()

let pack_t = Term.(ret (const pack $ output))

let cmd =
  let doc = "Pack ocaml.org data into binary format" in
  let info = Cmd.info "data-pack" ~version:"0.1" ~doc in
  Cmd.v info pack_t

let () = exit (Cmd.eval cmd)
