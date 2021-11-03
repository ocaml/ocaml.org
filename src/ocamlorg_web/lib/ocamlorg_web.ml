(** Entrypoint to OCaml.org' web library. *)
module Handler = Handler

module Graphql = Graphql

(* Set up basic logging for logs that would happen before Dream is set up. *)
let () =
  Logs.set_reporter (Logs.format_reporter ());
  Logs.set_level (Some Info)

(* Copied from dream's `Dream.run` *)
let run ~interface ~port f =
  let () =
    if Sys.unix then
      Sys.(set_signal sigpipe Signal_ignore)
  in
  let adjust_terminal = Sys.os_type <> "Win32" && Unix.(isatty stderr) in
  let restore_terminal =
    if adjust_terminal then (
      (* The mystery terminal escape sequence is $(tput rmam). Prefer this,
         hopefully it is portable enough. Calling tput seems like a security
         risk, and I am not aware of an API for doing this programmatically. *)
      prerr_string "\x1b[?7l";
      flush stderr;
      let attributes = Unix.(tcgetattr stderr) in
      attributes.c_echo <- false;
      Unix.(tcsetattr stderr TCSANOW) attributes;
      fun () ->
        (* The escape sequence is $(tput smam). *)
        prerr_string "\x1b[?7h";
        flush stderr)
    else
      ignore
  in
  let create_handler signal =
    let previous_signal_behavior = ref Sys.Signal_default in
    previous_signal_behavior :=
      Sys.signal signal
      @@ Sys.Signal_handle
           (fun signal ->
             restore_terminal ();
             match !previous_signal_behavior with
             | Sys.Signal_handle f ->
               f signal
             | Sys.Signal_ignore ->
               ignore ()
             | Sys.Signal_default ->
               Sys.set_signal signal Sys.Signal_default;
               Unix.kill (Unix.getpid ()) signal)
  in
  create_handler Sys.sigint;
  create_handler Sys.sigterm;
  let log = Dream__middleware.Log.convenience_log in
  let scheme =
    if Config.https_enabled then
      "https"
    else
      "http"
  in
  (match interface with
  | "localhost" | "127.0.0.1" ->
    log "Running at %s://localhost:%i" scheme port
  | _ ->
    log "Running on %s:%i (%s://localhost:%i)" interface port scheme port);
  log "Type Ctrl+C to stop";
  try
    Lwt_main.run f;
    restore_terminal ()
  with
  | exn ->
    restore_terminal ();
    raise exn

(* HTTP Redirect server *)
let http () =
  let http_response req =
    let uri = Uri.of_string ("http://" ^ Config.hostname) in
    let new_uri = Uri.with_scheme uri (Some "https") in
    let new_uri = Uri.with_port new_uri (Some Config.https_port) in
    Dream.redirect ~status:`Moved_Permanently req (Uri.to_string new_uri)
  in
  Dream.serve ~port:Config.http_port @@ Dream.logger @@ http_response

(* HTTPS Server *)
let server https port =
  let state = Ocamlorg.Package.init () in
  Dream.serve ~https ~debug:Config.debug ~interface:"0.0.0.0" ~port
  @@ Dream.logger
  @@ Middleware.no_trailing_slash
  @@ Router.router state
  @@ Handler.not_found

let run () =
  let port =
    if Config.https_enabled then Config.https_port else Config.http_port
  in
  run ~interface:"0.0.0.0" ~port
  @@
  if Config.https_enabled then
    Lwt.choose [ http (); server Config.https_enabled port ]
  else
    server Config.https_enabled port
