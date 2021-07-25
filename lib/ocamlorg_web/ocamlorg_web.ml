(** Entrypoint to OCaml.org' web library. *)
module Oop = Ocamlorg_pipeline

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
  let pipeline = Oop.init Config.github_oauth_token in
  let server =
    Dream.serve ~debug:Config.debug ~interface:"0.0.0.0" ~port:Config.port
    @@ Dream.logger
    @@ Dream.origin_referer_check
    @@ Dream_livereload.inject_script ()
    @@ Router.package_router
    @@ Middlewares.index_html
    @@ Router.site_router (Fpath.to_string @@ Oop.site_dir pipeline)
    @@ Dream_livereload.router
    @@ Dream.not_found
  in
  Lwt_main.run
  @@ Lwt.choose [ Lwt_result.ok server; Ocamlorg_pipeline.v pipeline ]