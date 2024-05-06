open Cmdliner

let term_templates =
  [
    ("is_ocaml_yet", Ood_gen.Is_ocaml_yet.template);
    ("academic_institution", Ood_gen.Academic_institution.template);
    ("book", Ood_gen.Book.template);
    ("governance", Ood_gen.Governance.template);
    ("job", Ood_gen.Job.template);
    ("news", Ood_gen.News.template);
    ("changelog", Ood_gen.Changelog.template);
    ("industrial_user", Ood_gen.Industrial_user.template);
    ("outreachy", Ood_gen.Outreachy.template);
    ("paper", Ood_gen.Paper.template);
    ("exercises", Ood_gen.Exercise.template);
    ("release", Ood_gen.Release.template);
    ("success_story", Ood_gen.Success_story.template);
    ("tool", Ood_gen.Tool.template);
    ("tutorial", Ood_gen.Tutorial.template);
    ("workshops", Ood_gen.Workshop.template);
    ("video", Ood_gen.Video.template);
    ("planet", Ood_gen.Planet.template);
    ("planet_feed", Ood_gen.Planet.GlobalFeed.create_feed);
    ("changelog_feed", Ood_gen.Changelog.ChangelogFeed.create_feed);
    ("watch", Ood_gen.Watch.template);
    ("opam_user", Ood_gen.Opam_user.template);
    ("pages", Ood_gen.Page.template);
    ("code_examples", Ood_gen.Code_example.template);
    ("event", Ood_gen.Event.template);
    ("cookbook", Ood_gen.Cookbook.template);
  ]

let cmds =
  Cmd.group (Cmd.info "ood-gen" ~version:"%%VERSION%%")
  @@ List.map
       (fun (term, template) ->
         Cmd.v (Cmd.info term)
           Term.(const (fun () -> print_endline (template ())) $ const ()))
       term_templates

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
