(* Whether a doc-modules scrape is due, from the history of past runs.

   The workflow wakes up every hour, but the documentation backend regenerates
   docs in batches, much less often. stats.jsonl holds one record per scrape
   (Stats), including the backend's Last-Modified time of every sidebar fetched.
   Those times are grouped into batches (a gap of more than [batch_gap] seconds
   starts a new one), and the polling interval is a quarter of the median gap
   between batch starts, between [min_interval] and [max_interval]; with fewer
   than [min_batches] batches seen, it is [max_interval]. A run is due when the
   last scrape attempt (aborted ones included) started at least that long ago,
   give or take the 5 minutes by which GitHub's cron drifts. *)

type config = {
  batch_gap : int;
  min_interval : int;
  max_interval : int;
  min_batches : int;
}

let default =
  {
    batch_gap = 7200;
    min_interval = 3600;
    max_interval = 86400;
    min_batches = 3;
  }

type decision = {
  due : bool;
  interval : int;
  batches : int list;  (** batch starts, ascending *)
  median_gap : float option;
  last : int option;  (** start of the last attempt *)
  runs : int;
  aborted : int;
}

let median = function
  | [] -> None
  | l ->
      let a = Array.of_list (List.sort compare l) in
      let n = Array.length a in
      if n mod 2 = 1 then Some (float_of_int a.(n / 2))
      else Some (float_of_int (a.((n / 2) - 1) + a.(n / 2)) /. 2.)

let decide ?(config = default) ~now ~force (runs : Stats.run list) =
  let times =
    List.concat_map
      (fun (r : Stats.run) -> if r.scraped then r.run_last_modified else [])
      runs
    |> List.sort_uniq Int.compare
  in
  let rec starts prev = function
    | [] -> []
    | t :: rest -> (
        match prev with
        | Some p when t - p <= config.batch_gap -> starts (Some t) rest
        | _ -> t :: starts (Some t) rest)
  in
  let batches = starts None times in
  let rec gaps = function
    | a :: (b :: _ as rest) -> (b - a) :: gaps rest
    | _ -> []
  in
  let median_gap = median (gaps batches) in
  let interval =
    match median_gap with
    | Some m when List.length batches >= config.min_batches ->
        let quarter = Float.to_int (Float.floor (m /. 4.)) in
        min (max quarter config.min_interval) config.max_interval
    | _ -> config.max_interval
  in
  let last =
    List.fold_left
      (fun acc (r : Stats.run) ->
        match acc with
        | Some l when l >= r.run_started -> acc
        | _ -> Some r.run_started)
      None runs
  in
  let due =
    force
    || match last with None -> true | Some l -> now - l >= interval - 300
  in
  {
    due;
    interval;
    batches;
    median_gap;
    last;
    runs = List.length runs;
    aborted =
      List.length (List.filter (fun (r : Stats.run) -> not r.scraped) runs);
  }

(* For $GITHUB_OUTPUT. *)
let outputs d =
  Printf.sprintf "due=%b\ninterval=%d\nbatches=%d\n" d.due d.interval
    (List.length d.batches)

let hours seconds =
  let h = Float.round (seconds /. 3600. *. 10.) /. 10. in
  if Float.is_integer h then Printf.sprintf "%.0f" h
  else Printf.sprintf "%.1f" h

let iso8601 t =
  match Ptime.of_float_s (float_of_int t) with
  | Some p ->
      Ptime.to_rfc3339 ~tz_offset_s:0 p |> fun s ->
      (* "2026-01-01T00:00:00-00:00" -> "...Z" *)
      if
        String.ends_with ~suffix:"-00:00" s
        || String.ends_with ~suffix:"+00:00" s
      then String.sub s 0 (String.length s - 6) ^ "Z"
      else s
  | None -> string_of_int t

let summary ~now ~force d =
  let n = List.length d.batches in
  String.concat "\n"
    [
      "### Polling policy";
      "";
      "| | |";
      "| --- | --- |";
      Printf.sprintf "| runs recorded | %d (%d aborted) |" d.runs d.aborted;
      Printf.sprintf "| backend batches seen | %d |" n;
      Printf.sprintf "| median gap between batches | %s |"
        (match d.median_gap with None -> "n/a" | Some m -> hours m ^ " h");
      Printf.sprintf "| polling interval | %s h |"
        (hours (float_of_int d.interval));
      Printf.sprintf "| last attempt | %s |"
        (match d.last with
        | None -> "never"
        | Some l -> hours (float_of_int (now - l)) ^ " h ago");
      Printf.sprintf "| this run | %s |"
        (if force then "due (manual)" else if d.due then "due" else "not due");
      "";
      (if n > 0 then
         "Last batches: "
         ^ String.concat ", "
             (List.map iso8601 (List.filteri (fun i _ -> i >= n - 5) d.batches))
       else "No batch seen yet.");
      "";
    ]
