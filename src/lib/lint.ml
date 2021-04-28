open Rresult
open Data

let lint ~path parse =
  Bos.OS.File.read path >>= fun s ->
  parse s >>= fun _ -> Ok ()

let lint_check =
  Alcotest.of_pp (fun ppf -> function
    | Ok () -> Fmt.nop ppf () | Error (`Msg m) -> Fmt.string ppf m)

let lint_papers () =
  Alcotest.check lint_check "lint papers"
    (lint ~path:(Fpath.v Papers.path) Papers.lint)
    (Ok ())

let run () =
  let open Alcotest in
  try
    run ~and_exit:false "Linting" ~argv:[| "--verbose" |]
      [ ("files", [ test_case Papers.path `Quick lint_papers ]) ];
    0
  with Test_error -> 1

open Cmdliner

let info =
  let doc = "Lints the data in the data folder." in
  Term.info ~doc "lint"

let term = Term.(pure run $ pure ())

let cmd = (term, info)
