(** Entrypoint to OCaml.org' web library. *)
module Handlers = struct
  module Page = Page_handler
  module Package = Package_handler
end

module Middlewares = struct
  let index_html next_handler request =
    let rec is_directory path =
      match path with
      | [ "" ] ->
        true
      | _ :: suffix ->
        is_directory suffix
      | _ ->
        false
    in
    let path = Dream.path request in
    if is_directory path then
      let path = List.filter (fun seg -> String.length seg <> 0) path in
      Dream.redirect
        request
        (Fmt.str "/%s" (String.concat "/" (path @ [ "index.html" ])))
    else
      next_handler request
end

let run () =
  Dream_cli.run ~debug:Config.debug ~interface:"0.0.0.0" ~port:Config.port
  @@ Dream.logger
  @@ Dream.origin_referer_check
  @@ Dream_livereload.inject_script
       ~script:(Dream_livereload.default_script ~max_retry_ms:10000 ())
       ()
  @@ Middlewares.index_html
  @@ Router.router
  @@ Dream_livereload.router
  @@ Dream.not_found
