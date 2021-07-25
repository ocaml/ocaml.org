open Cmdliner

let term_scrapers = [ ("news", Ood_gen.News.scrape) ]

let cmds =
  List.map
    (fun (term, scraper) -> (Term.(const scraper $ const ()), Term.info term))
    term_scrapers

let default_cmd =
  ( Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())),
    Term.info "ood_scrape" )

let () = Term.(exit @@ eval_choice default_cmd cmds)
