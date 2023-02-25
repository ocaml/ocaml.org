let base_dir = Sys.getcwd () ^ "/../../../../data/"

let read filename =
  let ch = open_in (base_dir ^ filename) in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  Some s

let file_list =
  let rec loop result = function
    | f :: fs when Sys.is_directory f ->
        Sys.readdir f |> Array.to_list
        |> List.map (Filename.concat f)
        |> List.append fs |> loop result
    | f :: fs -> loop (f :: result) fs
    | [] -> result
  in
  let l = String.length base_dir in
  loop [] [ base_dir ]
  |> List.map (fun f -> String.sub f l (String.length f - l))
