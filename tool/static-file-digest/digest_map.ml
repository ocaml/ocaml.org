module Digest_map = Map.Make (String)

type t = string Digest_map.t

let empty = Digest_map.empty

(* read all files in directory [file_root] and compute a Map from relative
   filepath to digest *)
let read_directory file_root acc =
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
    let filepath =
      String.sub path (String.length file_root)
        (String.length path - String.length file_root)
    in
    let d = try Some (Digest.file path) with _ -> None in
    match d with Some d -> Digest_map.add filepath d acc | None -> acc
  in
  let files = dir_contents file_root in
  files |> List.fold_left digest acc

let render_ml digest_map =
  let r =
    Digest_map.fold
      (fun key value acc ->
        acc ^ "  | {js|" ^ key ^ "|js} -> Some {js|" ^ value ^ "|js}\n")
      digest_map "let digest filepath =\n  match filepath with\n"
  in
  r ^ "  | _ -> None\n"
