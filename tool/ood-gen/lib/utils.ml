open Import

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
         try f x
         with exn ->
           let err = Printexc.to_string exn in
           print_endline err;
           prerr_endline ("Error in " ^ file);
           raise exn)

let map_files_with_names f dir =
  read_from_dir dir
  |> List.map (fun (file, x) ->
         try f (file, x)
         with exn ->
           let err = Printexc.to_string exn in
           print_endline err;
           prerr_endline ("Error in " ^ file);
           raise exn)

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""
