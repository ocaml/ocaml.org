(* Netlify CMS Configuration *)
open Netlify

let backend = Backend.(make ~name:Github ())

let i18n =
  I18n.Toplevel.make ~structure:`Multiple_files ~locales:[ "en"; "fr" ]
    ~default_locale:"en" ()

let collections =
  [
    Collection.Files
      (Collection.Files.make ~label:"Datasets" ~name:"dataset"
         ~files:[ Data.Papers.file; Data.Meetings.file ]
         ());
    Collection.Folder Data.Tutorial.folder;
  ]

let config =
  Netlify.make ~backend ~i18n ~media_folder:"data/media" ~local_backend:true
    ~collections ()

let print () =
  Netlify.Pp.pp () Fmt.stdout config;
  0

open Cmdliner

let info =
  let doc =
    "Prints the current Netlify CMS configuration file to standard out."
  in
  Term.info ~doc "config"

let term = Term.(pure print $ pure ())

let cmd = (term, info)
