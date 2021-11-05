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

let letsencrypt_router =
  Dream.router [ Dream.get "/.well-known/acme-challenge/**" Le.dispatch ]

(* HTTP Redirect server *)
let http () =
  let http_response req =
    let target = Dream.target req in
    let uri = Uri.of_string ("http://" ^ Config.hostname ^ target) in
    let new_uri = Uri.with_scheme uri (Some "https") in
    let new_uri = Uri.with_port new_uri (Some Config.https_port) in
    Dream.redirect ~status:`Moved_Permanently req (Uri.to_string new_uri)
  in
  Dream.serve ~port:Config.http_port
  @@ Dream.logger
  @@ letsencrypt_router
  @@ http_response

let write_to_file s f =
  let oc = open_out f in
  output_string oc s;
  close_out oc

let save_certificate_files
    (certificate : X509.Certificate.t list) (private_key : X509.Private_key.t)
  =
  X509.Certificate.encode_pem_multiple certificate
  |> Cstruct.to_string
  |> write_to_file Config.certificate_file_path;
  X509.Private_key.encode_pem private_key
  |> Cstruct.to_string
  |> write_to_file Config.private_key_file_path

let serialize_certificates_or_load () =
  if
    Sys.file_exists Config.certificate_file_path
    && Sys.file_exists Config.private_key_file_path
  then (* TODO(tmattio): Make sure the certificates are valid *)
    Lwt.return (Config.certificate_file_path, Config.private_key_file_path)
  else
    let open Lwt.Syntax in
    let+ certificates, private_key =
      let email = None in
      let seed = None in
      let cert_seed = None in
      let hostname = Config.hostname in
      let+ certs_result =
        Le.provision_certificate ?email ?seed ?cert_seed ~hostname ()
      in
      match certs_result with
      | Ok (`Single x) ->
        x
      | Error (`Msg err) ->
        failwith
          (Printf.sprintf
             "Could not get the certificate from letsencrypt %s"
             err)
    in
    save_certificate_files certificates private_key;
    Config.certificate_file_path, Config.private_key_file_path

(* HTTPS Server *)
let server https port =
  let open Lwt.Syntax in
  let state = Ocamlorg.Package.init () in
  if Config.hostname = "localhost" then
    (* Use Dream's development certificate if we are running the server
       locally. *)
    Dream.serve ~https ~debug:Config.debug ~interface:"0.0.0.0" ~port
    @@ Dream.logger
    @@ Middleware.no_trailing_slash
    @@ Router.router state
    @@ Page_handler.not_found
  else
    (* Fetch the certificate from the filesystem (or from letsencrypt) if we are
       not running locally. *)
    let* certificate_file, key_file = serialize_certificates_or_load () in
    Dream.serve
      ~https
      ~debug:Config.debug
      ~interface:"0.0.0.0"
      ~port
      ~certificate_file
      ~key_file
    @@ Dream.logger
    @@ Middleware.no_trailing_slash
    @@ Router.router state
    @@ Page_handler.not_found

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
