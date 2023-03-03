open Ocamlorg.Import

let ( let* ) = Result.bind
let ( <@> ) = Result.apply

let extract_metadata_body s =
  let sep = "---\n" in
  let win_sep = "---\r\n" in
  let error_msg = `Msg "expected metadata at the top of the file" in
  let cut ~on s = Option.to_result ~none:error_msg (String.cut ~on s) in
  let* pre, post = Result.sequential_or (cut ~on:sep) (cut ~on:win_sep) s in
  let* () = if pre = "" then Ok () else Error error_msg in
  let* yaml, body = Result.sequential_or (cut ~on:sep) (cut ~on:win_sep) post in
  let* yaml = Yaml.of_string yaml in
  Ok (yaml, body)

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
  let f (path, data) =
    let* metadata = extract_metadata_body data in
    f (path, metadata)
  in
  read_from_dir dir
  |> List.fold_left (fun u x -> Ok List.cons <@> f x <@> u) (Ok [])
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let yaml_file file =
  let file_opt = Data.read file in
  let* file = Option.to_result ~none:(`Msg "file not found") file_opt in
  Yaml.of_string file

let yaml_sequence_file ?key of_yaml file =
  let key_default = Filename.(file |> basename |> remove_extension) in
  let key = Option.value ~default:key_default key in
  (let* yaml = yaml_file file in
   let* opt = Yaml.Util.find key yaml in
   let* found = Option.to_result ~none:(`Msg (key ^ ", key not found")) opt in
   let* list =
     (function `A u -> Ok u | _ -> Error (`Msg "expecting a sequence")) found
   in
   List.fold_left (fun u x -> Ok List.cons <@> of_yaml x <@> u) (Ok []) list)
  |> Result.map_error (function `Msg err -> `Msg (file ^ ": " ^ err))
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)
