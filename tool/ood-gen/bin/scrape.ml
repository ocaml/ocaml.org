open Cmdliner

let term_scrapers = [ ("rss", Ood_gen.Rss.scrape) ]

let cmds =
  List.map
    (fun (term, scraper) -> (Term.(const scraper $ const ()), Term.info term))
    term_scrapers

let default_cmd =
  ( Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())),
    Term.info "ood_scrape" )

let () =
  Printexc.record_backtrace true;
  Term.(exit @@ eval_choice default_cmd cmds)
