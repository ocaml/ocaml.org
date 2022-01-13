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
  let redirect_handler req =
    let target = Dream.target req in
    let uri = Uri.of_string ("http://" ^ Config.hostname ^ target) in
    let new_uri = Uri.with_scheme uri (Some "https") in
    let new_uri = Uri.with_port new_uri (Some Config.https_port) in
    Dream.redirect ~status:`Moved_Permanently req (Uri.to_string new_uri)
  in
  Dream.serve ~interface:"0.0.0.0" ~debug:Config.debug ~port:Config.http_port
  @@ Dream.logger
  @@ Le.router
  @@ redirect_handler

(* HTTPS Server *)
let server https port =
  let open Lwt.Syntax in
  let state = Ocamlorg_package.init () in
  if not https then
    Dream.serve ~interface:"0.0.0.0" ~debug:Config.debug ~port:Config.http_port
    @@ Dream.logger
    @@ Router.router state
    @@ Handler.not_found
  else if Config.hostname = "localhost" then
    (* Use Dream's development certificate if we are running the server
       locally. *)
    Dream.serve
      ~https:true
      ~interface:"0.0.0.0"
      ~debug:Config.debug
      ~port:Config.http_port
    @@ Dream.logger
    @@ Router.router state
    @@ Handler.not_found
  else
    (* Fetch the certificate from the filesystem (or from letsencrypt) if we are
       not running locally. *)
    let* certificate_file, key_file =
      Le.load_certificates
        ~certificate_file_path:Config.certificate_file_path
        ~private_key_file_path:Config.private_key_file_path
        ~hostname:Config.hostname
        ~staging:Config.letsencrypt_staging
        ()
    in
    Dream.serve
      ~https
      ~debug:Config.debug
      ~interface:"0.0.0.0"
      ~port
      ~certificate_file
      ~key_file
    @@ Dream.logger
    @@ Router.router state
    @@ Handler.not_found

let run () =
  Mirage_crypto_rng_lwt.initialize ();
  let port =
    if Config.https_enabled then Config.https_port else Config.http_port
  in
  run ~interface:"0.0.0.0" ~port
  @@
  if Config.https_enabled then
    Lwt.choose [ http (); server Config.https_enabled port ]
  else
    server Config.https_enabled port
