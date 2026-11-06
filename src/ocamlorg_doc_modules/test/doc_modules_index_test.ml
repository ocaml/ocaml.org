(* The doc-modules index: writer/reader round trip, equivalence with a naive
   lookup, determinism, and rejection of damaged files. *)

module D = Ocamlorg_doc_modules
module R = D.Reader

let p name version modules = { D.name; version; modules }

let sample =
  [
    p "lwt" "6.1.2" [ "Lwt"; "Lwt_io"; "Lwt.Infix" ];
    p "yojson" "3.0.0" [ "Yojson"; "Yojson.Safe"; "Yojson.Basic" ];
    p "containers" "3.18" [ "CCList"; "CCHashtbl" ];
    p "lwt_ppx" "5.9" [ "Ppx_lwt" ];
    (* the same module in two packages, and two cases of one path *)
    p "lwt-fork" "1.0" [ "Lwt"; "LWT" ];
  ]

let ok = function Ok v -> v | Error e -> Alcotest.fail e
let read packages = ok (R.of_string (D.Writer.to_string packages))
let names = Alcotest.(list string)

let round_trip () =
  let t = read sample in
  ok (R.verify t);
  Alcotest.(check int) "packages" 5 (R.package_count t);
  Alcotest.(check names) "Lwt_io" [ "lwt" ] (R.providers t "Lwt_io");
  Alcotest.(check names) "case-insensitive" [ "lwt" ] (R.providers t "LWT_IO");
  Alcotest.(check names)
    "two providers, name order" [ "lwt"; "lwt-fork" ] (R.providers t "Lwt");
  Alcotest.(check names)
    "nested path" [ "yojson" ]
    (R.providers t "Yojson.Safe");
  Alcotest.(check names) "unknown" [] (R.providers t "Nope");
  Alcotest.(check names) "empty query" [] (R.providers t "");
  Alcotest.(check (list (pair string string)))
    "packages"
    [
      ("containers", "3.18");
      ("lwt", "6.1.2");
      ("lwt-fork", "1.0");
      ("lwt_ppx", "5.9");
      ("yojson", "3.0.0");
    ]
    (R.packages t)

let empty () =
  let t = read [] in
  ok (R.verify t);
  Alcotest.(check names) "nothing" [] (R.providers t "Lwt")

let deterministic () =
  Alcotest.(check string)
    "order does not matter"
    (D.Writer.to_string sample)
    (D.Writer.to_string (List.rev sample));
  Alcotest.check_raises "duplicate package"
    (Invalid_argument "Ocamlorg_doc_modules: duplicate package lwt") (fun () ->
      ignore (D.Writer.to_string [ p "lwt" "1" [ "A" ]; p "lwt" "2" [ "B" ] ]))

(* A larger synthetic set, checked against a naive table for every key. *)
let naive_equivalence () =
  Random.init 42;
  let seg () =
    String.init
      (1 + Random.int 6)
      (fun i ->
        if i = 0 then Char.chr (65 + Random.int 26)
        else Char.chr (97 + Random.int 26))
  in
  let packages =
    List.init 800 (fun i ->
        p
          (Printf.sprintf "pkg%04d" i)
          "1.0"
          (List.init (Random.int 20) (fun _ ->
               if Random.bool () then seg () else seg () ^ "." ^ seg ())))
  in
  let t = read packages in
  ok (R.verify t);
  let naive = Hashtbl.create 1000 in
  List.iter
    (fun (q : D.package) ->
      List.iter
        (fun m ->
          let k = String.lowercase_ascii m in
          let l = Option.value ~default:[] (Hashtbl.find_opt naive k) in
          if not (List.mem q.name l) then Hashtbl.replace naive k (q.name :: l))
        q.modules)
    packages;
  Alcotest.(check int) "key count" (Hashtbl.length naive) (R.key_count t);
  Hashtbl.iter
    (fun k l ->
      Alcotest.(check names) k (List.sort compare l) (R.providers t k))
    naive

let little_allocation () =
  let t = read sample in
  ignore (R.providers t "Lwt_io");
  let before = Gc.minor_words () in
  for _ = 1 to 1000 do
    ignore (Sys.opaque_identity (R.providers t "Nope_nope"))
  done;
  let per_miss = (Gc.minor_words () -. before) /. 1000. in
  (* only the lowercased query: a few words *)
  Alcotest.(check bool)
    (Printf.sprintf "a miss allocates %.0f words" per_miss)
    true (per_miss < 16.)

let fails what s =
  match R.of_string s with
  | Error _ -> ()
  | Ok t -> (
      match R.verify t with
      | Error _ -> ()
      | Ok () -> Alcotest.failf "%s: accepted" what)

let set_byte s i c =
  let b = Bytes.of_string s in
  Bytes.set b i c;
  Bytes.to_string b

let damaged () =
  let s = D.Writer.to_string sample in
  fails "bad magic" (set_byte s 0 'X');
  fails "unknown version" (set_byte s 4 '\002');
  fails "truncated" (String.sub s 0 (String.length s - 1));
  fails "too short" (String.sub s 0 10);
  fails "padded" (s ^ "\000");
  fails "body byte flipped (MD5)" (set_byte s (String.length s - 1) 'z');
  (* a key's offset pointing past the end, with a fixed-up MD5 so that only the
     structural checks can catch it *)
  let t = ok (R.of_string s) in
  ignore t;
  let off_keys =
    Char.code s.[20] lor (Char.code s.[21] lsl 8) lor (Char.code s.[22] lsl 16)
  in
  let b = Bytes.of_string s in
  Bytes.set_int32_le b off_keys 0x7FFF_FFFFl;
  let body = Bytes.sub_string b 64 (Bytes.length b - 64) in
  Bytes.blit_string (Digest.string body) 0 b 36 16;
  let bad = Bytes.to_string b in
  fails "out-of-bounds key" bad;
  (* and lookups on it fail safely instead of reading outside *)
  let t = ok (R.of_string bad) in
  (* The damaged entry is the first key ("cchashtbl"): a search that reaches it
     gives up; others may still succeed, but none reads out of bounds. *)
  Alcotest.(check names)
    "a lookup reaching the damaged key" []
    (R.providers t "CCHashtbl");
  List.iter
    (fun q -> ignore (R.providers t q))
    [ "Lwt"; "Lwt_io"; "Yojson.Safe"; "CCList"; "Ppx_lwt"; "Zzz"; "" ]

let map_file () =
  let path = Filename.temp_file "doc-modules" ".idx" in
  Out_channel.with_open_bin path (fun oc ->
      output_string oc (D.Writer.to_string sample));
  let t = ok (R.map_file path) in
  Sys.remove path;
  Alcotest.(check names)
    "mapped lookup" [ "containers" ] (R.providers t "CCList");
  match R.map_file path with
  | Error _ -> ()
  | Ok _ -> Alcotest.fail "a missing file was mapped"

let () =
  Alcotest.run "doc_modules_index"
    [
      ( "index",
        [
          Alcotest.test_case "round trip" `Quick round_trip;
          Alcotest.test_case "empty" `Quick empty;
          Alcotest.test_case "deterministic" `Quick deterministic;
          Alcotest.test_case "naive equivalence" `Quick naive_equivalence;
          Alcotest.test_case "little allocation" `Quick little_allocation;
          Alcotest.test_case "damaged files" `Quick damaged;
          Alcotest.test_case "map_file" `Quick map_file;
        ] );
    ]
