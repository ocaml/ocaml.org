open Cmdliner
open Lib_ood

let cmds = [ Lint.cmd; Config.cmd; Server.cmd ]

let doc = "Explore OCaml CLI tool"

let main = (Term.ret @@ Term.pure (`Help (`Pager, None)), Term.info "ood" ~doc)

let main () =
  Fmt_tty.setup_std_outputs ();
  Logs.set_reporter (Logs_fmt.reporter ());
  Term.(exit_status @@ eval_choice main cmds)

let () = main ()
