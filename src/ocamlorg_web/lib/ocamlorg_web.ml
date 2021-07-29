(** Entrypoint to OCaml.org' web library. *)

module Handler = Handler
module Middleware = Middleware

let run () =
  Dream_cli.run ~debug:Config.debug ~interface:"0.0.0.0" ~port:Config.port
  @@ Dream.logger
  @@ Middleware.no_trailing_slash
  @@ Router.router
  @@ Handler.not_found
