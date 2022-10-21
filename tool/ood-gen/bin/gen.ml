open Cmdliner

let term_templates =
  [
    ("academic_institution", Ood_gen.Academic_institution.template);
    ("book", Ood_gen.Book.template);
    ("governance", Ood_gen.Governance.template);
    ("job", Ood_gen.Job.template);
    ("meetup", Ood_gen.Meetup.template);
    ("news", Ood_gen.News.template);
    ("industrial_user", Ood_gen.Industrial_user.template);
    ("packages", Ood_gen.Packages.template);
    ("paper", Ood_gen.Paper.template);
    ("problems", Ood_gen.Problem.template);
    ("release", Ood_gen.Release.template);
    ("success_story", Ood_gen.Success_story.template);
    ("tool", Ood_gen.Tool.template);
    ("tutorial", Ood_gen.Tutorial.template);
    ("workshops", Ood_gen.Workshop.template);
    ("video", Ood_gen.Video.template);
    ("watch", Ood_gen.Watch.template);
    ("rss", Ood_gen.Rss.template);
    ("opam_user", Ood_gen.Opam_user.template);
    ("workflows", Ood_gen.Workflow.template);
    ("pages", Ood_gen.Page.template);
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
