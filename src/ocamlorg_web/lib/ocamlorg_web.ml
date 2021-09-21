(** Entrypoint to OCaml.org' web library. *)
module Handlers = struct
  module Page = Page_handler
  module Package = Package_handler
end

module Graphql = Graphql

let run () =
  let state = Ocamlorg.Package.init () in
  Dream_cli.run ~debug:Config.debug ~interface:"0.0.0.0" ~port:Config.port
  @@ Dream.logger
  @@ Router.router state
  @@ Page_handler.not_found
