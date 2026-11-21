(* Compile doc-modules.jsonl (the reference form) into doc-modules-v1.idx (the
   memory-mappable index the server reads).

   Decodes the input strictly (Doc_modules_jsonl), writes the index, reads it
   back and verifies it, and only then renames it into place. An input without
   any package is refused: published, it would empty every server's index. On
   error, OUTPUT is left untouched. *)

let ( let* ) = Result.bind

let run ~input ~output =
  let* contents =
    try Ok (In_channel.with_open_bin input In_channel.input_all)
    with Sys_error e -> Error e
  in
  let* packages =
    match Doc_modules_jsonl.of_string contents with
    | Error e -> Error (Printf.sprintf "%s: %s" input e)
    | Ok [] -> Error (Printf.sprintf "%s: no packages" input)
    | Ok packages -> Ok packages
  in
  let index = Ocamlorg_doc_modules.Writer.to_string packages in
  let* t =
    Ocamlorg_doc_modules.Reader.of_string index
    |> Result.map_error (( ^ ) "the written index does not read back: ")
  in
  let* () =
    Ocamlorg_doc_modules.Reader.verify t
    |> Result.map_error (( ^ ) "the written index does not verify: ")
  in
  let tmp = output ^ ".tmp" in
  let* () =
    try
      Out_channel.with_open_bin tmp (fun oc -> output_string oc index);
      Sys.rename tmp output;
      Ok ()
    with Sys_error e ->
      (try Sys.remove tmp with Sys_error _ -> ());
      Error (Printf.sprintf "cannot write %s: %s" output e)
  in
  Ok
    (Printf.sprintf "%s: %d packages, %d module paths, %d bytes" output
       (Ocamlorg_doc_modules.Reader.package_count t)
       (Ocamlorg_doc_modules.Reader.key_count t)
       (String.length index))
