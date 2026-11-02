(* Files from the v2 site served under /conferences/ocaml/** *)

module Web = Ocamlorg_web

let write path content =
  let oc = open_out_bin path in
  output_string oc content;
  close_out oc

let rec remove path =
  if Sys.is_directory path then (
    Array.iter
      (fun name -> remove (Filename.concat path name))
      (Sys.readdir path);
    Sys.rmdir path)
  else Sys.remove path

(* Layout, built once and removed at exit: <top>/elsewhere.md,
   <top>/v2/elsewhere.md, <top>/v2/conferences/ocaml/2013/program.md and the
   empty directory <top>/v2/conferences/ocaml/2013/slides. Only the last two are
   under the route. *)
let handler =
  let top = Filename.temp_dir "v2_asset" "" in
  at_exit (fun () -> remove top);
  write (Filename.concat top "elsewhere.md") "ELSEWHERE";
  let v2 = Filename.concat top "v2" in
  Sys.mkdir v2 0o755;
  write (Filename.concat v2 "elsewhere.md") "ELSEWHERE";
  let year =
    List.fold_left
      (fun dir name ->
        let dir = Filename.concat dir name in
        Sys.mkdir dir 0o755;
        dir)
      v2
      [ "conferences"; "ocaml"; "2013" ]
  in
  write (Filename.concat year "program.md") "PROGRAM";
  Sys.mkdir (Filename.concat year "slides") 0o755;
  Dream.router [ Web.Router.v2_assets_route ~root:v2 ]

let get target =
  let response =
    Dream.test
      (Web.Middleware.no_trailing_slash
     @@ Web.Middleware.language_manual_version @@ Web.Middleware.head @@ handler
      )
      (Dream.request ~method_:`GET ~target "")
  in
  ( Dream.status_to_int (Dream.status response),
    Lwt_main.run (Dream.body response) )

let contains sub body = Ocamlorg.Import.String.is_sub_ignore_case sub body

let check_ok target =
  let code, body = get target in
  Alcotest.(check int) target 200 code;
  Alcotest.(check string) target "PROGRAM" body

(* Missing files and directories get the site's 404 page. *)
let check_not_found_page target =
  let code, body = get target in
  Alcotest.(check int) target 404 code;
  Alcotest.(check bool)
    (target ^ " 404 page") true
    (contains "Page not found" body)

let test_files () =
  List.iter check_ok
    [
      "/conferences/ocaml/2013/program.md";
      "/conferences/ocaml/2013/program.md?utm_source=example";
    ]

let test_not_found () =
  List.iter check_not_found_page
    [ "/conferences/ocaml/does-not-exist"; "/conferences/ocaml/2013/nope.md" ]

let test_directory () = check_not_found_page "/conferences/ocaml/2013/slides"

(* Paths with dot segments or encoded separators are not resolved against the
   file system: [Dream.static] answers 404, or the middleware first redirects
   percent-encoded ones (303). *)
let check_not_served (target, expected) =
  let code, body = get target in
  Alcotest.(check int) (target ^ " status") expected code;
  Alcotest.(check bool) (target ^ " body") false (contains "ELSEWHERE" body)

let test_non_normalised () =
  List.iter check_not_served
    [
      ("/conferences/ocaml/../../elsewhere.md", 404);
      ("/conferences/ocaml/../../../elsewhere.md", 404);
      ("/conferences/ocaml/2013/../../../elsewhere.md", 404);
      ("/conferences/ocaml/%2e%2e/%2e%2e/elsewhere.md", 303);
      ("/conferences/ocaml/..%2f..%2felsewhere.md", 303);
      ("/conferences/ocaml/2013/%2e%2e%2f%2e%2e%2f%2e%2e%2felsewhere.md", 303);
      ("/conferences/ocaml/./2013/program.md/../../../elsewhere.md", 404);
      ("/conferences/ocaml/2013/../2013/program.md", 404);
    ]

let () =
  Alcotest.run "v2_asset"
    [
      ( "conferences/ocaml",
        [
          Alcotest.test_case "files" `Quick test_files;
          Alcotest.test_case "not found" `Quick test_not_found;
          Alcotest.test_case "directory" `Quick test_directory;
          Alcotest.test_case "non-normalised paths" `Quick test_non_normalised;
        ] );
    ]
