open Netlify

let server () =
  Lwt_main.run (Server.server ());
  0

open Cmdliner

let info =
  let doc = "Simple Cohttp server for local development using Netlify CMS." in
  Term.info ~doc "serve"

let term = Term.(pure server $ pure ())

let cmd = (term, info)
