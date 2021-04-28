open Cmdliner
open Lib_ood

let cmds = [ Lint.cmd; Config.cmd ]

let setup_std_outputs : unit = Fmt_tty.setup_std_outputs ()

let doc = "Explore OCaml CLI tool"

let main = (Term.ret @@ Term.pure (`Help (`Pager, None)), Term.info "ood" ~doc)

let main () = Term.(exit_status @@ eval_choice main cmds)

let () = main ()
