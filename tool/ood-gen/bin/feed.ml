open Cmdliner
open Ood_gen

let term_templates =
  [
    ("changelog", Changelog.ChangelogFeed.create_feed);
    ("planet", Planet.GlobalFeed.create_feed);
    ("video", Youtube.create_feed);
  ]

let cmds =
  Cmd.group (Cmd.info "ood-feed" ~version:"%%VERSION%%")
  @@ List.map
       (fun (term, template) ->
         Cmd.v (Cmd.info term)
           Term.(const (fun () -> print_endline (template ())) $ const ()))
       term_templates

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
