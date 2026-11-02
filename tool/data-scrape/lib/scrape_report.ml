(* Commit messages of the bot pull requests.

   Every bot pull request is titled after the first line of its commit message,
   and squash-merging a one-commit pull request keeps that message, so the
   subject is at once the PR title, the notification email subject and the log
   entry. It reads [<area>: <what changed>], the area being the data that
   changed ([planet], [platform], [opam-health]), the rest a headline: counts,
   and the names worth seeing in a list of emails. *)

let max_subject = 72
let plural n word = Printf.sprintf "%d %s%s" n word (if n = 1 then "" else "s")

(* [prefix ^ items ^ suffix], listing as many [items] as fit in [max_subject]
   bytes, and "…" for the rest. *)
let fit ?(sep = ", ") ~prefix ~suffix items =
  let render shown more =
    prefix ^ String.concat sep (shown @ if more then [ "…" ] else []) ^ suffix
  in
  let rec go shown = function
    | [] -> render shown false
    | x :: rest ->
        let shown' = shown @ [ x ] in
        if String.length (render shown' (rest <> [])) <= max_subject then
          go shown' rest
        else render shown true
  in
  go [] items

type entry =
  | New_post of { source_id : string; title : string; keywords : string list }
  | Video_update of { file : string; new_count : int }
  | Error of { source_id : string; message : string }

let post_entries entries =
  List.filter_map
    (function
      | New_post { source_id; title; _ } -> Some (source_id, title) | _ -> None)
    entries

(* The most frequent keywords across the new posts, for a descriptive commit
   subject / PR title. *)
let aggregate_keywords ?(n = 6) entries =
  let tbl = Hashtbl.create 64 in
  List.iter
    (function
      | New_post { keywords; _ } ->
          List.iter
            (fun k ->
              Hashtbl.replace tbl k
                (1 + Option.value ~default:0 (Hashtbl.find_opt tbl k)))
            keywords
      | _ -> ())
    entries;
  Hashtbl.fold (fun k c acc -> (k, c) :: acc) tbl []
  |> List.sort (fun (k1, c1) (k2, c2) ->
         if c1 <> c2 then compare c2 c1 else compare k1 k2)
  |> List.filteri (fun i _ -> i < n)
  |> List.map fst

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

(* [planet: 4 posts (effects, eio, …), 2 videos]: counts, and the most frequent
   keywords of the new posts. *)
let planet_subject entries =
  let posts = List.length (post_entries entries) in
  let videos =
    List.fold_left (fun n (_, k) -> n + k) 0 (video_entries entries)
  in
  let videos_part = if videos > 0 then plural videos "video" else "" in
  if posts > 0 then
    let suffix = if videos > 0 then "), " ^ videos_part else ")" in
    let prefix = "planet: " ^ plural posts "post" in
    match aggregate_keywords entries with
    | [] -> prefix ^ if videos > 0 then ", " ^ videos_part else ""
    | kws -> fit ~prefix:(prefix ^ " (") ~suffix kws
  else if videos > 0 then "planet: " ^ videos_part
  else "planet: no new posts or videos"

let format_commit_message buf entries =
  Buffer.add_string buf (planet_subject entries ^ "\n");
  let posts = post_entries entries in
  let videos = video_entries entries in
  if posts <> [] || videos <> [] then (
    List.iter
      (fun (source_id, title) ->
        Buffer.add_string buf (Printf.sprintf "\n- %s: %s" source_id title))
      posts;
    List.iter
      (fun (file, new_count) ->
        Buffer.add_string buf
          (Printf.sprintf "\n- %s (%s)" file (plural new_count "new video")))
      videos;
    Buffer.add_char buf '\n')

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

let write_commit_message path entries =
  let buf = Buffer.create 256 in
  format_commit_message buf entries;
  write_to_file path (Buffer.contents buf)

let write_report path entries =
  let buf = Buffer.create 256 in
  format_report buf entries;
  write_to_file path (Buffer.contents buf)
