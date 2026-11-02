(* data-attribution: precompute per-document "Authors and history" records from
   git history into data/attribution.jsonl (Phase 1 of #3902). *)

open Cmdliner
open Attribution

let root =
  let doc = "Repository root (passed to git -C)." in
  Arg.(value & opt string Seed.default_config.root & info [ "C"; "root" ] ~doc)

let output =
  let doc = "The JSON Lines attribution store." in
  Arg.(
    value
    & opt string Seed.default_config.output
    & info [ "o"; "output" ] ~docv:"FILE" ~doc)

let docs_roots =
  let doc = "Directory scanned for *.md documents (repeatable)." in
  Arg.(
    value
    & opt_all string Seed.default_config.docs_roots
    & info [ "d"; "docs-root" ] ~docv:"DIR" ~doc)

let min_lines_added =
  let doc =
    "Drop commits adding fewer than N non-whitespace lines (0 = off)."
  in
  Arg.(
    value
    & opt int Seed.default_config.min_lines_added
    & info [ "min-lines-added" ] ~docv:"N" ~doc)

let config root output docs_roots min_lines_added =
  { Seed.root; output; docs_roots; min_lines_added }

let config_t =
  Term.(const config $ root $ output $ docs_roots $ min_lines_added)

let seed_cmd =
  let doc = "Seed every document's record from its full history." in
  Cmd.v (Cmd.info "seed" ~doc) Term.(const Seed.seed $ config_t)

let check_cmd =
  let doc = "Fail if the committed store differs from a fresh recompute." in
  Cmd.v (Cmd.info "check" ~doc)
    Term.(const (fun cfg -> Stdlib.exit (Seed.check cfg)) $ config_t)

let sync_cmd =
  let doc =
    "Bring every record up to date with HEAD (a commit of the default branch): \
     fold each forward, re-stamp it at HEAD, and follow renames and deletions. \
     Run post-merge by the attribution-sync workflow."
  in
  Cmd.v (Cmd.info "sync" ~doc) Term.(const Seed.sync $ config_t)

let main =
  let doc = "Generate ocaml.org per-document attribution records." in
  Cmd.group
    (Cmd.info "data-attribution" ~version:"0.1" ~doc)
    [ seed_cmd; check_cmd; sync_cmd ]

let () = exit (Cmd.eval main)
