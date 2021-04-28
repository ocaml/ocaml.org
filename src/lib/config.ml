(* Netlify CMS Configuration *)
open Netlify

let backend = Backend.(make ~name:Github ())

let collections =
  [
    Collection.Files
      (Collection.Files.make ~label:"Datasets" ~name:"dataset"
         ~files:[ Data.Papers.file ] ());
  ]

let config =
  Netlify.make ~backend ~media_folder:"data/media" ~local_backend:true
    ~collections ()

let print () =
  Netlify.Pp.pp Fmt.stdout config;
  0

open Cmdliner

let info =
  let doc =
    "Prints the current Netlify CMS configuration file to standard out."
  in
  Term.info ~doc "config"

let term = Term.(pure print $ pure ())

let cmd = (term, info)
