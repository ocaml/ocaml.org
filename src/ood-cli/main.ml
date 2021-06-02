open Cmdliner

let cmds = [ Lint.cmd; Config.cmd; Server.cmd; Time.cmd ]

let doc = "OCaml.org Data CLI Tool"

let main = (Term.ret @@ Term.pure (`Help (`Pager, None)), Term.info "ood" ~doc)

let main () =
  Fmt_tty.setup_std_outputs ();
  Logs.set_reporter (Logs_fmt.reporter ());
  Term.(exit_status @@ eval_choice main cmds)

let () = main ()
