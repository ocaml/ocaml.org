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

let update_cmd =
  let paths =
    let doc = "Document paths to recompute (relative to the root)." in
    Arg.(non_empty & pos_all string [] & info [] ~docv:"PATH" ~doc)
  in
  let doc = "Recompute the records for the given documents in place." in
  Cmd.v (Cmd.info "update" ~doc) Term.(const Seed.update $ config_t $ paths)

let check_cmd =
  let doc = "Fail if the committed store differs from a fresh recompute." in
  Cmd.v (Cmd.info "check" ~doc)
    Term.(const (fun cfg -> Stdlib.exit (Seed.check cfg)) $ config_t)

let verify_cmd =
  let base =
    let doc = "Base revision whose committed store the records fold onto." in
    Arg.(value & opt string "origin/main" & info [ "base" ] ~docv:"REV" ~doc)
  in
  let paths =
    let doc = "Changed document paths to verify (relative to the root)." in
    Arg.(non_empty & pos_all string [] & info [] ~docv:"PATH" ~doc)
  in
  let doc =
    "Shallow CI gate: fail unless each changed document's committed record is \
     the base record folded with the PR's commits."
  in
  Cmd.v (Cmd.info "verify" ~doc)
    Term.(
      const (fun cfg base paths -> Stdlib.exit (Seed.verify cfg ~base paths))
      $ config_t $ base $ paths)

let main =
  let doc = "Generate ocaml.org per-document attribution records." in
  Cmd.group
    (Cmd.info "data-attribution" ~version:"0.1" ~doc)
    [ seed_cmd; update_cmd; check_cmd; verify_cmd ]

let () = exit (Cmd.eval main)
