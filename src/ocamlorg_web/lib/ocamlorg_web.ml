module Handler = Handler
(** Entrypoint to OCaml.org' web library. *)

module Graphql = Graphql

(* Set up basic logging for logs that would happen before Dream is set up. *)
let () =
  Logs.set_reporter (Logs.format_reporter ());
  Logs.set_level (Some Info)

(* Set up basic error template for internal error *)
let error_template _error _debug_info suggested_response =
  let body = Ocamlorg_frontend.internal_error () in
  Dream.set_header suggested_response "Content-Type" Dream.text_html;
  Dream.set_body suggested_response body;
  Lwt.return suggested_response

let run () =
  Mirage_crypto_rng_lwt.initialize ();
  let state = Ocamlorg_package.init () in
  Dream.run ~interface:"0.0.0.0" ~port:Config.http_port
    ~error_handler:(Dream.error_template error_template)
  @@ Dream.logger @@ Middleware.no_trailing_slash @@ Middleware.head
  @@ Router.router state
