(** Entrypoint to OCaml.org' web library. *)
let v3_ocaml_org = "patricoferris/ocamlorg"

let site_dir = Current.state_dir "v3-ocaml-org"

let schedule = Current_cache.Schedule.v ()

module Handlers = struct
  module Page = Page_handler
  module Package = Package_handler
end

module Middlewares = struct
  let index_html next_handler request =
    let rec is_directory path =
      match path with
      | [""] -> true
      | _::suffix -> is_directory suffix
      | _ -> false
    in
    let path = Dream.path request in
    if is_directory path then begin
      let path = List.filter (fun seg -> String.length seg <> 0) path in 
      Dream.redirect request (Fmt.str "/%s" (String.concat "/" (path @ ["index.html"])))
    end
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

let pipeline handler = 
  let open Current.Syntax in  
  let image = Current_docker.Default.pull ~schedule v3_ocaml_org in 
  let+ () = Docker_copy.copy ~src:(Fpath.v "/data") ~dst:site_dir image in 
  Current_dream.Serve.v ~debug:Config.debug ~interface:"0.0.0.0" ~port:Config.port handler

let serve () =
  let server =
    pipeline 
    @@ Dream.logger
    @@ Dream.origin_referer_check
    @@ Dream_livereload.inject_script ()
    @@ Router.package_router
    @@ Middlewares.index_html
    @@ Router.site_router (Fpath.to_string site_dir)
    @@ Dream_livereload.router
    @@ Dream.not_found
  in 
  Current_dream.serve server

let run () = 
  let engine = Current.Engine.create serve in
  let routes = Current_web.routes engine in
  let site =
    Current_web.Site.v ~name:"ocaml.org pipeline" ~has_role:(fun _ _ -> true) routes
  in
  Lwt_main.run
    ( Lwt.choose
        [
          Current.Engine.thread engine;
          Current_web.run ~mode:(`TCP (`Port 8081)) site;
        ] )