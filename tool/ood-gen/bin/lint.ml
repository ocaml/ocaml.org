open Rresult
open Ood_gen

let lint ~path parse =
  Bos.OS.File.read path >>= fun s ->
  parse s >>= fun _ -> Ok ()

(* For now only lint `en` ones *)
let lint_folder ?(filter = fun p -> Fpath.get_ext p = ".md") ~path parse =
  Bos.OS.Dir.contents path >>= fun fpaths ->
  let paths = List.filter filter fpaths in
  assert (List.length paths <> 0);
  let lints = List.map (fun path -> path, lint ~path parse) paths in
  if List.for_all (fun (_, l) -> Rresult.R.is_ok l) lints then
    Ok ()
  else
    let path, `Msg m =
      List.find
        (fun (p, l) ->
          print_endline (Fpath.to_string p);
          Rresult.R.is_error l)
        lints
      |> fun (p, err) -> p, Rresult.R.get_error err
    in
    Error (`Msg (Fpath.to_string path ^ " - " ^ m))

let lint_check =
  Alcotest.of_pp (fun ppf -> function
    | Ok () ->
      Fmt.string ppf "OK"
    | Error (`Msg m) ->
      Fmt.(pf ppf "Error: %s" m))

let linter label path parser () =
  Alcotest.check lint_check label (Ok ()) (lint ~path parser)

let lint_tutorials () =
  Alcotest.check
    lint_check
    "lint tutorials"
    (Ok ())
    (lint_folder ~path:Tutorial.path Tutorial.parse)

let lint_watch () =
  Alcotest.check
    lint_check
    "lint watch"
    (Ok ())
    (lint_folder ~path:Watch.path Watch.parse)

let lint_workshops () =
  Alcotest.check
    lint_check
    "lint workshops"
    (Ok ())
    (lint_folder ~path:Workshop.path Workshop.parse)

let lint_success_stories () =
  Alcotest.check
    lint_check
    "lint success stories"
    (Ok ())
    (lint_folder ~path:Success_story.path Success_story.parse)

let lint_books () =
  Alcotest.check
    lint_check
    "lint books"
    (Ok ())
    (lint_folder ~path:Book.path Book.parse)

let lint_industrial_users () =
  Alcotest.check
    lint_check
    "lint industrial users"
    (Ok ())
    (lint_folder ~path:Industrial_user.path Industrial_user.parse)

let lint_academic_institution () =
  Alcotest.check
    lint_check
    "lint academic institution"
    (Ok ())
    (lint_folder ~path:Academic_institution.path Academic_institution.parse)

let run () =
  let open Alcotest in
  try
    run
      ~and_exit:false
      "Linting"
      ~argv:[| "--verbose" |]
      [ ( "files"
        , [ test_case
              (Fpath.to_string Paper.path)
              `Quick
              (linter "lint papers" Paper.path Paper.parse)
          ; test_case
              (Fpath.to_string Video.path)
              `Quick
              (linter "lint videos" Video.path Video.parse)
          ; test_case
              (Fpath.to_string Watch.path)
              `Quick
              (linter "lint watch videos" Watch.path Watch.parse)
          ; test_case
              (Fpath.to_string Tool.path)
              `Quick
              (linter "lint tools" Tool.path Tool.parse)
          ] )
      ; ( "folders"
        , [ test_case (Fpath.to_string Tutorial.path) `Quick lint_tutorials
          ; test_case
              (Fpath.to_string Success_story.path)
              `Quick
              lint_success_stories
          ; test_case (Fpath.to_string Book.path) `Quick lint_books
          ; test_case
              (Fpath.to_string Industrial_user.path)
              `Quick
              lint_industrial_users
          ; test_case
              (Fpath.to_string Academic_institution.path)
              `Quick
              lint_academic_institution
          ; test_case (Fpath.to_string Workshop.path) `Quick lint_workshops
          ] )
      ];
    0
  with
  | Test_error ->
    1

open Cmdliner

let term_scrapers = [ "lint", run ]

let cmds =
  List.map
    (fun (term, scraper) -> Term.(const scraper $ const ()), Term.info term)
    term_scrapers

let default_cmd =
  ( Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ()))
  , Term.info "ood_lint" )

let () = Term.(exit @@ eval_choice default_cmd cmds)
