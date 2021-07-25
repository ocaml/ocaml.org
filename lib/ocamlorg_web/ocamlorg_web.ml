(** Entrypoint to OCaml.org' web library. *)
module Handlers = struct
  module Page = Page_handler
  module Package = Package_handler
end

let run () =
  Dream_cli.run ~debug:Config.debug ~interface:"0.0.0.0" ~port:Config.port
  @@ Dream.logger
  @@ Dream.origin_referer_check
  @@ Dream_livereload.inject_script
       ~script:(Dream_livereload.default_script ~max_retry_ms:10000 ())
       ()
  @@ Router.router
  @@ Dream_livereload.router
  @@ Dream.not_found
