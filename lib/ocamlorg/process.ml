open Lwt.Infix

let pp_args =
  let sep = Fmt.(const string) " " in
  Fmt.(array ~sep (quote string))

let pp_cmd f = function
  | "", args ->
    pp_args f args
  | bin, args ->
    Fmt.pf f "(%S, %a)" bin pp_args args

let pp_signal f x =
  let open Sys in
  if x = sigkill then
    Fmt.string f "kill"
  else if x = sigterm then
    Fmt.string f "term"
  else
    Fmt.int f x

let pp_status f = function
  | Unix.WEXITED x ->
    Fmt.pf f "exited with status %d" x
  | Unix.WSIGNALED x ->
    Fmt.pf f "failed with signal %d" x
  | Unix.WSTOPPED x ->
    Fmt.pf f "stopped with signal %d" x

let check_status cmd = function
  | Unix.WEXITED 0 ->
    ()
  | status ->
    Fmt.failwith "%a %a" pp_cmd cmd pp_status status

let exec cmd =
  let proc = Lwt_process.open_process_none cmd in
  proc#status >|= check_status cmd

let pread cmd =
  let proc = Lwt_process.open_process_in cmd in
  Lwt_io.read proc#stdout >>= fun output ->
  proc#status >|= check_status cmd >|= fun () -> output
