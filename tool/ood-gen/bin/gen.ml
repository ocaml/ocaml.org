open Cmdliner

let term_templates =
  [
    ("academic_institution", Ood_gen.Academic_institution.template);
    ("book", Ood_gen.Book.template);
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
  List.map
    (fun (term, template) ->
      ( Term.(const (fun () -> print_endline (template ())) $ const ()),
        Term.info term ))
    term_templates

let default_cmd =
  ( Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())),
    Term.info "ood_gen" )

let () =
  Printexc.record_backtrace true;
  Term.(exit @@ eval_choice default_cmd cmds)
