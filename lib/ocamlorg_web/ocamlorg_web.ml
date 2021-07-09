(** Entrypoint to OCaml.org' web library. *)

module Handlers = struct
  module Page = Page_handler
  module Package = Package_handler
end

let run () =
  Dream_cli.run ~debug:Config.debug
  @@ Dream.logger
  @@ Dream_livereload.inject_script ()
  @@ Router.router
  @@ Dream_livereload.router
  @@ Dream.not_found
