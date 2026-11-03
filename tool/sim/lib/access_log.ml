(* Build a [Profile.t] from web server access logs in the Common or Combined Log
   Format:

   {v 1.2.3.4 - - [03/Nov/2026:13:05:01 +0000] "GET /p/dune HTTP/1.1" 200 5123
   ... v}

   Unlike Plausible, access logs include crawlers, so a profile built from them
   already contains the bot traffic; run the sim with [--bot-rps 0] then. Only
   [GET] requests count. The diurnal shape uses the logged UTC hour. *)

let months =
  [
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
  ]

(* [Some (unix_time, path)] for a [GET] line, [None] otherwise. *)
let parse_line line =
  match (String.index_opt line '[', String.index_opt line '"') with
  | Some lb, Some q when lb < q -> (
      try
        Scanf.sscanf
          (String.sub line lb (String.length line - lb))
          "[%d/%3s/%d:%d:%d:%d %c%2d%2d] \"%s %s "
          (fun day mon year hh mm ss sign tzh tzm meth path ->
            if meth <> "GET" then None
            else
              let month =
                let rec idx i = function
                  | [] -> raise Not_found
                  | m :: _ when m = mon -> i
                  | _ :: tl -> idx (i + 1) tl
                in
                idx 1 months
              in
              let tz = ((tzh * 60) + tzm) * 60 in
              let tz = if sign = '-' then -tz else tz in
              match
                Ptime.of_date_time ((year, month, day), ((hh, mm, ss), tz))
              with
              | Some t -> Some (Ptime.to_float_s t, path)
              | None -> None)
      with Scanf.Scan_failure _ | End_of_file | Failure _ | Not_found -> None)
  | _ -> None

let profile ?(limit = 500) ~source lines =
  let counts = Hashtbl.create 4096 in
  let hours = Array.make 24 0. in
  let first = ref infinity and last = ref neg_infinity and total = ref 0 in
  Seq.iter
    (fun line ->
      match parse_line line with
      | None -> ()
      | Some (t, path) ->
          incr total;
          first := Float.min !first t;
          last := Float.max !last t;
          let h = int_of_float (Float.rem t 86400. /. 3600.) in
          hours.(h) <- hours.(h) +. 1.;
          Hashtbl.replace counts path
            (1 + Option.value ~default:0 (Hashtbl.find_opt counts path)))
    lines;
  if !total = 0 then failwith "no GET request found in the logs";
  let span = Float.max 1. (!last -. !first) in
  let rows =
    Hashtbl.fold (fun p n acc -> ([ p ], float_of_int n) :: acc) counts []
    |> List.sort (fun (_, a) (_, b) -> compare b a)
    |> List.filteri (fun i _ -> i < limit)
  in
  {
    Profile.source;
    base_rps = float_of_int !total /. span;
    hourly = Profile.normalise_hourly hours;
    pages = Plausible.pages ~total:(float_of_int !total) rows;
  }
