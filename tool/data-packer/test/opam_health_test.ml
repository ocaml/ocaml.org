(* data/opam_health.yml codec: encode/decode round trip and strict decoding. *)

module C = Data_packer.Opam_health_parser
open Data_intf.Opam_health

let commit = String.make 40 'a'
let id = "1793093119-" ^ commit

let sample =
  {
    run = { id; timestamp = 1793093119.; commit; compilers = [ "4.14"; "5.4" ] };
    releases =
      [
        { name = "dune"; version = "3.20.0"; statuses = [ Good; Good ] };
        (* Keys and values that plain YAML would coerce to a float or bool. *)
        { name = "n"; version = "1.0"; statuses = [ Not_available; Bad ] };
        {
          name = "a_b-c+d";
          version = "v0.15.0~beta";
          statuses = [ Partial; Internal_failure ];
        };
      ];
  }

let decode s = match C.of_string s with Ok t -> t | Error e -> Alcotest.fail e

let round_trip () =
  let s = C.to_string sample in
  let t = decode s in
  Alcotest.(check bool) "run" true (t.run = sample.run);
  Alcotest.(check bool)
    "releases (sorted)" true
    (t.releases = C.sort sample.releases);
  Alcotest.(check string) "stable re-encoding" s (C.to_string t)

let header =
  Printf.sprintf "run: %S\ncompilers: [\"4.14\", \"5.4\"]\npackages:\n" id

let fails name s =
  match C.of_string s with
  | Ok _ -> Alcotest.failf "%s: expected a decode error" name
  | Error _ -> ()

let strict () =
  fails "unknown letter" (header ^ "  \"a.1\": \"GX\"\n");
  fails "wrong width" (header ^ "  \"a.1\": \"GGG\"\n");
  fails "value that YAML reads as a boolean" (header ^ "  \"a.1\": true\n");
  fails "key without version" (header ^ "  \"a\": \"GG\"\n");
  fails "duplicate" (header ^ "  \"a.1\": \"GG\"\n  \"a.1\": \"GB\"\n");
  fails "bad run id"
    "run: \"123-abc\"\ncompilers: [\"4.14\"]\npackages:\n  \"a.1\": \"G\"\n";
  fails "compilers out of order"
    (Printf.sprintf
       "run: %S\ncompilers: [\"5.4\", \"4.14\"]\npackages:\n  \"a.1\": \"GG\"\n"
       id);
  fails "missing packages"
    (Printf.sprintf "run: %S\ncompilers: [\"4.14\"]\n" id)

let compilers () =
  Alcotest.(check (list string))
    "numeric order" [ "4.9"; "4.14"; "5.0" ]
    (List.sort compare_compiler [ "5.0"; "4.14"; "4.9" ])

let () =
  Alcotest.run "opam_health"
    [
      ( "codec",
        [
          Alcotest.test_case "round trip" `Quick round_trip;
          Alcotest.test_case "strict decoding" `Quick strict;
          Alcotest.test_case "compiler order" `Quick compilers;
        ] );
    ]
