(* doc_modules.exe: the doc-modules tools, for
   .github/workflows/scrape-doc-modules.yml, which downloads this binary from
   the scraper-latest release (built by release-scraper.yml).

   doc_modules.exe policy STATS.jsonl [SUMMARY.md] doc_modules.exe scrape
   OPAM_REPOSITORY STATE_DIR OUTPUT.jsonl doc_modules.exe compile INPUT.jsonl
   OUTPUT.idx

   Every option can also be set by the environment variable named in --help. *)

open Cmdliner
module S = Doc_modules_scraper

let env name = Cmd.Env.info name

let opt c default names ~env:var ~doc =
  Arg.(value & opt c default & info names ~env:(env var) ~doc)

let pos_req i name =
  Arg.(required & pos i (some string) None & info [] ~docv:name)

let exit_with = function
  | Ok msg ->
      print_string msg;
      if msg <> "" && not (String.ends_with ~suffix:"\n" msg) then
        print_newline ();
      0
  | Error msg ->
      prerr_endline msg;
      1

let policy =
  let run stats summary now force batch_gap min_interval max_interval
      min_batches =
    let contents =
      if Sys.file_exists stats then
        In_channel.with_open_bin stats In_channel.input_all
      else ""
    in
    match S.Stats.runs_of_string contents with
    | Error e -> exit_with (Error (stats ^ ": " ^ e))
    | Ok runs ->
        let now =
          match now with Some n -> n | None -> int_of_float (Unix.time ())
        in
        let config =
          { S.Policy.batch_gap; min_interval; max_interval; min_batches }
        in
        let d = S.Policy.decide ~config ~now ~force runs in
        Option.iter
          (fun path ->
            Out_channel.with_open_gen [ Open_append; Open_creat; Open_wronly ]
              0o644 path (fun oc ->
                output_string oc (S.Policy.summary ~now ~force d)))
          summary;
        exit_with (Ok (S.Policy.outputs d))
  in
  let d = S.Policy.default in
  let term =
    Term.(
      const run $ pos_req 0 "STATS.jsonl"
      $ Arg.(value & pos 1 (some string) None & info [] ~docv:"SUMMARY.md")
      $ opt
          Arg.(some int)
          None [ "now" ] ~env:"NOW" ~doc:"The current Unix time (tests)."
      $ Arg.(
          value & flag
          & info [ "force" ] ~env:(Cmd.Env.info "FORCE")
              ~doc:"Make the run due (manual runs).")
      $ opt Arg.int d.batch_gap [ "batch-gap" ] ~env:"BATCH_GAP"
          ~doc:"Seconds between two Last-Modified times that start a new batch."
      $ opt Arg.int d.min_interval [ "min-interval" ] ~env:"MIN_INTERVAL"
          ~doc:"Shortest polling interval, in seconds."
      $ opt Arg.int d.max_interval [ "max-interval" ] ~env:"MAX_INTERVAL"
          ~doc:"Longest polling interval, in seconds."
      $ opt Arg.int d.min_batches [ "min-batches" ] ~env:"MIN_BATCHES"
          ~doc:"Batches to see before learning the interval.")
  in
  Cmd.make
    (Cmd.info "policy"
       ~doc:
         "Print due=, interval= and batches= (for \\$GITHUB_OUTPUT), from the \
          stats of past runs; append a Markdown summary to SUMMARY.md. A \
          missing or empty STATS.jsonl means a first run: due.")
    term

let scrape =
  let run repo state_dir output stats doc_url rate max_time max_errors
      max_losses max_failures_in_a_row baseline retry_days day limit =
    let config =
      {
        S.Scrape.default with
        doc_url;
        rate;
        max_time;
        max_errors;
        max_losses;
        max_failures_in_a_row;
        baseline;
        retry_days;
        day = Option.value day ~default:S.Scrape.default.day;
        limit;
      }
    in
    exit_with (S.Scrape.run ~config ?stats ~repo ~state_dir ~output ())
  in
  let d = S.Scrape.default in
  let term =
    Term.(
      const run
      $ pos_req 0 "OPAM_REPOSITORY"
      $ pos_req 1 "STATE_DIR" $ pos_req 2 "OUTPUT.jsonl"
      $ opt
          Arg.(some string)
          None [ "stats" ] ~env:"SCRAPE_STATS"
          ~doc:
            "Append a JSON record of this run, aborted runs included, to this \
             file."
      $ opt Arg.string d.doc_url [ "doc-url" ] ~env:"OCAMLORG_DOC_URL"
          ~doc:"The documentation backend."
      $ opt Arg.float d.rate [ "rate" ] ~env:"SCRAPE_RATE"
          ~doc:"Requests per second, at most."
      $ opt Arg.float d.max_time [ "max-time" ] ~env:"SCRAPE_MAX_TIME"
          ~doc:"Seconds per request, at most."
      $ opt Arg.int d.max_errors [ "max-errors" ] ~env:"SCRAPE_MAX_ERRORS"
          ~doc:"Abort if more than this percentage of the requests fail."
      $ opt Arg.int d.max_losses [ "max-losses" ] ~env:"SCRAPE_MAX_LOSSES"
          ~doc:
            "Abort if more than this percentage of the packages with docs lose \
             them."
      $ opt Arg.int d.max_failures_in_a_row
          [ "max-failures-in-a-row" ]
          ~env:"SCRAPE_MAX_FAILURES_IN_A_ROW"
          ~doc:"Stop asking and abort once this many packages fail in a row."
      $ opt
          Arg.(some string)
          None [ "baseline" ] ~env:"SCRAPE_BASELINE"
          ~doc:
            "The published index: if STATE_DIR holds no packages with docs, \
             losses are counted against the packages of this index instead. A \
             missing file is ignored; an unreadable one aborts."
      $ opt Arg.int d.retry_days [ "retry-days" ] ~env:"SCRAPE_RETRY_DAYS"
          ~doc:"Ask packages without docs again once every this many days."
      $ opt
          Arg.(some int)
          None [ "day" ] ~env:"SCRAPE_DAY"
          ~doc:"Days since the epoch, for the re-probe schedule (tests)."
      $ opt Arg.int d.limit [ "limit" ] ~env:"SCRAPE_LIMIT"
          ~doc:"Scrape only the first N packages (tests); 0 for all.")
  in
  Cmd.make
    (Cmd.info "scrape"
       ~doc:
         "Scrape the module paths of every package's documentation into \
          OUTPUT.jsonl, keeping the scrape state in STATE_DIR.")
    term

let compile =
  let run input output = exit_with (S.Compile.run ~input ~output) in
  Cmd.make
    (Cmd.info "compile"
       ~doc:"Compile INPUT.jsonl into the memory-mappable index OUTPUT.idx.")
    Term.(const run $ pos_req 0 "INPUT.jsonl" $ pos_req 1 "OUTPUT.idx")

let () =
  exit
    (Cmd.eval'
       (Cmd.group
          (Cmd.info "doc_modules" ~doc:"The doc-modules scraper and its tools.")
          [ policy; scrape; compile ]))
