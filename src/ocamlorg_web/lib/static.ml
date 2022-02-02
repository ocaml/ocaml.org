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

let max_age = 60 * 60 * 24 * 365 (* one year *)

let loader ~read ~last_modified _root path request =
  let open Lwt.Syntax in
  let* last_modified = last_modified path in
  match last_modified with
  | Error _ -> Handler.not_found request
  | Ok last_modified -> (
      let last_modified =
        Last_modified.ptime_to_http_date (Ptime.v last_modified)
      in
      if not_modified ~last_modified request then
        Dream.respond ~status:`Not_Modified ""
      else
        let* result = read path in
        match result with
        | Error _ -> Handler.not_found request
        | Ok asset ->
            Dream.respond
              ~headers:
                ([
                   ("Cache-Control", Fmt.str "max-age=%d" max_age);
                   ("Last-Modified", last_modified);
                 ]
                @ Dream.mime_lookup path)
              asset)
