(* doc-modules.jsonl decoding: accepts the reference format, rejects anything
   else. *)

let header =
  {|{"format":"ocamlorg-doc-modules","version":1,"generated_at":"x"}|}

let file lines = String.concat "\n" (header :: lines) ^ "\n"
let decode s = Doc_modules_jsonl.of_string s

let accepts () =
  match
    decode
      (file
         [
           {|{"name":"Lwt-x","version":"1.0","modules":["Lwt"]}|};
           {|{"name":"lwt","version":"6.1.2","modules":["Lwt","Lwt_io","M'.N_1"]}|};
         ])
  with
  | Error e -> Alcotest.fail e
  | Ok l ->
      Alcotest.(check (list string))
        "names, C order" [ "Lwt-x"; "lwt" ]
        (List.map (fun (p : Ocamlorg_doc_modules.package) -> p.name) l)

let rejects what s =
  match decode s with
  | Ok _ -> Alcotest.failf "%s: accepted" what
  | Error _ -> ()

let strict () =
  let ok = {|{"name":"lwt","version":"1","modules":["Lwt"]}|} in
  rejects "empty" "";
  rejects "no header" (ok ^ "\n");
  rejects "wrong format" ({|{"format":"other","version":1}|} ^ "\n" ^ ok);
  rejects "unknown version"
    ({|{"format":"ocamlorg-doc-modules","version":2}|} ^ "\n" ^ ok);
  rejects "not JSON" (file [ "{" ]);
  rejects "extra field"
    (file [ {|{"name":"lwt","version":"1","modules":["Lwt"],"x":1}|} ]);
  rejects "missing field" (file [ {|{"name":"lwt","modules":["Lwt"]}|} ]);
  rejects "no modules" (file [ {|{"name":"lwt","version":"1","modules":[]}|} ]);
  rejects "lowercase module"
    (file [ {|{"name":"lwt","version":"1","modules":["lwt"]}|} ]);
  rejects "markup"
    (file [ {|{"name":"lwt","version":"1","modules":["A<b>"]}|} ]);
  rejects "empty segment"
    (file [ {|{"name":"lwt","version":"1","modules":["A..B"]}|} ]);
  rejects "bad name"
    (file [ {|{"name":"l/wt","version":"1","modules":["A"]}|} ]);
  rejects "unsorted"
    (file
       [
         {|{"name":"lwt","version":"1","modules":["A"]}|};
         {|{"name":"fmt","version":"1","modules":["A"]}|};
       ]);
  rejects "duplicate" (file [ ok; ok ])

let () =
  Alcotest.run "doc_modules_jsonl"
    [
      ( "decode",
        [
          Alcotest.test_case "accepts" `Quick accepts;
          Alcotest.test_case "strict" `Quick strict;
        ] );
    ]
