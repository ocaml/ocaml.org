let run output maybe_root_dir exts silent =
  let log fmt =
    if silent then Printf.ifprintf stdout fmt
    else Printf.fprintf stdout (fmt ^^ "%!")
  in
  let digest_map =
    match maybe_root_dir with
    | None ->
        log "must specify a directory!\n";
        Digest_map.empty
    | Some root_dir ->
        let _ = exts in
        let _ = output in
        Digest_map.read_directory root_dir Digest_map.empty
  in
  let ml = Digest_map.render_ml digest_map in
  log "%s" ml;
  match output with
  | None -> ()
  | Some filename ->
      let oc = open_out filename in
      Printf.fprintf oc "%s\n" ml;
      close_out oc

open Cmdliner

let () =
  let dir =
    Arg.(
      value
      & pos ~rev:true 0 (some string) None
      & info [] ~docv:"DIRECTORY" ~doc:"Directory.")
  in
  let output =
    Arg.(
      value
      & opt (some string) None
      & info [ "o"; "output" ] ~docv:"OUTPUT"
          ~doc:"Output file for the OCaml module.")
  in
  let exts =
    Arg.(
      value & opt_all string []
      & info [ "e"; "ext" ] ~docv:"VALID EXTENSION"
          ~doc:
            "If specified, compute digest only for files with these extensions.")
  in
  let quiet = Arg.(value & flag & info [ "s"; "silent" ] ~doc:"Silent mode.") in
  let cmd_t = Term.(const run $ output $ dir $ exts $ quiet) in
  let info =
    let doc =
      "Compute hash digest for every file in a directory - outputs a \
       standalone OCaml module."
    in
    Cmd.info "static-file-digest" ~version:"%%VERSION%%" ~doc
  in
  exit @@ Cmd.eval (Cmd.v info cmd_t)
