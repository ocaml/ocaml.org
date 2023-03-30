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

let loader ~read ~digest ?(not_cached = []) local_root path _request =
  let open Lwt.Syntax in
  let open Handler in
  let not_cached = List.mem path not_cached in
  let maybe_static_file = Ocamlorg_static.of_url_path path in
  let</>? static_file = maybe_static_file in
  let filepath = static_file.filepath in
  let* result = read local_root filepath in
  let</>? asset = result in
  if not_cached then
    Dream.respond
      ~headers:
        ([ ("Cache-Control", "no-store, max-age=0") ] @ Dream.mime_lookup path)
      asset
  else
    let digest = digest local_root filepath in
    if
      static_file.digest <> None
      && not (Option.equal ( = ) digest static_file.digest)
    then
      Dream.log "asset %s exists but digest does not match: %s != %s" filepath
        (Option.value ~default:"" static_file.digest)
        (Dream.to_base64url (Option.value ~default:"" digest));

    let cache_control =
      match static_file.digest with
      | None -> "max-age=86400" (* one day *)
      | Some _ -> "max-age=31536000, immutable"
    in
    Dream.respond
      ~headers:([ ("Cache-Control", cache_control) ] @ Dream.mime_lookup path)
      asset
