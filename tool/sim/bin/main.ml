(* sim: accelerated, instrumented simulation of the ocaml.org server. See
   tool/sim/README.md. *)

open Cmdliner
open Sim

let duration =
  let parse s =
    let num, mult =
      match s.[String.length s - 1] with
      | 's' -> (String.sub s 0 (String.length s - 1), 1.)
      | 'm' -> (String.sub s 0 (String.length s - 1), 60.)
      | 'h' -> (String.sub s 0 (String.length s - 1), 3600.)
      | _ -> (s, 1.)
      | exception Invalid_argument _ -> (s, 1.)
    in
    match float_of_string_opt num with
    | Some x when x > 0. -> Ok (x *. mult)
    | _ -> Error (`Msg ("invalid duration: " ^ s))
  in
  Arg.conv (parse, fun ppf d -> Format.fprintf ppf "%gs" d)

let default_out () =
  let t = Unix.gmtime (Unix.gettimeofday ()) in
  Printf.sprintf "tool/sim/out/%04d%02d%02d-%02d%02d%02d" (t.tm_year + 1900)
    (t.tm_mon + 1) t.tm_mday t.tm_hour t.tm_min t.tm_sec

let plot ~script dir =
  let _ = Summary.run dir in
  let status =
    Unix.system
      (Filename.quote_command "gnuplot"
         [ "-e"; Printf.sprintf "dir='%s'" dir; script ])
  in
  match status with
  | Unix.WEXITED 0 -> Printf.printf "sim: wrote %s/timeline.svg\n" dir
  | _ -> prerr_endline "sim: gnuplot failed"

let plot_script =
  Arg.(
    value
    & opt string "tool/sim/plot.gp"
    & info [ "plot-script" ] ~docv:"FILE" ~doc:"gnuplot script.")

let run_cmd =
  let image =
    Arg.(
      required
      & opt (some string) None
      & info [ "image" ] ~docv:"IMAGE"
          ~doc:
            "Server image to simulate (built from the repository Dockerfile).")
  in
  let days =
    Arg.(
      value & opt float 7.
      & info [ "history-days" ] ~docv:"DAYS"
          ~doc:
            "Replay the last $(docv) days of opam-repository history in the \
             image.")
  in
  let speedup =
    Arg.(
      value & opt float 120.
      & info [ "speedup" ] ~docv:"X"
          ~doc:
            "Replay opam-repository history $(docv) times faster than it \
             happened.")
  in
  let poll =
    Arg.(
      value
      & opt (some int) None
      & info [ "poll" ] ~docv:"SECONDS"
          ~doc:
            "Server polling interval (OCAMLORG_OPAM_POLLING). Defaults to the \
             production 3600s divided by the speedup.")
  in
  let duration_a =
    Arg.(
      value & opt duration 900.
      & info [ "duration" ] ~docv:"TIME" ~doc:"Run length, e.g. 900, 15m, 2h.")
  in
  let port =
    Arg.(
      value & opt int 18080 & info [ "port" ] ~doc:"Host port of the server.")
  in
  let mem =
    Arg.(
      value & opt string "7g"
      & info [ "mem" ]
          ~doc:
            "Container memory limit (production runs two servers on a 15.5 GB \
             host).")
  in
  let cpus =
    Arg.(
      value & opt string "0"
      & info [ "cpus" ] ~doc:"Container CPU limit; 0 means no limit.")
  in
  let profile =
    Arg.(
      value
      & opt (some file) (Some "tool/sim/profiles/sample.json")
      & info [ "profile" ] ~docv:"FILE" ~doc:"Human traffic profile (JSON).")
  in
  let no_traffic =
    Arg.(value & flag & info [ "no-human" ] ~doc:"Send no human traffic.")
  in
  let scale =
    Arg.(
      value & opt float 1.
      & info [ "traffic-scale" ] ~docv:"X"
          ~doc:"Multiply the profile's request rate by $(docv).")
  in
  let diurnal =
    Arg.(
      value
      & opt
          (enum
             [
               ("compressed", Run.Compressed);
               ("wall", Run.Wall);
               ("off", Run.Off);
             ])
          Run.Compressed
      & info [ "diurnal" ]
          ~doc:
            "Which clock picks the hour of the profile's daily curve: \
             $(b,compressed) (the replayed history's), $(b,wall), or $(b,off).")
  in
  let bot_rps =
    Arg.(
      value & opt float 2.
      & info [ "bot-rps" ] ~docv:"RPS"
          ~doc:
            "Rate of the synthetic crawler sweeping package pages; 0 disables \
             it.")
  in
  let include_docs =
    Arg.(
      value & flag
      & info [ "include-docs" ]
          ~doc:
            "Let the crawler request package documentation pages too (served \
             from the external docs server).")
  in
  let max_inflight =
    Arg.(
      value & opt int 256
      & info [ "max-inflight" ]
          ~doc:"Outstanding requests before new ones are dropped.")
  in
  let timeout =
    Arg.(
      value & opt float 30.
      & info [ "timeout" ] ~doc:"Request timeout, seconds.")
  in
  let seed = Arg.(value & opt int 42 & info [ "seed" ] ~doc:"Random seed.") in
  let docs =
    Arg.(
      value
      & opt (enum [ ("stub", Run.Stub); ("real", Run.Real) ]) Run.Stub
      & info [ "docs" ]
          ~doc:
            "Documentation server for package pages: $(b,stub), a local \
             responder that answers 404 (no documentation) to everything, or \
             $(b,real), the external server used in production.")
  in
  let docs_port =
    Arg.(
      value & opt int 18081
      & info [ "docs-port" ] ~doc:"Host port of the docs stub.")
  in
  let state_builder =
    Arg.(
      value
      & opt (some int) None
      & info [ "state-builder" ] ~docv:"NICE"
          ~doc:
            "Experimental: rebuild the package state in a separate builder \
             process, run at nice level $(docv), and have the server only load \
             each new state file it writes. Needs a server that supports \
             OCAMLORG_PKG_STATE_MODE=builder and =reload, which main does not \
             yet.")
  in
  let keep =
    Arg.(
      value & flag
      & info [ "keep" ] ~doc:"Leave the container running at the end.")
  in
  let repeat =
    Arg.(
      value & opt int 1
      & info [ "repeat" ] ~docv:"N"
          ~doc:
            "Run the same simulation $(docv) times (same seed: same requests \
             and upstream moves) into OUT/run-1 ... OUT/run-$(docv), then \
             write the run-to-run noise to OUT/noise.json and OUT/noise.txt.")
  in
  let out =
    Arg.(
      value
      & opt (some string) None
      & info [ "out" ] ~docv:"DIR"
          ~doc:"Run directory (default tool/sim/out/<time>).")
  in
  let compose =
    Arg.(
      value
      & opt file "tool/sim/compose.yaml"
      & info [ "compose" ] ~docv:"FILE" ~doc:"Compose file.")
  in
  let project =
    Arg.(
      value & opt string "ocamlorg-sim"
      & info [ "project" ] ~doc:"Compose project name.")
  in
  let go image days speedup poll duration port mem cpus profile no_human
      traffic_scale diurnal bot_rps include_docs max_inflight timeout seed keep
      out compose project script docs docs_port state_builder repeat =
    let out = match out with Some o -> o | None -> default_out () in
    let poll =
      match poll with
      | Some p -> p
      | None -> max 1 (int_of_float (Float.round (3600. /. speedup)))
    in
    let profile = if no_human then None else Option.map Profile.load profile in
    let c =
      {
        Run.image;
        compose;
        project;
        out;
        days;
        speedup;
        poll;
        duration;
        port;
        mem;
        cpus;
        profile;
        traffic_scale;
        diurnal;
        bot_rps;
        include_docs;
        max_inflight;
        timeout;
        seed;
        keep;
        docs;
        docs_port;
        state_builder;
      }
    in
    if repeat <= 1 then (
      Lwt_main.run (Run.run c);
      print_string (Summary.run out);
      plot ~script out)
    else
      let dirs =
        List.init repeat (fun k ->
            let dir = Filename.concat out (Printf.sprintf "run-%d" (k + 1)) in
            Printf.printf "sim: repeat %d of %d -> %s\n%!" (k + 1) repeat dir;
            Lwt_main.run (Run.run { c with Run.out = dir });
            ignore (Summary.run dir);
            plot ~script dir;
            dir)
      in
      print_string (Noise.run ~out dirs)
  in
  Cmd.v
    (Cmd.info "run" ~doc:"Run one simulation.")
    Term.(
      const go $ image $ days $ speedup $ poll $ duration_a $ port $ mem $ cpus
      $ profile $ no_traffic $ scale $ diurnal $ bot_rps $ include_docs
      $ max_inflight $ timeout $ seed $ keep $ out $ compose $ project
      $ plot_script $ docs $ docs_port $ state_builder $ repeat)

let dir_arg =
  Arg.(
    required & pos 0 (some dir) None & info [] ~docv:"DIR" ~doc:"Run directory.")

let summary_cmd =
  Cmd.v
    (Cmd.info "summary" ~doc:"Recompute and print the summary of a run.")
    Term.(const (fun d -> print_string (Summary.run d)) $ dir_arg)

let plot_cmd =
  Cmd.v
    (Cmd.info "plot" ~doc:"Plot a run's timeline (needs gnuplot).")
    Term.(const (fun script d -> plot ~script d) $ plot_script $ dir_arg)

let output =
  Arg.(
    required
    & opt (some string) None
    & info [ "o"; "output" ] ~docv:"FILE" ~doc:"Profile to write.")

let plausible_cmd =
  let base =
    Arg.(
      value
      & opt string "https://plausible.ci.dev"
      & info [ "base" ] ~doc:"Plausible instance.")
  in
  let site =
    Arg.(value & opt string "ocaml.org" & info [ "site" ] ~doc:"Site id.")
  in
  let period =
    Arg.(
      value & opt string "30d"
      & info [ "period" ] ~doc:"Date range, e.g. 7d, 30d.")
  in
  let limit =
    Arg.(
      value & opt int 500 & info [ "limit" ] ~doc:"Number of top pages to keep.")
  in
  let utc_offset =
    Arg.(
      value & opt int 0
      & info [ "utc-offset" ] ~docv:"HOURS"
          ~doc:
            "Offset from UTC, in hours, of the site's reporting timezone in \
             Plausible (e.g. 1 for Europe/Paris in winter, 2 in summer). \
             Plausible reports hours in that timezone; profiles are in UTC.")
  in
  let go base site period limit utc_offset output =
    match Sys.getenv_opt "OCAMLORG_PLAUSIBLE_KEY" with
    | None | Some "" ->
        prerr_endline
          "sim: set OCAMLORG_PLAUSIBLE_KEY to a Plausible Stats API key";
        exit 2
    | Some key ->
        let p =
          Lwt_main.run
            (Plausible.fetch ~utc_offset ~base ~key ~site ~period ~limit ())
        in
        Profile.save output p;
        Printf.printf "sim: %s: %.3f pages/s, %d pages\n" output p.base_rps
          (Array.length p.pages)
  in
  Cmd.v
    (Cmd.info "plausible"
       ~doc:"Build a profile from Plausible (key in OCAMLORG_PLAUSIBLE_KEY).")
    Term.(const go $ base $ site $ period $ limit $ utc_offset $ output)

let access_log_cmd =
  let files =
    Arg.(non_empty & pos_all file [] & info [] ~docv:"LOG" ~doc:"Access logs.")
  in
  let go files output =
    let lines =
      List.to_seq files
      |> Seq.concat_map (fun f ->
             let ic = open_in f in
             Seq.of_dispenser (fun () ->
                 match input_line ic with
                 | l -> Some l
                 | exception End_of_file ->
                     close_in ic;
                     None))
    in
    let p =
      Access_log.profile ~source:("access-log:" ^ String.concat "+" files) lines
    in
    Profile.save output p;
    Printf.printf "sim: %s: %.3f requests/s, %d pages\n" output p.base_rps
      (Array.length p.pages)
  in
  Cmd.v
    (Cmd.info "access-log"
       ~doc:"Build a profile from Common/Combined Log Format files.")
    Term.(const go $ files $ output)

(* Used by [Gc_events.clock_offset]; see there. *)
let clock_offset_cmd =
  Cmd.v
    (Cmd.info "clock-offset" ~doc:"Print wall minus monotonic clock (internal)."
       ~docs:"INTERNAL")
    Term.(
      const (fun () -> Printf.printf "%.9f\n" (Gc_events.measure_offset ()))
      $ const ())

let compare_cmd =
  let dir n doc = Arg.(required & pos n (some dir) None & info [] ~docv:doc) in
  let output =
    Arg.(
      value
      & opt (some string) None
      & info [ "o"; "output" ] ~docv:"FILE"
          ~doc:"Also write the comparison as JSON.")
  in
  let noise =
    Arg.(
      value & opt_all file []
      & info [ "noise" ] ~docv:"FILE"
          ~doc:
            "A noise.json from $(b,sim run --repeat) (repeatable, e.g. one per \
             image): mark the differences larger than run-to-run noise.")
  in
  Cmd.v
    (Cmd.info "compare"
       ~doc:
         "Compare two runs (A, then B): every summary number side by side, and \
          latency paired request by request.")
    Term.(
      const (fun a b output noise ->
          print_string (Compare.run ?output ~noise a b))
      $ dir 0 "A" $ dir 1 "B" $ output $ noise)

let viz_cmd =
  let dir n doc = Arg.(required & pos n (some dir) None & info [] ~docv:doc) in
  let output =
    Arg.(
      required
      & opt (some string) None
      & info [ "o"; "output" ] ~docv:"FILE" ~doc:"HTML page to write.")
  in
  Cmd.v
    (Cmd.info "viz"
       ~doc:
         "Write an HTML page comparing two runs (A, then B): inputs once, raw \
          output per metric, then comparison charts.")
    Term.(
      const (fun a b output noise -> print_string (Viz.run ~noise ~output a b))
      $ dir 0 "A" $ dir 1 "B" $ output
      $ Arg.(
          value & opt_all file []
          & info [ "noise" ] ~docv:"FILE"
              ~doc:
                "A noise.json from $(b,sim run --repeat) (repeatable): draw \
                 the noise band in the ratio chart and the repeats in the \
                 distributions."))

let noise_cmd =
  let dirs =
    Arg.(
      non_empty & pos_all dir []
      & info [] ~docv:"DIR" ~doc:"Repeats of one simulation.")
  in
  let out =
    Arg.(
      value & opt dir "."
      & info [ "o"; "output-dir" ] ~docv:"DIR"
          ~doc:"Where to write noise.json and noise.txt.")
  in
  Cmd.v
    (Cmd.info "noise"
       ~doc:"Run-to-run noise across existing repeats of one simulation.")
    Term.(
      const (fun out dirs -> print_string (Noise.run ~out dirs)) $ out $ dirs)

let profile_cmd =
  Cmd.group
    (Cmd.info "profile" ~doc:"Build traffic profiles.")
    [ plausible_cmd; access_log_cmd ]

let () =
  exit
    (Cmd.eval
       (Cmd.group
          (Cmd.info "sim"
             ~doc:"Simulate the ocaml.org server, faster than real time.")
          [
            run_cmd;
            summary_cmd;
            plot_cmd;
            compare_cmd;
            viz_cmd;
            noise_cmd;
            profile_cmd;
            clock_offset_cmd;
          ]))
