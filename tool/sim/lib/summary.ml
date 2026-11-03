(* Post-processing of a run directory: latency percentiles per time bucket, the
   server's update windows, and a plain-text summary comparing latency inside
   and outside those windows. *)

let percentile sorted p =
  let n = Array.length sorted in
  if n = 0 then nan
  else
    sorted.(min (n - 1) (int_of_float (ceil (p *. float_of_int n)) - 1 |> max 0))

let ok status =
  match int_of_string_opt status with Some c -> c < 400 | None -> false

type req = { t : float; latency_ms : float; status : string; stream : string }

let read_traffic dir =
  let path = Filename.concat dir "traffic.csv" in
  if not (Sys.file_exists path) then []
  else
    let _, rows = Csv.read path in
    List.filter_map
      (function
        | t :: _ :: lat :: status :: _ :: stream :: _ -> (
            match (float_of_string_opt t, float_of_string_opt lat) with
            | Some t, Some l ->
                Some { t; latency_ms = l *. 1000.; status; stream }
            | _ -> None)
        | _ -> None)
      rows

(* Busy windows: from ["update"] to the following ["saved"] (or ["loaded"] when
   nothing is saved after it). *)
let windows dir =
  let path = Filename.concat dir "sync.csv" in
  if not (Sys.file_exists path) then []
  else
    let _, rows = Csv.read path in
    let events =
      List.filter_map
        (function
          | t :: ev :: _ ->
              Option.map (fun t -> (t, ev)) (float_of_string_opt t)
          | _ -> None)
        rows
    in
    let rec go acc start last = function
      | [] -> (
          match (start, last) with
          | Some s, Some e -> List.rev ((s, e) :: acc)
          | _ -> List.rev acc)
      | (t, "update") :: tl -> (
          match (start, last) with
          | Some s, Some e -> go ((s, e) :: acc) (Some t) None tl
          | _ -> go acc (Some t) None tl)
      | (t, "loaded") :: tl when start <> None -> go acc start (Some t) tl
      | (t, "saved") :: tl -> (
          match start with
          | Some s -> go ((s, t) :: acc) None None tl
          | None -> go acc None None tl)
      | _ :: tl -> go acc start last tl
    in
    go [] None None events

let stats reqs =
  let lat =
    List.filter_map
      (fun r -> if ok r.status then Some r.latency_ms else None)
      reqs
    |> Array.of_list
  in
  Array.sort compare lat;
  let count p = List.length (List.filter p reqs) in
  ( List.length reqs,
    count (fun r -> r.status = "drop"),
    count (fun r -> r.status <> "drop" && not (ok r.status)),
    lat )

let latency_buckets ~bucket reqs =
  let tbl = Hashtbl.create 256 in
  List.iter
    (fun r ->
      let b = int_of_float (r.t /. bucket) in
      Hashtbl.replace tbl b
        (r :: Option.value ~default:[] (Hashtbl.find_opt tbl b)))
    reqs;
  Hashtbl.fold (fun b rs acc -> (b, rs) :: acc) tbl []
  |> List.sort compare
  |> List.map (fun (b, rs) ->
         let n, drops, errors, lat = stats rs in
         let p q = Csv.float (percentile lat q) in
         [
           Csv.float (float_of_int b *. bucket);
           string_of_int n;
           string_of_int errors;
           string_of_int drops;
           p 0.5;
           p 0.9;
           p 0.99;
           p 1.0;
         ])

let column dir file name =
  let path = Filename.concat dir file in
  if not (Sys.file_exists path) then [||]
  else
    let header, rows = Csv.read path in
    let rec idx i = function
      | [] -> None
      | h :: _ when h = name -> Some i
      | _ :: tl -> idx (i + 1) tl
    in
    match idx 0 header with
    | None -> [||]
    | Some i ->
        List.filter_map
          (fun r -> Option.bind (List.nth_opt r i) float_of_string_opt)
          rows
        |> Array.of_list

