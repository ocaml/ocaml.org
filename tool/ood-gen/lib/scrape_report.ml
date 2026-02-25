type entry =
  | New_post of { source_id : string; title : string }
  | Video_update of { file : string; new_count : int }
  | Error of { source_id : string; message : string }

let post_entries entries =
  List.filter_map
    (function
      | New_post { source_id; title } -> Some (source_id, title) | _ -> None)
    entries

let video_entries entries =
  List.filter_map
    (function
      | Video_update { file; new_count } -> Some (file, new_count) | _ -> None)
    entries

let error_entries entries =
  List.filter_map
    (function
      | Error { source_id; message } -> Some (source_id, message) | _ -> None)
    entries

let format_commit_message buf entries =
  let posts = post_entries entries in
  let videos = video_entries entries in
  if posts <> [] || videos <> [] then (
    Buffer.add_string buf "[scrape] New OCaml Planet blog posts and videos\n";
    List.iter
      (fun (source_id, title) ->
        Buffer.add_string buf (Printf.sprintf "\n- %s: %s" source_id title))
      posts;
    List.iter
      (fun (file, new_count) ->
        Buffer.add_string buf
          (Printf.sprintf "\n- %s (%d new video%s)" file new_count
             (if new_count = 1 then "" else "s")))
      videos;
    Buffer.add_char buf '\n')
  else Buffer.add_string buf "[scrape] No new posts or videos\n"

let format_report buf entries =
  let posts = post_entries entries in
  let videos = video_entries entries in
  let errors = error_entries entries in
  if posts <> [] then (
    Buffer.add_string buf "New blog posts:\n";
    List.iter
      (fun (source_id, title) ->
        Buffer.add_string buf (Printf.sprintf "- %s: %s\n" source_id title))
      posts;
    Buffer.add_char buf '\n');
  if videos <> [] then (
    Buffer.add_string buf "Video updates:\n";
    List.iter
      (fun (file, new_count) ->
        Buffer.add_string buf
          (Printf.sprintf "- %s (%d new video%s)\n" file new_count
             (if new_count = 1 then "" else "s")))
      videos;
    Buffer.add_char buf '\n');
  if errors <> [] then (
    Buffer.add_string buf "Scraping errors:\n";
    List.iter
      (fun (source_id, message) ->
        Buffer.add_string buf (Printf.sprintf "- %s: %s\n" source_id message))
      errors;
    Buffer.add_char buf '\n');
  if posts = [] && videos = [] && errors = [] then
    Buffer.add_string buf "No new posts, videos, or errors.\n"

let write_to_file path content =
  let oc = open_out path in
  output_string oc content;
  close_out oc

let append_to_file path content =
  let oc = open_out_gen [ Open_wronly; Open_append; Open_creat ] 0o644 path in
  output_string oc content;
  close_out oc

let write_commit_message path entries =
  let buf = Buffer.create 256 in
  format_commit_message buf entries;
  write_to_file path (Buffer.contents buf)

let write_report path entries =
  let buf = Buffer.create 256 in
  format_report buf entries;
  write_to_file path (Buffer.contents buf)

let append_commit_message path entries =
  let posts = post_entries entries in
  let videos = video_entries entries in
  if posts <> [] || videos <> [] then (
    let buf = Buffer.create 256 in
    List.iter
      (fun (source_id, title) ->
        Buffer.add_string buf (Printf.sprintf "\n- %s: %s" source_id title))
      posts;
    List.iter
      (fun (file, new_count) ->
        Buffer.add_string buf
          (Printf.sprintf "\n- %s (%d new video%s)" file new_count
             (if new_count = 1 then "" else "s")))
      videos;
    Buffer.add_char buf '\n';
    append_to_file path (Buffer.contents buf))

let append_report path entries =
  let buf = Buffer.create 256 in
  format_report buf entries;
  let content = Buffer.contents buf in
  if content <> "" then append_to_file path content
