(** Entrypoint to OCaml.org' web library. *)

module Handlers = struct
  module Page = Page_handler
  module Package = Package_handler
end

module Middlewares = struct
  let redirect_index_html handler req =
    let index_length = String.length "/index.html" in
    match Dream.target req with
    | s when String.length s < index_length ->
      handler req
    | s
      when String.sub s (String.length s - index_length) index_length
           = "/index.html" ->
      Dream.redirect req (String.sub s 0 (String.length s - index_length + 1))
    | _ ->
      handler req
end

let run () =
  Dream_cli.run ~debug:Config.debug ~interface:"0.0.0.0" ~port:Config.port
  @@ Dream.logger
  @@ Dream.origin_referer_check
  @@ Dream_livereload.inject_script ()
  @@ Middlewares.redirect_index_html
  @@ Router.router
  @@ Dream_livereload.router
  @@ Dream.not_found
