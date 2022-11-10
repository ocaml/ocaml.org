open Cmdliner

let term_scrapers =
  [ ("rss", Ood_gen.Rss.scrape); ("governance", Ood_gen.Governance.scrape) ]

let cmds =
  Cmd.group (Cmd.info "ood-scrape")
  @@ List.map
       (fun (term, scraper) ->
         Cmd.v (Cmd.info term) Term.(const scraper $ const ()))
       term_scrapers

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
