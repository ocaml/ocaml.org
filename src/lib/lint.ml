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
  let lints = List.map (fun path -> lint ~path parse) paths in
  if List.for_all Rresult.R.is_ok lints then Ok ()
  else List.find Rresult.R.is_error lints

let lint_check =
  Alcotest.of_pp (fun ppf -> function
    | Ok () -> Fmt.string ppf "OK"
    | Error (`Msg m) -> Fmt.(pf ppf "Error: %s" m))

let linter label path parser () =
  Alcotest.check lint_check label (Ok ()) (lint ~path:(Fpath.v path) parser)

let lint_tutorials () =
  Alcotest.check lint_check "lint tutorials" (Ok ())
    (lint_folder ~path:(Fpath.v Tutorial.path) Tutorial.lint)

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
        ("folders", [ test_case Tutorial.path `Quick lint_tutorials ]);
      ];
    0
  with Test_error -> 1

open Cmdliner

let info =
  let doc = "Lints the data in the data folder." in
  Term.info ~doc "lint"

let term = Term.(pure run $ pure ())

let cmd = (term, info)
