open Cmdliner

let term_templates =
  [
    ("academic_institution", Ood_gen.Academic_institution.template);
    ("book", Ood_gen.Book.template);
    ("event", Ood_gen.Event.template);
    ("industrial_user", Ood_gen.Industrial_user.template);
    ("paper", Ood_gen.Paper.template);
    ("success_story", Ood_gen.Success_story.template);
    ("tool", Ood_gen.Tool.template);
    ("tutorial", Ood_gen.Tutorial.template);
    ("workshops", Ood_gen.Workshop.template);
    ("video", Ood_gen.Video.template);
    ("news", Ood_gen.News.template);
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

let () = Term.(exit @@ eval_choice default_cmd cmds)
