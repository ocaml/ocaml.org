open Ocamlorg.Import

let ( let* ) = Result.bind
let ( <@> ) = Result.apply

let extract_metadata_body path s =
  let err =
    `Msg
      (Printf.sprintf "expected metadata at the top of the file %s. Got %s" path
         s)
  in
  let cut =
    let sep = "---\n" in
    let win_sep = "---\r\n" in
    let cut on s = Option.to_result ~none:err (String.cut ~on s) in
    Result.sequential_or (cut sep) (cut win_sep)
  in
  let* pre, post = cut s in
  let* () = if pre = "" then Ok () else Error err in
  let* yaml, body = cut post in
  let* yaml = Yaml.of_string yaml in
  Ok (yaml, body)

let root_dir = Fpath.(v (Sys.getcwd ()) // v "data")

let read_file filepath =
  let filepath = Fpath.(root_dir // filepath) in
  Bos.OS.File.read filepath
  |> Result.map (fun r -> Some r)
  |> Result.map_error (fun (`Msg msg) -> failwith msg)
  |> Result.value ~default:None

let read_from_dir glob =
  let file_pattern =
    Fpath.v (String.split_on_char '*' glob |> String.concat "$(f)")
  in
  Bos.OS.Path.matches Fpath.(root_dir // file_pattern)
  |> Result.get_ok ~error:(fun (`Msg msg) -> failwith msg)
  |> List.filter_map (fun x ->
         read_file x
         |> Option.map (fun y ->
                ( x |> Fpath.rem_prefix root_dir |> Option.get |> Fpath.to_string,
                  y )))

let map_files f glob =
  let f (path, data) =
    let* metadata = extract_metadata_body path data in
    f (path, metadata)
  in
  read_from_dir glob
  |> List.fold_left (fun u x -> Ok List.cons <@> f x <@> u) (Ok [])
  |> Result.map List.rev
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let yaml_file filepath_str =
  let filepath =
    filepath_str |> Fpath.of_string
    |> Result.get_ok ~error:(fun (`Msg m) -> Invalid_argument m)
  in
  let file_opt = read_file filepath in
  let* file = Option.to_result ~none:(`Msg "file not found") file_opt in
  Yaml.of_string file

let yaml_sequence_file ?key of_yaml filepath_str =
  let filepath =
    filepath_str |> Fpath.of_string
    |> Result.get_ok ~error:(fun (`Msg m) -> Invalid_argument m)
  in
  let key_default = filepath |> Fpath.rem_ext |> Fpath.basename in
  let key = Option.value ~default:key_default key in
  (let* yaml = yaml_file filepath_str in
   let* opt = Yaml.Util.find key yaml in
   let* found = Option.to_result ~none:(`Msg (key ^ ", key not found")) opt in
   let* list =
     (function `A u -> Ok u | _ -> Error (`Msg "expecting a sequence")) found
   in
   List.fold_left (fun u x -> Ok List.cons <@> of_yaml x <@> u) (Ok []) list)
  |> Result.map_error (function `Msg err ->
         `Msg ((filepath |> Fpath.to_string) ^ ": " ^ err))
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let of_yaml of_string error = function
  | `String s -> of_string s
  | _ -> Error (`Msg error)

let where fpath = function `Msg err -> `Msg (fpath ^ ": " ^ err)
