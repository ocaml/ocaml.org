(* The reference form of the doc-modules data, doc-modules.jsonl, as written by
   scrape.sh and compiled into the index by compile.exe.

   First line: {"format": "ocamlorg-doc-modules", "version": 1, ...} (other
   header fields, such as "generated_at", are free). Then one object per
   package, sorted by name in byte order, without duplicates:

   {"name": "lwt", "version": "6.1.2", "modules": ["Lwt", "Lwt_io", ...]}

   with opam characters in name and version, and at least one module path, each
   made of OCaml module names (an uppercase letter, then letters, digits, '_' or
   a quote). Decoding is strict: anything else is an error, so that CI fails
   before publishing. *)

let format = "ocamlorg-doc-modules"
let version = 1
let ( let* ) = Result.bind

let is_opam_char = function
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-' | '+' | '.' | '~' -> true
  | _ -> false

let is_module_name s =
  s <> ""
  && (match s.[0] with 'A' .. 'Z' -> true | _ -> false)
  && String.for_all
       (function
         | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '\'' -> true
         | _ -> false)
       s

let is_module_path p = List.for_all is_module_name (String.split_on_char '.' p)

let header line =
  match Yojson.Safe.from_string line with
  | exception Yojson.Json_error e -> Error ("header: " ^ e)
  | `Assoc fields -> (
      match
        (List.assoc_opt "format" fields, List.assoc_opt "version" fields)
      with
      | Some (`String f), Some (`Int v) when f = format && v = version -> Ok ()
      | Some (`String f), Some (`Int v) when f = format ->
          Error
            (Printf.sprintf "header: format version %d, expected %d" v version)
      | _ -> Error "header: not a doc-modules file")
  | _ -> Error "header: expected an object"

let package line : (Ocamlorg_doc_modules.package, string) result =
  match Yojson.Safe.from_string line with
  | exception Yojson.Json_error e -> Error e
  | `Assoc fields ->
      let keys = List.map fst fields |> List.sort String.compare in
      if keys <> [ "modules"; "name"; "version" ] then
        Error "expected exactly the fields name, version and modules"
      else
        let* name =
          match List.assoc "name" fields with
          | `String s when s <> "" && String.for_all is_opam_char s -> Ok s
          | _ -> Error "name: not a package name"
        in
        let* version =
          match List.assoc "version" fields with
          | `String s when s <> "" && String.for_all is_opam_char s -> Ok s
          | _ -> Error (name ^ ": version: not a version")
        in
        let* modules =
          match List.assoc "modules" fields with
          | `List [] -> Error (name ^ ": no module paths")
          | `List l ->
              List.fold_right
                (fun m acc ->
                  let* acc = acc in
                  match m with
                  | `String s when is_module_path s -> Ok (s :: acc)
                  | `String s -> Error (name ^ ": not a module path: " ^ s)
                  | _ -> Error (name ^ ": modules: expected strings"))
                l (Ok [])
          | _ -> Error (name ^ ": modules: expected a list")
        in
        Ok { Ocamlorg_doc_modules.name; version; modules }
  | _ -> Error "expected an object"

(* All the packages of a doc-modules.jsonl file's contents. *)
let of_string s =
  let lines =
    String.split_on_char '\n' s
    |> List.mapi (fun i l -> (i + 1, l))
    |> List.filter (fun (_, l) -> l <> "")
  in
  match lines with
  | [] -> Error "empty file"
  | (_, h) :: rest ->
      let* () = header h in
      let* packages, _ =
        List.fold_left
          (fun acc (n, l) ->
            let* acc, prev = acc in
            match package l with
            | Error e -> Error (Printf.sprintf "line %d: %s" n e)
            | Ok p -> (
                match prev with
                | Some q when String.compare q p.name >= 0 ->
                    Error
                      (Printf.sprintf
                         "line %d: %s after %s: not sorted, or a duplicate" n
                         p.name q)
                | _ -> Ok (p :: acc, Some p.name)))
          (Ok ([], None))
          rest
      in
      Ok (List.rev packages)
