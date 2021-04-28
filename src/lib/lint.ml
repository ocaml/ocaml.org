open Rresult

let read ~path parse = Bos.OS.File.read path >>| fun s -> parse s

let lint_file file parser =
  let lint = read ~path:file parser in
  match lint with
  | Error (`Msg m) ->
      Fmt.(pf stdout "[%a]: %s" (styled `Red string) "lint-failure" m);
      ();
      -1
  | _ ->
      Fmt.(
        pf stdout "[%a]: %a" (styled `Green string) "lint-success" Fpath.pp file);
      ();
      0

let lint_folder folder parser =
  let contents = Bos.OS.Dir.contents folder |> Rresult.R.get_ok in
  let lints = List.map (fun path -> read ~path parser) contents in
  match List.find_opt Rresult.R.is_error lints with
  | Some (Error (`Msg m)) ->
      Fmt.(pf stdout "[%a]: %s" (styled `Red string) "lint-failure" m);
      ();
      -1
  | _ ->
      Fmt.(
        pf stdout "[%a]: %a"
          (styled `Green string)
          "lint-success" Fpath.pp folder);
      ();
      0

let lints =
  [ (Fpath.v "data/papers.yml", fun file -> lint_file file Data.Papers.lint) ]

let run () =
  Fmt.pr "~~~Linting OCaml.org Data Repository~~~\n\n";
  let exit_codes = List.map (fun (fpath, parser) -> parser fpath) lints in
  if List.for_all (Int.equal 0) exit_codes then 0 else -1

open Cmdliner

let info =
  let doc = "Lints the data in the data folder." in
  Term.info ~doc "lint"

let term = Term.(pure run $ pure ())

let cmd = (term, info)