let max_of a = Array.fold_left Float.max neg_infinity a

let mean_of a =
  if Array.length a = 0 then nan
  else Array.fold_left ( +. ) 0. a /. float_of_int (Array.length a)

let run ?(bucket = 5.) dir =
  let reqs = read_traffic dir in
  let streams = List.sort_uniq compare (List.map (fun r -> r.stream) reqs) in
  List.iter
    (fun s ->
      let csv =
        Csv.create
          (Filename.concat dir ("latency-" ^ s ^ ".csv"))
          [
            "t"; "n"; "errors"; "drops"; "p50_ms"; "p90_ms"; "p99_ms"; "max_ms";
          ]
      in
      List.iter (Csv.row csv)
        (latency_buckets ~bucket (List.filter (fun r -> r.stream = s) reqs));
      Csv.close csv)
    streams;
  let wins = windows dir in
  let wcsv =
    Csv.create (Filename.concat dir "windows.csv") [ "start"; "end" ]
  in
  List.iter (fun (s, e) -> Csv.row wcsv [ Csv.float s; Csv.float e ]) wins;
  Csv.close wcsv;
  (* The same windows as gnuplot shaded rectangles, loaded by plot.gp. *)
  let gp = open_out (Filename.concat dir "windows.gp") in
  List.iteri
    (fun i (s, e) ->
      Printf.fprintf gp
        "set obj %d rect from %.3f, graph 0 to %.3f, graph 1 behind fc rgb \
         \"#fde9c8\" fs solid 1.0 noborder\n"
        (i + 1) s e)
    wins;
  close_out gp;
  let busy t = List.exists (fun (s, e) -> t >= s && t <= e) wins in
  let b = Buffer.create 1024 in
  let pr fmt = Printf.bprintf b fmt in
  let line label rs =
    let n, drops, errors, lat = stats rs in
    pr
      "  %-22s n=%-7d err=%-5d drop=%-5d p50=%7.1fms p90=%7.1fms p99=%7.1fms \
       max=%8.1fms\n"
      label n errors drops (percentile lat 0.5) (percentile lat 0.9)
      (percentile lat 0.99) (percentile lat 1.0)
  in
  pr "Latency (from scheduled send time; successful responses only)\n";
  List.iter
    (fun s ->
      let rs = List.filter (fun r -> r.stream = s) reqs in
      line (s ^ " all") rs;
      line (s ^ " during update") (List.filter (fun r -> busy r.t) rs);
      line (s ^ " outside update") (List.filter (fun r -> not (busy r.t)) rs))
    streams;
  pr "\nUpdate windows (update -> saved): %d\n" (List.length wins);
  List.iteri
    (fun i (s, e) ->
      pr "  #%d  t=%.0fs  %.1fs%s\n" (i + 1) s (e -. s)
        (if i = 0 then "  (warm-up: full rebuild)" else ""))
    wins;
  let res = column dir "resources.csv" in
  pr "\nResources\n";
  pr "  cgroup memory peak     %8.1f MB\n" (max_of (res "mem_current_mb"));
  pr "  server RSS peak        %8.1f MB\n" (max_of (res "rss_mb"));
  pr "  CPU mean / max         %8.1f / %.1f %%\n"
    (mean_of (res "cpu_pct"))
    (max_of (res "cpu_pct"));
  let gc = column dir "gc.csv" in
  if Array.length (gc "t") > 0 then (
    pr "\nGC\n";
    pr "  longest minor GC       %8.1f ms\n" (max_of (gc "minor_max_ms"));
    pr "  longest major slice    %8.1f ms\n" (max_of (gc "major_slice_max_ms"));
    pr "  major heap peak        %8.1f MB\n" (max_of (gc "heap_mb")));
  let text = Buffer.contents b in
  let oc = open_out (Filename.concat dir "summary.txt") in
  output_string oc text;
  close_out oc;
  text
