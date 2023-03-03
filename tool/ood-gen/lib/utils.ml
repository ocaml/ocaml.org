open Ocamlorg.Import

let extract_metadata_body s =
  let sep = "---\n" in
  let win_sep = "---\r\n" in
  match (String.cut ~on:sep s, String.cut ~on:win_sep s) with
  | None, None ->
      raise (Exn.Decode_error "expected metadata at the top of the file")
  | Some (pre, post), _ | _, Some (pre, post) ->
      if String.length pre = 0 then
        match (String.cut ~on:sep post, String.cut ~on:win_sep post) with
        | None, None ->
            raise (Exn.Decode_error "expected metadata at the top of the file")
        | Some (yaml, body), _ | _, Some (yaml, body) -> (
            match Yaml.of_string yaml with
            | Ok yaml -> (yaml, body)
            | Error (`Msg err) ->
                raise
                  (Exn.Decode_error
                     (Printf.sprintf
                        "an error occured while reading yaml: %s\n %s" err s)))
      else raise (Exn.Decode_error "expected metadata at the top of the file")

let decode_or_raise f x =
  match f x with
  | Ok x -> x
  | Error (`Msg err) ->
      raise (Exn.Decode_error (Printf.sprintf "could not decode: %s" err))

let read_from_dir dir =
  let len = String.length dir in
  Data.file_list
  |> List.filter_map (fun x ->
         if String.prefix x len = dir then
           Data.read x |> Option.map (fun y -> (x, y))
         else if Glob.matches_glob ~glob:dir x then
           Data.read x |> Option.map (fun y -> (x, y))
         else None)

let map_files f dir =
  read_from_dir dir
  |> List.map (fun (file, x) ->
         match f (file, extract_metadata_body x) with
         | Ok x -> x
         | Error (`Msg err) ->
             raise
               (Exn.Decode_error (Printf.sprintf "could not decode: %s" err)))

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let yaml_sequence_file ?key of_yaml file =
  let ( let* ) = Result.bind in
  let ( <@> ) = Result.apply in
  let key_default = Filename.(file |> basename |> remove_extension) in
  let key = Option.value ~default:key_default key in
  let file_opt = Data.read file in
  let file_res = Option.to_result ~none:(`Msg "file not found") file_opt in
  (let* file = file_res in
   let* yaml = Yaml.of_string file in
   let* opt = Yaml.Util.find key yaml in
   let* found = Option.to_result ~none:(`Msg (key ^ ", key not found")) opt in
   let* list =
     (function `A u -> Ok u | _ -> Error (`Msg "expecting a sequence")) found
   in
   List.fold_left (fun u x -> Ok List.cons <@> of_yaml x <@> u) (Ok []) list)
  |> Result.map_error (function `Msg err -> file ^ ": " ^ err)
  |> Result.get_ok ~error:(fun msg -> Exn.Decode_error msg)
(* let file_opt = File.read_opt path in let file_res = Option.to_result
   ~none:(`Msg "File not found") file_opt in begin let* yaml = Yaml.of_string
   file_res in let* found_opt = Yaml.Util.find key yaml in let* found =
   Option.to_result ~none:(`Msg (key ^ ", key not found")) found_opt in found
   end |> Result.map_error (Printf.sprintf "%s, error: %s: " path) *)
