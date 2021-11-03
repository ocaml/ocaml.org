(** Entrypoint to OCaml.org' web library. *)
module Handlers = struct
  module Page = Page_handler
  module Package = Package_handler
end

module Graphql = Graphql

(* Set up basic logging for logs that would happen before Dream is set up. *)
let () =
  Logs.set_reporter (Logs.format_reporter ());
  Logs.set_level (Some Info)

let run () =
  let state = Ocamlorg.Package.init () in
  Dream_cli.run ~debug:Config.debug ~interface:"0.0.0.0" ~port:Config.port
  @@ Dream.logger
  @@ Middleware.no_trailing_slash
  @@ Router.router state
  @@ Page_handler.not_found
