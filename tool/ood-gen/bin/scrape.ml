open Cmdliner

let term_scrapers =
  [
    ("planet", Ood_gen.Planet.Scraper.scrape);
    ("youtube", Ood_gen.Youtube.scrape);
  ]

let cmds =
  Cmd.group (Cmd.info "ood-scrape")
  @@ List.map
       (fun (term, scraper) ->
         Cmd.v (Cmd.info term) Term.(const scraper $ const ()))
       term_scrapers

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
