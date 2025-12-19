open Cmdliner
open Ood_gen

let term_templates =
  [
    ("academic_users", Academic_institution.template);
    ("academic_institutions", Academic_institution.template);
    ("academic_testimonials", Academic_testimonial.template);
    ("book", Book.template);
    ("backstage", Backstage.template);
    ("changelog", Changelog.template);
    ("code_examples", Code_example.template);
    ("cookbook", Cookbook.template);
    ("event", Event.template);
    ("exercises", Exercise.template);
    ("governance", Governance.template);
    ("industrial_user", Industrial_user.template);
    ("industrial_businesses", Industrial_user.template);
    ("is_ocaml_yet", Is_ocaml_yet.template);
    ("job", Job.template);
    ("news", News.template);
    ("opam_user", Opam_user.template);
    ("outreachy", Outreachy.template);
    ("pages", Page.template);
    ("paper", Paper.template);
    ("planet", Planet.template);
    ("release", Release.template);
    ("resource", Resource.template);
    ("success_story", Success_story.template);
    ("tool", Tool.template);
    ("tool_page", Tool_page.template);
    ("tutorial", Tutorial.template);
    ("video", Video.template);
    ("conferences", Conference.template);
    ("testimonial", Testimonial.template);
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
