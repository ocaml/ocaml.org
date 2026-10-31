(* Utilities for parsing data files - adapted from ood-gen/lib/utils.ml *)

open Import

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

(* Byte offset of the first invalid UTF-8 sequence in [s], if any. *)
let first_invalid_utf_8 s =
  let len = Stdlib.String.length s in
  let rec go i =
    if i >= len then None
    else
      let d = Stdlib.String.get_utf_8_uchar s i in
      if Uchar.utf_decode_is_valid d then go (i + Uchar.utf_decode_length d)
      else Some i
  in
  go 0

(* Every file in data/ must be UTF-8 without a byte-order mark. *)
let check_utf_8 filepath s =
  let fail fmt =
    Printf.ksprintf
      (fun msg -> failwith (Printf.sprintf "data/%s: %s" filepath msg))
      fmt
  in
  if Stdlib.String.starts_with ~prefix:"\xef\xbb\xbf" s then
    fail "starts with a UTF-8 byte-order mark; remove it";
  match first_invalid_utf_8 s with
  | Some i -> fail "invalid UTF-8 at byte offset %d; files must be UTF-8" i
  | None -> ()

let read_file filepath =
  let filepath = Fpath.(root_dir // filepath) in
  let filepath_str =
    Fpath.rem_prefix root_dir filepath
    |> Option.value ~default:filepath
    |> Fpath.to_string
  in
  Bos.OS.File.read filepath
  |> Result.map (fun r ->
         check_utf_8 filepath_str r;
         Some r)
  |> Result.map_error (fun (`Msg msg) -> failwith msg)
  |> Result.value ~default:None

let read_from_dir glob =
  let file_pattern =
    Fpath.v (Stdlib.String.split_on_char '*' glob |> Stdlib.String.concat "$(f)")
  in
  let results =
    Bos.OS.Path.matches Fpath.(root_dir // file_pattern)
    |> Result.get_ok ~error:(fun (`Msg msg) -> failwith msg)
    |> Stdlib.List.filter_map (fun x ->
           read_file x
           |> Option.map (fun y ->
                  ( x |> Fpath.rem_prefix root_dir |> Option.get
                    |> Fpath.to_string,
                    y )))
  in
  if Stdlib.List.length results = 0 then
    failwith
      ("Did not find any files matching " ^ glob
     ^ "! All data folders need to be listed as dependencies.");
  results

let where path (`Msg err) = `Msg ("data/" ^ path ^ " : " ^ err)

let map_md_files f glob =
  let f (path, data) =
    let* metadata =
      extract_metadata_body path data |> Result.map_error (where path)
    in
    Result.map_error (where path) (f (path, metadata))
  in
  read_from_dir glob
  |> Stdlib.List.fold_left
       (fun u x -> Ok Stdlib.List.cons <@> f x <@> u)
       (Ok [])
  |> Result.map Stdlib.List.rev
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let slugify value =
  value
  |> Stdlib.String.map (function ' ' -> '-' | c -> c)
  |> Stdlib.String.lowercase_ascii |> Stdlib.String.to_seq
  |> Seq.filter (function 'a' .. 'z' | '0' .. '9' | '-' -> true | _ -> false)
  |> Stdlib.String.of_seq

let yaml_file filepath_str =
  let* filepath = filepath_str |> Fpath.of_string in
  let file_opt = read_file filepath in
  let* file =
    Option.to_result ~none:(where filepath_str (`Msg "read failed")) file_opt
  in
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
   Stdlib.List.fold_left
     (fun u x -> Ok Stdlib.List.cons <@> of_yaml x <@> u)
     (Ok []) list)
  |> Result.map_error (where (filepath |> Fpath.to_string))
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)
