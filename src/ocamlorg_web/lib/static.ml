module Last_modified = struct
  (* https://github.com/roburio/unipi/blob/main/unikernel.ml *)
  let ptime_to_http_date ptime =
    let (y, m, d), ((hh, mm, ss), _) = Ptime.to_date_time ptime
    and weekday =
      match Ptime.weekday ptime with
      | `Mon -> "Mon"
      | `Tue -> "Tue"
      | `Wed -> "Wed"
      | `Thu -> "Thu"
      | `Fri -> "Fri"
      | `Sat -> "Sat"
      | `Sun -> "Sun"
    and month =
      [|
        "Jan";
        "Feb";
        "Mar";
        "Apr";
        "May";
        "Jun";
        "Jul";
        "Aug";
        "Sep";
        "Oct";
        "Nov";
        "Dec";
      |]
    in
    let m' = Array.get month (pred m) in
    Printf.sprintf "%s, %02d %s %04d %02d:%02d:%02d GMT" weekday d m' y hh mm ss
end

let not_modified ~last_modified request =
  match Dream.header request "If-Modified-Since" with
  | None -> false
  | Some date -> String.equal date last_modified

let loader ~read ~digest ?(not_cached = []) local_root path request =
  let not_cached = List.mem path not_cached in
  let static_url = Ocamlorg_static.Static_file.of_url_path path in
  let filepath = static_url.filepath in
  let result = read local_root filepath in
  match result with
  | None -> Handler.not_found request
  | Some asset when not_cached ->
      Dream.respond
        ~headers:
          ([ ("Cache-Control", "no-store, max-age=0") ] @ Dream.mime_lookup path)
        asset
  | Some asset ->
      let digest = digest local_root filepath in
      if
        static_url.digest != None
        && not (Option.equal ( = ) digest static_url.digest)
      then
        Dream.log "asset %s exists but digest does not match: %s <> %s" filepath
          (Option.value ~default:"" static_url.digest)
          (Dream.to_base64url (Option.value ~default:"" digest));

      let cache_control =
        if static_url.digest = None then Fmt.str "max-age=%d" (60 * 60 * 24)
          (* one day *)
        else "max-age=31536000, immutable"
      in
      Dream.respond
        ~headers:([ ("Cache-Control", cache_control) ] @ Dream.mime_lookup path)
        asset
