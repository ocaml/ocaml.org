(* Reporter borrowed from https://github.com/mirage/prometheus and changed to be
   more dreamy *)
let pp_timestamp f x =
  let open Unix in
  let tm = localtime x in
  let pf f tm =
    Fmt.pf
      f
      "%04d.%02d.%02d %02d:%02d.%02d"
      (tm.tm_year + 1900)
      (tm.tm_mon + 1)
      tm.tm_mday
      tm.tm_hour
      tm.tm_min
      tm.tm_sec
  in
  Fmt.pf f "%a" (Fmt.styled `Faint pf) tm

let reporter =
  let report src level ~over k msgf =
    let src = Logs.Src.name src in
    let k _ =
      over ();
      k ()
    in
    msgf @@ fun ?header ?tags:_ fmt ->
    Fmt.kpf
      k
      Fmt.stderr
      ("%a %a %a @[" ^^ fmt ^^ "@]@.")
      pp_timestamp
      (Unix.gettimeofday ())
      Fmt.(styled `White string)
      (Printf.sprintf "%14s" src)
      Logs_fmt.pp_header
      (level, header)
  in
  { Logs.report }

let init () =
  Fmt_tty.setup_std_outputs ();
  Logs.set_reporter reporter;
  Logs.set_level (Some Logs.Info)
