module Handler = Handler
(** Entrypoint to OCaml.org' web library. *)

module Graphql = Graphql

(* Set up basic logging for logs that would happen before Dream is set up. *)
let () =
  Logs.set_reporter (Logs.format_reporter ());
  Logs.set_level (Some Info)

let run () =
  Mirage_crypto_rng_lwt.initialize (module Mirage_crypto_rng.Fortuna);
  let state = Ocamlorg_package.init () in
  try
    Dream.run ~interface:"0.0.0.0" ~port:Config.http_port
    @@ Dream.logger @@ Middleware.no_trailing_slash @@ Middleware.versioning @@ Middleware.head
    @@ Router.router state
  with
  | Unix.Unix_error (err, fn, _) ->
      Format.eprintf "%S failed: %s@." fn (Unix.error_message err);
      (match err with
      | EADDRINUSE ->
          Format.eprintf
            "Hint: Try changing the value of the environment variable \
             OCAMLORG_HTTP_PORT@."
      | _ -> ());
      exit 2
  | exn ->
      Format.eprintf "%s" (Printexc.to_string exn);
      exit 2
