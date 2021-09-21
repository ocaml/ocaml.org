open Cmdliner

let cmds = [ Cmd_extract.cmd; Cmd_merge.cmd ]

(* Command line interface *)

let doc = "Internationalization and localization support for OCaml"

let sdocs = Manpage.s_common_options

let exits = Common.exits

let envs = Common.envs

let man =
  [ `S Manpage.s_description
  ; `P "Internationalization and localization support for OCaml"
  ; `S Manpage.s_commands
  ; `S Manpage.s_common_options
  ; `S Manpage.s_exit_status
  ; `P "These environment variables affect the execution of $(mname):"
  ; `S Manpage.s_environment
  ; `S Manpage.s_bugs
  ; `P "File bug reports at $(i,%%PKG_ISSUES%%)"
  ; `S Manpage.s_authors
  ; `P "Thibaut Mattio, $(i,https://github.com/tmattio)"
  ]

let default_cmd =
  let term =
    let open Common.Syntax in
    Term.ret
    @@ let+ _ = Common.term in
       `Help (`Pager, None)
  in
  let info =
    Term.info "gettext" ~version:"%%VERSION%%" ~doc ~sdocs ~exits ~man ~envs
  in
  term, info

let () = Term.(exit_status @@ eval_choice default_cmd cmds)
