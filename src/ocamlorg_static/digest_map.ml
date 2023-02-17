module Digest_map = Map.Make (String)

type t = string Digest_map.t

(* read all files in directory [file_root] and compute a Map from relative
   filepath to digest *)
let read_directory file_root =
  let dir_contents dir =
    let rec loop result = function
      | f :: fs when Sys.is_directory f ->
          Sys.readdir f |> Array.to_list
          |> List.map (Filename.concat f)
          |> List.append fs |> loop result
      | f :: fs -> loop (f :: result) fs
      | [] -> result
    in
    loop [] [ dir ]
  in
  let digest acc path =
    let filepath = Str.replace_first (Str.regexp_string file_root) "" path in
    let d = try Some (Digest.file path) with _ -> None in
    match d with
    | Some d -> Digest_map.add filepath d acc
    | None ->
        Dream.log "failed to compute file digest for: %s" path;
        acc
  in
  let files = dir_contents file_root in
  files |> List.fold_left digest Digest_map.empty

let digest filepath digest_map = Digest_map.find_opt filepath digest_map
