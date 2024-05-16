open Cmdliner

let term_templates =
  [
    ("academic_institution", Ood_gen.Academic_institution.template);
    ("book", Ood_gen.Book.template);
    ("changelog", Ood_gen.Changelog.template);
    ("changelog_feed", Ood_gen.Changelog.ChangelogFeed.create_feed);
    ("code_examples", Ood_gen.Code_example.template);
    ("cookbook", Ood_gen.Cookbook.template);
    ("event", Ood_gen.Event.template);
    ("exercises", Ood_gen.Exercise.template);
    ("governance", Ood_gen.Governance.template);
    ("industrial_user", Ood_gen.Industrial_user.template);
    ("is_ocaml_yet", Ood_gen.Is_ocaml_yet.template);
    ("job", Ood_gen.Job.template);
    ("news", Ood_gen.News.template);
    ("opam_user", Ood_gen.Opam_user.template);
    ("outreachy", Ood_gen.Outreachy.template);
    ("pages", Ood_gen.Page.template);
    ("paper", Ood_gen.Paper.template);
    ("planet", Ood_gen.Planet.template);
    ("planet_feed", Ood_gen.Planet.GlobalFeed.create_feed);
    ("release", Ood_gen.Release.template);
    ("resource", Ood_gen.Resource.template);
    ("success_story", Ood_gen.Success_story.template);
    ("tool", Ood_gen.Tool.template);
    ("tutorial", Ood_gen.Tutorial.template);
    ("video", Ood_gen.Video.template);
    ("watch", Ood_gen.Watch.template);
    ("workshops", Ood_gen.Workshop.template);
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
