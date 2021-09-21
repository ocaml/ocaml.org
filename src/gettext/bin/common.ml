open Cmdliner

module Syntax = struct
  let ( let+ ) t f = Term.(const f $ t)

  let ( and+ ) a b = Term.(const (fun x y -> x, y) $ a $ b)
end

open Syntax

let envs = []

let term =
  let+ log_level =
    let env = Arg.env_var "GETTEXT_VERBOSITY" in
    Logs_cli.level ~docs:Manpage.s_common_options ~env ()
  in
  Fmt_tty.setup_std_outputs ();
  Logs.set_level log_level;
  Logs.set_reporter (Logs_fmt.reporter ~app:Fmt.stdout ());
  0

let exits = Term.default_exits
