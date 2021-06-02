open Rresult
open Data

let lint ~path parse =
  Bos.OS.File.read path >>= fun s ->
  parse s >>= fun _ -> Ok ()

(* For now only lint `en` ones *)
let lint_folder ?(filter = fun p -> Fpath.get_ext p = ".md") ~path parse =
  Bos.OS.Dir.contents path >>= fun fpaths ->
  let paths = List.filter filter fpaths in
  assert (List.length paths <> 0);
  let lints = List.map (fun path -> (path, lint ~path parse)) paths in
  if List.for_all (fun (_, l) -> Rresult.R.is_ok l) lints then Ok ()
  else
    let path, `Msg m =
      List.find
        (fun (p, l) ->
          print_endline (Fpath.to_string p);
          Rresult.R.is_error l)
        lints
      |> fun (p, err) -> (p, Rresult.R.get_error err)
    in
    Error (`Msg (Fpath.to_string path ^ " - " ^ m))

let lint_check =
  Alcotest.of_pp (fun ppf -> function
    | Ok () -> Fmt.string ppf "OK"
    | Error (`Msg m) -> Fmt.(pf ppf "Error: %s" m))

let linter label path parser () =
  Alcotest.check lint_check label (Ok ()) (lint ~path:(Fpath.v path) parser)

let lint_tutorials () =
  Alcotest.check lint_check "lint tutorials" (Ok ())
    (lint_folder ~path:(Fpath.v Tutorial.path) Tutorial.lint)

let lint_success_stories () =
  Alcotest.check lint_check "lint success stories" (Ok ())
    (lint_folder ~path:(Fpath.v Success_story.path) Success_story.lint)

let lint_books () =
  Alcotest.check lint_check "lint books" (Ok ())
    (lint_folder ~path:(Fpath.v Book.path) Book.lint)

let run () =
  let open Alcotest in
  try
    run ~and_exit:false "Linting" ~argv:[| "--verbose" |]
      [
        ( "files",
          [
            test_case Papers.path `Quick
              (linter "lint papers" Papers.path Papers.lint);
            test_case Events.path `Quick
              (linter "lint events" Events.path Events.lint);
            test_case Videos.path `Quick
              (linter "lint videos" Videos.path Videos.lint);
          ] );
        ( "folders",
          [
            test_case Tutorial.path `Quick lint_tutorials;
            test_case Success_story.path `Quick lint_success_stories;
            test_case Book.path `Quick lint_books;
          ] );
      ];
    0
  with Test_error -> 1

open Cmdliner

let info =
  let doc = "Lints the data in the data folder." in
  Term.info ~doc "lint"

let term = Term.(pure run $ pure ())

let cmd = (term, info)
