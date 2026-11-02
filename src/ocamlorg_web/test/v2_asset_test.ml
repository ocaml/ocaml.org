(* Files from the v2 site served under /conferences/ocaml/** *)

module Web = Ocamlorg_web

let tmpdir () =
  let d = Filename.temp_file "v2_asset" "" in
  Sys.remove d;
  Sys.mkdir d 0o755;
  d

let write path content =
  let oc = open_out_bin path in
  output_string oc content;
  close_out oc

(* Layout: <top>/elsewhere.md, <top>/v2/elsewhere.md and
   <top>/v2/conferences/ocaml/2013/program.md. Only the last one is under the
   route. *)
let setup () =
  let top = tmpdir () in
  write (Filename.concat top "elsewhere.md") "ELSEWHERE";
  let v2 = Filename.concat top "v2" in
  Sys.mkdir v2 0o755;
  write (Filename.concat v2 "elsewhere.md") "ELSEWHERE";
  let conf = Filename.concat v2 "conferences" in
  Sys.mkdir conf 0o755;
  let ocaml = Filename.concat conf "ocaml" in
  Sys.mkdir ocaml 0o755;
  let year = Filename.concat ocaml "2013" in
  Sys.mkdir year 0o755;
  write (Filename.concat year "program.md") "PROGRAM";
  Dream.router [ Web.Router.v2_assets_route ~root:v2 ]

let get handler target =
  let response =
    Dream.test
      (Web.Middleware.no_trailing_slash
     @@ Web.Middleware.language_manual_version @@ Web.Middleware.head @@ handler
      )
      (Dream.request ~method_:`GET ~target "")
  in
  ( Dream.status_to_int (Dream.status response),
    Lwt_main.run (Dream.body response) )

let check_ok handler target =
  let code, body = get handler target in
  Alcotest.(check int) target 200 code;
  Alcotest.(check string) target "PROGRAM" body

let check_not_found handler target =
  let code, body = get handler target in
  Alcotest.(check int) target 404 code;
  Alcotest.(check bool)
    (target ^ " body") false
    (Ocamlorg.Import.String.is_sub_ignore_case "ELSEWHERE" body)

let test_files () =
  let handler = setup () in
  List.iter (check_ok handler)
    [
      "/conferences/ocaml/2013/program.md";
      "/conferences/ocaml/2013/program.md?utm_source=example";
    ]

let test_not_found () =
  let handler = setup () in
  List.iter (check_not_found handler)
    [ "/conferences/ocaml/does-not-exist"; "/conferences/ocaml/2013/nope.md" ]

let test_directory () =
  let handler = setup () in
  let code, body = get handler "/conferences/ocaml/2013" in
  Alcotest.(check int) "directory" 404 code;
  Alcotest.(check bool) "directory gets the 404 page" true (body <> "")

(* Paths with dot segments or encoded separators are not resolved against the
   file system. The middleware may redirect percent-encoded ones; either way,
   nothing is served. *)
let check_not_served handler target =
  let code, body = get handler target in
  Alcotest.(check bool) (target ^ " status") true (code <> 200);
  Alcotest.(check bool)
    (target ^ " body") false
    (Ocamlorg.Import.String.is_sub_ignore_case "ELSEWHERE" body)

let test_non_normalised () =
  let handler = setup () in
  List.iter (check_not_served handler)
    [
      "/conferences/ocaml/../../elsewhere.md";
      "/conferences/ocaml/../../../elsewhere.md";
      "/conferences/ocaml/2013/../../../elsewhere.md";
      "/conferences/ocaml/%2e%2e/%2e%2e/elsewhere.md";
      "/conferences/ocaml/..%2f..%2felsewhere.md";
      "/conferences/ocaml/2013/%2e%2e%2f%2e%2e%2f%2e%2e%2felsewhere.md";
      "/conferences/ocaml/./2013/program.md/../../../elsewhere.md";
      "/conferences/ocaml/2013/../2013/program.md";
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
