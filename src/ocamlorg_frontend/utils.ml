let human_date s =
  let open Timedesc in
  try
    let date = Date.of_iso8601_exn s in
    let time = Time.make_exn ~hour:0 ~minute:0 ~second:0 () in
    let date_time =
      Zoneless.make date time |> Zoneless.to_zoned_exn ~tz:Time_zone.utc
    in
    Format.asprintf "%a" (pp ~format:"{day:0X} {mon:Xxx} {year}" ()) date_time
  with Timedesc.ISO8601_parse_exn msg ->
    Logs.err (fun m -> m "Could not parse date %s: %s" s msg);
    s

let human_time s =
  let open Timedesc in
  try
    let date_time = of_iso8601_exn s in
    Format.asprintf "%a" (pp ~format:"{day:0X} {mon:Xxx} {year}" ()) date_time
  with Timedesc.ISO8601_parse_exn msg ->
    Logs.err (fun m -> m "Could not parse date time %s: %s" s msg);
    s

let current_date =
  let open Unix in
  let tm = localtime (Unix.gettimeofday ()) in
  Format.asprintf "%04d-%02d-%02d" (tm.tm_year + 1900) (tm.tm_mon + 1)
    tm.tm_mday

let human_date_of_timestamp t =
  let open Timedesc in
  let ts = Timestamp.of_float_s t in
  Format.asprintf "%a" (Timestamp.pp ~format:"{day:0X} {mon:Xxx} {year}" ()) ts

let host_of_uri uri =
  let uri = Uri.of_string uri in
  Uri.host_with_default uri
