(* Compile doc-modules.jsonl (the reference form) into doc-modules-v1.idx (the
   memory-mappable index the server reads).

   compile.exe INPUT.jsonl OUTPUT.idx

   Decodes the input strictly (Doc_modules_jsonl), writes the index, reads it
   back and verifies it, and only then renames it into place. Exits 1 with the
   first problem on stderr, leaving OUTPUT untouched. *)

let fail fmt =
  Printf.ksprintf
    (fun m ->
      prerr_endline m;
      exit 1)
    fmt

let () =
  match Sys.argv with
  | [| _; input; output |] -> (
      let contents = In_channel.with_open_bin input In_channel.input_all in
      match Doc_modules_jsonl.of_string contents with
      | Error e -> fail "%s: %s" input e
      | Ok packages -> (
          let index = Ocamlorg_doc_modules.Writer.to_string packages in
          match Ocamlorg_doc_modules.Reader.of_string index with
          | Error e -> fail "the written index does not read back: %s" e
          | Ok t -> (
              match Ocamlorg_doc_modules.Reader.verify t with
              | Error e -> fail "the written index does not verify: %s" e
              | Ok () ->
                  let tmp = output ^ ".tmp" in
                  (try
                     Out_channel.with_open_bin tmp (fun oc ->
                         output_string oc index);
                     Sys.rename tmp output
                   with Sys_error e ->
                     (try Sys.remove tmp with Sys_error _ -> ());
                     fail "cannot write %s: %s" output e);
                  Printf.printf "%s: %d packages, %d module paths, %d bytes\n"
                    output
                    (Ocamlorg_doc_modules.Reader.package_count t)
                    (Ocamlorg_doc_modules.Reader.key_count t)
                    (String.length index))))
  | _ ->
      prerr_endline "usage: compile.exe INPUT.jsonl OUTPUT.idx";
      exit 2
