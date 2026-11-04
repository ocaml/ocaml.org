(* Shorten over-long [description:] front matter in existing Planet posts.

   Posts scraped before [Description] existed may carry a whole article as their
   description (see description.ml). For every post whose description is longer
   than [Description.max_length], this recomputes it with [Description.choose],
   using the stored description as the feed summary, the HTML body stored after
   the front matter as the content, and the live [url:] for the page's meta
   description. Only the [description:] entry is rewritten; the rest of the file
   is left byte for byte. Re-running is a no-op. *)

let planet_dir = Blog_backfill.planet_dir

let fetch_page url =
  try
    Some
      (Http_client.get_sync ~max_random_delay:1.0
         (Uri.of_string (Blog_backfill.clean_url url)))
  with _ -> None

let string_field fields k =
  match List.assoc_opt k fields with Some (`String s) -> Some s | _ -> None

(* Replace the [description:] entry (its key line and its continuation lines:
   indented ones, and blank ones, which a multi-line scalar can contain) of
   front-matter text [fm] with [entry]. The final empty element, left by [fm]'s
   trailing newline, is kept. *)
let replace_description fm entry =
  let lines = String.split_on_char '\n' fm in
  let continuation l = String.length l > 0 && l.[0] = ' ' in
  let rec go = function
    | l :: rest when String.starts_with ~prefix:"description:" l ->
        let rec drop = function
          | l :: rest when continuation l -> drop rest
          | "" :: (_ :: _ as rest) -> drop rest
          | rest -> rest
        in
        entry :: drop rest
    | l :: rest -> l :: go rest
    | [] -> []
  in
  String.concat "\n" (go lines)

(* The YAML text for [description: d], without its trailing newline. *)
let description_entry d =
  match Yaml.to_string (`O [ ("description", `String d) ]) with
  | Ok s -> String.trim s
  | Error (`Msg m) -> failwith m

type outcome = Shortened of string | Unchanged | Failed of string

let process ~dry_run path =
  let contents = Blog_backfill.read_file path in
  match Blog_backfill.split_front_matter contents with
  | None -> Unchanged
  | Some (fm, body) -> (
      match Yaml.of_string fm with
      | Ok (`O fields) -> (
          match
            (string_field fields "description", string_field fields "url")
          with
          | Some old, url
            when String.length (Description.normalize old)
                 > Description.max_length -> (
              let page () = Option.bind url fetch_page in
              match
                Description.choose ~summary:(Some old) ~content:body ~page
              with
              | None -> Unchanged
              | Some d ->
                  let d = Utf_8.replace_invalid d in
                  let fm' = replace_description fm (description_entry d) in
                  (* Never write a file whose front matter no longer decodes to
                     the same fields with the new description. *)
                  let expected =
                    List.map
                      (fun (k, v) ->
                        if k = "description" then (k, `String d) else (k, v))
                      fields
                  in
                  if Yaml.of_string fm' <> Ok (`O expected) then
                    Failed "rewritten front matter does not round-trip"
                  else (
                    if not dry_run then (
                      let oc = open_out_bin path in
                      output_string oc ("---\n" ^ fm' ^ "---\n" ^ body);
                      close_out oc);
                    Shortened d))
          | _ -> Unchanged)
      | _ -> Unchanged)

let run ~dry_run ~source_filter () =
  let sources =
    Sys.readdir planet_dir |> Array.to_list |> List.sort String.compare
    |> List.filter (fun s ->
           Sys.is_directory (Filename.concat planet_dir s)
           && match source_filter with Some f -> f = s | None -> true)
  in
  let count = ref 0 and failed = ref 0 in
  List.iter
    (fun source ->
      let dir = Filename.concat planet_dir source in
      Sys.readdir dir |> Array.to_list |> List.sort String.compare
      |> List.iter (fun fname ->
             if Filename.check_suffix fname ".md" then
               let path = Filename.concat dir fname in
               match process ~dry_run path with
               | Unchanged -> ()
               | Failed why ->
                   incr failed;
                   Printf.printf "%s\n  SKIPPED: %s\n\n%!" path why
               | Shortened d ->
                   incr count;
                   Printf.printf "%s\n  %s\n\n%!" path d))
    sources;
  Printf.printf "%d description(s) %s\n" !count
    (if dry_run then "would be shortened" else "shortened");
  if !failed > 0 then (
    Printf.printf "%d post(s) skipped\n" !failed;
    exit 1)
