(* ~~~Netlify CMS Server~~~ This hosts the Netlify CMS JavaScript in order for
   this repo to be able to handle the local_backend beta features in Netlify
   CMS. See the README.md for more details.

   This implementation is inspired by the countless other clients and in
   particular the https://github.com/igk1972/netlify-cms-oauth-provider-go one. *)
open Cohttp_lwt_unix

let src = Logs.Src.create "netlify-local" ~doc:"Serving NetlifyCMS"

module Log = (val Logs.src_log src : Logs.LOG)

let html version =
  Fmt.str
    {|
<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Content Manager</title>
</head>
<body>
  <script src="https://unpkg.com/netlify-cms@^%s/dist/netlify-cms.js"></script>
</body>
</html>
|}
    version

let routes config meth path =
  match meth with
  | `GET -> (
      match path with
      | [ ""; "admin" ] ->
          Server.respond_string
            ~headers:(Cohttp.Header.of_list [ ("Content-type", "text/html") ])
            ~status:`OK ~body:(html "2.10.109") ()
      | [ ""; "config.yml" ] ->
          Server.respond_string
            ~headers:(Cohttp.Header.of_list [ ("Content-type", "text/yaml") ])
            ~status:`OK ~body:config ()
      | _ ->
          print_endline (String.concat "/" path);
          Log.info (fun f ->
              f "Not serving anything from %a" Fmt.(list string) path);
          Server.respond_string ~status:`Not_found
            ~body:"Not Found -- Sad Times :(" () )
  | _ ->
      Log.info (fun f ->
          f "Not serving anything from %a" Fmt.(list string) path);
      Server.respond_string ~status:`Not_found ~body:"Only GET requests please!"
        ()

let server ?(config = "./config.yml") () =
  let config = Bos.OS.File.read (Fpath.v config) |> Rresult.R.get_ok in
  let callback _conn req _ =
    let uri = req |> Request.resource |> String.split_on_char '/' in
    let meth = req |> Request.meth in
    routes config meth uri
  in
  Server.create ~mode:(`TCP (`Port 8080)) (Server.make ~callback ())
