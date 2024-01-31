let root_dir = Fpath.(v (Sys.getcwd ()) // v "data")

let file_list =
  let rec collect_files_from_dir dir =
    match Bos.OS.Dir.contents dir with
    | Ok files ->
        let files =
          files
          |> List.concat_map (fun file ->
                 match Bos.OS.Path.stat file with
                 | Ok stat when not (stat.Unix.st_kind = Unix.S_DIR) -> [ file ]
                 | Ok stat when stat.Unix.st_kind = Unix.S_DIR ->
                     collect_files_from_dir file
                 | _ -> [])
        in
        files
    | Error (`Msg msg) -> failwith msg
  in
  collect_files_from_dir root_dir
  |> List.map (fun file -> Fpath.rem_prefix root_dir file |> Option.get)

let read filepath =
  let filepath = Fpath.(root_dir // filepath) in
  Bos.OS.File.read filepath
  |> Result.map (fun r -> Some r)
  |> Result.map_error (fun (`Msg msg) -> failwith msg)
  |> Result.value ~default:None
