(* data/doc_modules.txt codec: encode/decode round trip and strict decoding. *)

module C = Data_packer.Doc_modules_parser
open Data_intf.Doc_modules

let sample =
  [
    {
      name = "yojson";
      version = "3.0.0";
      modules = [ "Yojson"; "Yojson.Safe" ];
    };
    { name = "a_b-c+d"; version = "v0.15.0~beta"; modules = [ "M'"; "M'.N_1" ] };
    { name = "lwt"; version = "6.1.2"; modules = [ "Lwt"; "Lwt_io" ] };
  ]

let decode s = match C.of_string s with Ok t -> t | Error e -> Alcotest.fail e

let round_trip () =
  let s = C.to_string sample in
  let t = decode s in
  Alcotest.(check bool) "packages (sorted)" true (t = C.sort sample);
  Alcotest.(check string) "stable re-encoding" s (C.to_string t)

let fails name s =
  match C.of_string s with
  | Ok _ -> Alcotest.failf "%s: expected a decode error" name
  | Error _ -> ()

let strict () =
  fails "no module" "lwt 6.1.2\n";
  fails "lowercase module" "lwt 6.1.2 lwt\n";
  fails "empty segment" "lwt 6.1.2 Lwt..Io\n";
  fails "markup in a name" "lwt 6.1.2 Lwt <code>\n";
  fails "bad package name" "l/wt 6.1.2 Lwt\n";
  fails "unsorted" "lwt 6.1.2 Lwt\nfmt 0.11.0 Fmt\n";
  fails "duplicate" "lwt 6.1.2 Lwt\nlwt 6.1.2 Lwt\n";
  (* comments and blank lines are fine *)
  Alcotest.(check int)
    "comments" 1
    (List.length (decode "# c\n\nlwt 6.1.2 Lwt Lwt.Infix\n"))

let () =
  Alcotest.run "doc_modules"
    [
      ( "codec",
        [
          Alcotest.test_case "round trip" `Quick round_trip;
          Alcotest.test_case "strict" `Quick strict;
        ] );
    ]
