let po_of_filename filename =
  let chn = open_in filename in
  let po = Gettext_po.input_po chn in
  close_in chn;
  po

let run ~pot_filename ~po_filename =
  let pot = po_of_filename pot_filename in
  let po = po_of_filename po_filename in
  let po_merged = Gettext_po.merge_pot pot po in
  Gettext_po.output_po stdout po_merged;
  0

(* Command line interface *)

open Cmdliner

let doc = "Merge a POT file into a PO file."

let sdocs = Manpage.s_common_options

let exits = Common.exits

let envs = Common.envs

let man =
  [ `S Manpage.s_description
  ; `P "$(tname) merges the msgid found in a POT file into a PO file."
  ]

let info = Term.info "merge" ~doc ~sdocs ~exits ~envs ~man

let term =
  let open Common.Syntax in
  let+ _term = Common.term
  and+ pot_filename =
    let doc = "The POT file." in
    let docv = "POT_FILE" in
    Arg.(required & pos 0 (some string) None & info [] ~doc ~docv)
  and+ po_filename =
    let doc = "The PO file." in
    let docv = "PO_FILE" in
    Arg.(required & pos 1 (some string) None & info [] ~doc ~docv)
  in
  run ~pot_filename ~po_filename

let cmd = term, info
