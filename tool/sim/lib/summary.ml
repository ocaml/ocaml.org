(* Post-processing of a run directory.

   What is summarised, and how, depends on the kind of data:

   - Request latencies and GC pauses are many independent events: they are
   summarised by percentiles, inside and outside update windows. A percentile is
   only shown when enough samples lie above it (see [quantile]). - GC pauses are
   also summarised by minimum mutator utilisation (MMU): the worst fraction of
   any time window of a given length left to the program. It captures clusters
   of short pauses that single-pause percentiles miss. - Memory and CPU are time
   series with a trend and a sawtooth, not independent samples, so percentiles
   of them mean little. They are summarised per update cycle instead:
   CPU-seconds spent, peak memory during the update, and the floor reached after
   it. The floors' slope across cycles shows whether memory grows from one
   update to the next. - Update phases come a handful of times per run: min,
   median and max. *)

(* {1 Distributions} *)

let percentile sorted p =
  let n = Array.length sorted in
  if n = 0 then nan
  else
    sorted.(min (n - 1) (int_of_float (ceil (p *. float_of_int n)) - 1 |> max 0))

let quantiles =
  [ (0.5, "p50"); (0.9, "p90"); (0.95, "p95"); (0.99, "p99"); (0.999, "p99.9") ]

(* Number of samples above the [p]-th percentile. *)
let above n p = int_of_float (float_of_int n *. (1. -. p))

(* The [p]-th percentile for display: ["-"] when no sample lies above it (it
   would just be the maximum), and marked with ['*'] when fewer than 10 do (it
   rests on a few outliers). *)
let quantile sorted p =
  let n = Array.length sorted in
  if n = 0 || above n p < 1 then "-"
  else
    Printf.sprintf "%.1f%s" (percentile sorted p)
      (if above n p < 10 then "*" else "")

let distribution sorted =
  String.concat " "
    (List.map
       (fun (p, name) -> Printf.sprintf "%s=%-8s" name (quantile sorted p))
       quantiles
    @ [
        Printf.sprintf "max=%.1f"
          (if Array.length sorted = 0 then nan else percentile sorted 1.);
      ])

let sorted_of_list l =
  let a = Array.of_list l in
  Array.sort compare a;
  a

(* {1 Input files} *)

let ok status =
  match int_of_string_opt status with Some c -> c < 400 | None -> false

type req = { t : float; latency_ms : float; status : string; stream : string }

let rows dir file =
  let path = Filename.concat dir file in
  if Sys.file_exists path then snd (Csv.read path) else []

let read_traffic dir =
  List.filter_map
    (function
      | t :: _ :: lat :: status :: _ :: stream :: _ -> (
          match (float_of_string_opt t, float_of_string_opt lat) with
          | Some t, Some l ->
              Some { t; latency_ms = l *. 1000.; status; stream }
          | _ -> None)
      | _ -> None)
    (rows dir "traffic.csv")

type pause = { start : float; ms : float; kind : string }

let read_pauses dir =
  List.filter_map
    (function
      | t :: kind :: ms :: _ -> (
          match (float_of_string_opt t, float_of_string_opt ms) with
          | Some start, Some ms -> Some { start; ms; kind }
          | _ -> None)
      | _ -> None)
    (rows dir "gc-events.csv")

type sample = {
  st : float;
  mem : float;  (** cgroup memory.current, MB *)
  rss : float;  (** server RSS, MB *)
  cpu : float;  (** % of a core over the second ending at [st] *)
}

let read_resources dir =
  let f s = Option.value ~default:nan (float_of_string_opt s) in
  List.filter_map
    (function
      | t :: mem :: _ :: _ :: _ :: rss :: _ :: cpu :: _ -> (
          match float_of_string_opt t with
          | Some st -> Some { st; mem = f mem; rss = f rss; cpu = f cpu }
          | None -> None)
      | _ -> None)
    (rows dir "resources.csv")
  |> Array.of_list

let read_sync dir =
  List.filter_map
    (function
      | t :: ev :: secs :: detail :: _ ->
          Option.map (fun t -> (t, ev, secs, detail)) (float_of_string_opt t)
      | _ -> None)
    (rows dir "sync.csv")

(* Busy windows: from ["update"] to the following ["saved"] (or ["loaded"] when
   nothing is saved after it). *)
let windows_of_events events =
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

let windows dir =
  windows_of_events (List.map (fun (t, ev, _, _) -> (t, ev)) (read_sync dir))

(* {1 Minimum mutator utilisation} *)

(* Merge possibly overlapping [(start, end)] intervals. *)
let merge ivs =
  let ivs = List.sort compare ivs in
  let rec go acc = function
    | [] -> List.rev acc
    | (s, e) :: tl -> (
        match acc with
        | (s', e') :: acc' when s <= e' -> go ((s', Float.max e e') :: acc') tl
        | _ -> go ((s, e) :: acc) tl)
  in
  Array.of_list (go [] ivs)

(* [mmu ivs ~lo ~hi w] is [Some (u, a)] where [u] is the smallest fraction of
   any window [[a, a + w]] inside [[lo, hi]] not covered by the pause intervals
   [ivs], or [None] if the span is shorter than [w]. The worst window starts at
   a pause start or ends at a pause end, so only those positions are tried. *)
let mmu ivs ~lo ~hi w =
  if hi -. lo < w then None
  else
    let m = merge ivs in
    let n = Array.length m in
    (* prefix.(k): pause time in intervals 0 .. k-1 *)
    let prefix = Array.make (n + 1) 0. in
    Array.iteri (fun k (s, e) -> prefix.(k + 1) <- prefix.(k) +. (e -. s)) m;
    (* pause time in [-inf, x] *)
    let upto x =
      (* last interval starting at or before x *)
      let rec find lo hi =
        if lo >= hi then lo
        else
          let mid = (lo + hi + 1) / 2 in
          if fst m.(mid) <= x then find mid hi else find lo (mid - 1)
      in
      if n = 0 || fst m.(0) > x then 0.
      else
        let k = find 0 (n - 1) in
        let s, e = m.(k) in
        prefix.(k) +. (Float.min x e -. s)
    in
    let clamp a = Float.min (hi -. w) (Float.max lo a) in
    let candidates =
      lo :: (hi -. w)
      :: Array.fold_left
           (fun acc (s, e) -> clamp s :: clamp (e -. w) :: acc)
           [] m
    in
    Some
      (List.fold_left
         (fun (best, at) a ->
           let u = 1. -. ((upto (a +. w) -. upto a) /. w) in
           if u < best then (u, a) else (best, at))
         (1., lo) candidates)

(* {1 Update cycles} *)

type cycle = {
  index : int;
  c_start : float;
  c_end : float;
  cpu_s : float;  (** CPU-seconds used during the update *)
  peak_mem : float;
  peak_rss : float;
  floor_mem : float;  (** lowest memory between this update and the next *)
  floor_rss : float;
  max_pause : float;  (** longest GC pause during the update, ms *)
}

(* CPU-seconds spent in [[a, b]]: each sample is the mean CPU over the second
   before it, weighted by its overlap with the interval. *)
let cpu_seconds samples a b =
  let total = ref 0. in
  Array.iteri
    (fun k s ->
      if k > 0 && not (Float.is_nan s.cpu) then
        let lo = samples.(k - 1).st and hi = s.st in
        let overlap = Float.min hi b -. Float.max lo a in
        if overlap > 0. then total := !total +. (s.cpu /. 100. *. overlap))
    samples;
  !total

let fold_samples samples a b f init =
  Array.fold_left
    (fun acc s -> if s.st >= a && s.st <= b then f acc s else acc)
    init samples

let nanmax a b =
  if Float.is_nan a then b else if Float.is_nan b then a else Float.max a b

let nanmin a b =
  if Float.is_nan a then b else if Float.is_nan b then a else Float.min a b

let cycles ~samples ~pauses ~run_end wins =
  let wins = Array.of_list wins in
  Array.to_list
    (Array.mapi
       (fun i (s, e) ->
         let next =
           if i + 1 < Array.length wins then fst wins.(i + 1) else run_end
         in
         (* a sample at [st] covers the second before it *)
         let peak f =
           fold_samples samples s (e +. 1.) (fun acc x -> nanmax acc (f x)) nan
         in
         let floor f =
           fold_samples samples (e +. 1.) next
             (fun acc x -> nanmin acc (f x))
             nan
         in
         {
           index = i + 1;
           c_start = s;
           c_end = e;
           cpu_s = cpu_seconds samples s e;
           peak_mem = peak (fun x -> x.mem);
           peak_rss = peak (fun x -> x.rss);
           floor_mem = floor (fun x -> x.mem);
           floor_rss = floor (fun x -> x.rss);
           max_pause =
             List.fold_left
               (fun acc p ->
                 if p.start >= s && p.start <= e then nanmax acc p.ms else acc)
               nan pauses;
         })
       wins)

(* Least-squares slope of [ys] against their index. *)
let slope ys =
  let ys = List.filter (fun y -> not (Float.is_nan y)) ys in
  let n = float_of_int (List.length ys) in
  if n < 3. then None
  else
    let xs = List.mapi (fun i _ -> float_of_int i) ys in
    let mean l = List.fold_left ( +. ) 0. l /. n in
    let mx = mean xs and my = mean ys in
    let sxy =
      List.fold_left2 (fun acc x y -> acc +. ((x -. mx) *. (y -. my))) 0. xs ys
    in
    let sxx = List.fold_left (fun acc x -> acc +. ((x -. mx) ** 2.)) 0. xs in
    Some (sxy /. sxx)

(* {1 Output} *)

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
         let lat =
           sorted_of_list
             (List.filter_map
                (fun r -> if ok r.status then Some r.latency_ms else None)
                rs)
         in
         let count p = string_of_int (List.length (List.filter p rs)) in
         Csv.float (float_of_int b *. bucket)
         :: string_of_int (List.length rs)
         :: count (fun r -> r.status <> "drop" && not (ok r.status))
         :: count (fun r -> r.status = "drop")
         :: List.map
              (fun p -> Csv.float (percentile lat p))
              [ 0.5; 0.9; 0.95; 0.99; 0.999; 1.0 ])

let latency_header =
  [
    "t";
    "n";
    "errors";
    "drops";
    "p50_ms";
    "p90_ms";
    "p95_ms";
    "p99_ms";
    "p999_ms";
    "max_ms";
  ]

let cycles_header =
  [
    "cycle";
    "start";
    "duration_s";
    "cpu_s";
    "peak_mem_mb";
    "peak_rss_mb";
    "floor_mem_after_mb";
    "floor_rss_after_mb";
    "max_pause_ms";
  ]

let write_csv path header rows =
  let csv = Csv.create path header in
  List.iter (Csv.row csv) rows;
  Csv.close csv

let run ?(bucket = 5.) dir =
  let file = Filename.concat dir in
  let reqs = read_traffic dir in
  let pauses = read_pauses dir in
  let samples = read_resources dir in
  let sync = read_sync dir in
  let wins = windows dir in
  let run_end =
    if Array.length samples = 0 then 0.
    else samples.(Array.length samples - 1).st
  in
  let busy t = List.exists (fun (s, e) -> t >= s && t <= e) wins in
  let warmup = match wins with (s, e) :: _ -> Some (s, e) | [] -> None in
  let in_warmup t =
    match warmup with Some (s, e) -> t >= s && t <= e | None -> false
  in
  (* files *)
  let streams = List.sort_uniq compare (List.map (fun r -> r.stream) reqs) in
  List.iter
    (fun s ->
      write_csv
        (file ("latency-" ^ s ^ ".csv"))
        latency_header
        (latency_buckets ~bucket (List.filter (fun r -> r.stream = s) reqs)))
    streams;
  write_csv (file "windows.csv") [ "start"; "end" ]
    (List.map (fun (s, e) -> [ Csv.float s; Csv.float e ]) wins);
  (* the same windows as gnuplot shaded rectangles, loaded by plot.gp *)
  let gp = open_out (file "windows.gp") in
  List.iteri
    (fun i (s, e) ->
      Printf.fprintf gp
        "set obj %d rect from %.3f, graph 0 to %.3f, graph 1 behind fc rgb \
         \"#fde9c8\" fs solid 1.0 noborder\n"
        (i + 1) s e)
    wins;
  close_out gp;
  let cs = cycles ~samples ~pauses ~run_end wins in
  write_csv (file "cycles.csv") cycles_header
    (List.map
       (fun c ->
         [
           string_of_int c.index;
           Csv.float c.c_start;
           Csv.float (c.c_end -. c.c_start);
           Csv.float c.cpu_s;
           Csv.float c.peak_mem;
           Csv.float c.peak_rss;
           Csv.float c.floor_mem;
           Csv.float c.floor_rss;
           Csv.float c.max_pause;
         ])
       cs);
  (* text *)
  let b = Buffer.create 4096 in
  let pr fmt = Printf.bprintf b fmt in
  let dist label values =
    let a = sorted_of_list values in
    pr "  %-24s n=%-7d %s\n" label (Array.length a) (distribution a)
  in
  pr "Latency, ms (from scheduled send time; successful responses only)\n";
  List.iter
    (fun s ->
      let rs = List.filter (fun r -> r.stream = s) reqs in
      let failed p = List.length (List.filter p rs) in
      pr "  %s: %d sent, %d errors, %d dropped\n" s (List.length rs)
        (failed (fun r -> r.status <> "drop" && not (ok r.status)))
        (failed (fun r -> r.status = "drop"));
      let lat f =
        List.filter_map
          (fun r -> if ok r.status && f r.t then Some r.latency_ms else None)
          rs
      in
      dist (s ^ " all") (lat (fun _ -> true));
      dist (s ^ " during update") (lat busy);
      dist (s ^ " outside update") (lat (fun t -> not (busy t))))
    streams;
  if pauses <> [] then (
    pr "\nGC pauses, ms\n";
    List.iter
      (fun kind ->
        let ms f =
          List.filter_map
            (fun p -> if p.kind = kind && f p.start then Some p.ms else None)
            pauses
        in
        let name = if kind = "minor" then "minor GC" else "major slice" in
        dist (name ^ " all") (ms (fun _ -> true));
        dist (name ^ " during update") (ms busy);
        dist (name ^ " outside update") (ms (fun t -> not (busy t))))
      [ "minor"; "major" ];
    let ivs =
      List.map (fun p -> (p.start, p.start +. (p.ms /. 1000.))) pauses
    in
    let lo =
      List.fold_left (fun acc p -> Float.min acc p.start) infinity pauses
    in
    let hi =
      Float.max run_end
        (List.fold_left (fun acc (_, e) -> Float.max acc e) lo ivs)
    in
    pr
      "\n\
       Minimum mutator utilisation (worst share of a window left to the program)\n";
    List.iter
      (fun (w, label) ->
        match mmu ivs ~lo ~hi w with
        | None -> ()
        | Some (u, at) ->
            pr "  %-6s %5.1f%%   worst window at t=%.1fs%s\n" label
              (Float.max 0. (u *. 100.))
              at
              (if busy at then " (during update)" else ""))
      [ (0.001, "1 ms"); (0.01, "10 ms"); (0.1, "100 ms"); (1., "1 s") ]);
  if cs <> [] then (
    pr "\nUpdate cycles (update -> saved); #1 is the warm-up full rebuild\n";
    pr "  %-3s %8s %8s %8s %10s %10s %11s %11s %9s\n" "#" "start" "dur s"
      "CPU s" "peak mem" "peak RSS" "floor mem" "floor RSS" "max GC";
    List.iter
      (fun c ->
        pr "  %-3d %8.0f %8.1f %8.1f %10.0f %10.0f %11.0f %11.0f %9.1f\n"
          c.index c.c_start (c.c_end -. c.c_start) c.cpu_s c.peak_mem c.peak_rss
          c.floor_mem c.floor_rss c.max_pause)
      cs;
    pr
      "  (memory in MB, floors are the lowest value between an update and the \
       next, GC in ms)\n";
    let after_warmup = List.filter (fun c -> c.index > 1) cs in
    let median l =
      let a = sorted_of_list l in
      if Array.length a = 0 then nan else percentile a 0.5
    in
    pr "  excluding warm-up: median %.1f s and %.1f CPU-s per update\n"
      (median (List.map (fun c -> c.c_end -. c.c_start) after_warmup))
      (median (List.map (fun c -> c.cpu_s) after_warmup));
    let pr_slope label f =
      match slope (List.map f after_warmup) with
      | Some s -> pr "  %s floor trend: %+.1f MB per update\n" label s
      | None -> pr "  %s floor trend: - (needs 3 cycles after warm-up)\n" label
    in
    pr_slope "RSS" (fun c -> c.floor_rss);
    pr_slope "cgroup memory" (fun c -> c.floor_mem));
  if Array.length samples > 1 then (
    let total = cpu_seconds samples samples.(0).st run_end in
    let in_updates =
      List.fold_left (fun acc (s, e) -> acc +. cpu_seconds samples s e) 0. wins
    in
    let busy_time =
      List.fold_left (fun acc (s, e) -> acc +. (e -. s)) 0. wins
    in
    let idle_time = run_end -. samples.(0).st -. busy_time in
    pr "\nCPU\n";
    pr "  total                  %8.1f CPU-s over %.0f s\n" total
      (run_end -. samples.(0).st);
    pr "  in updates             %8.1f CPU-s (%.0f%%)\n" in_updates
      (if total > 0. then in_updates /. total *. 100. else nan);
    pr "  baseline outside       %8.1f %% of a core\n"
      (if idle_time > 0. then (total -. in_updates) /. idle_time *. 100.
       else nan);
    let peak f = Array.fold_left (fun acc s -> nanmax acc (f s)) nan samples in
    pr "\nMemory peaks\n";
    pr "  cgroup memory          %8.1f MB\n" (peak (fun s -> s.mem));
    pr "  server RSS             %8.1f MB\n" (peak (fun s -> s.rss)));
  (* update phases, excluding the warm-up *)
  let phases =
    List.filter_map
      (fun (t, ev, secs, name) ->
        match (ev, float_of_string_opt secs) with
        | "phase", Some s when not (in_warmup t) -> Some (name, s)
        | _ -> None)
      sync
  in
  if phases <> [] then (
    pr "\nUpdate phases excluding warm-up, s\n";
    List.iter
      (fun name ->
        let a =
          sorted_of_list
            (List.filter_map
               (fun (n, s) -> if n = name then Some s else None)
               phases)
        in
        pr "  %-24s n=%-3d min=%-7.2f median=%-7.2f max=%.2f\n" name
          (Array.length a) a.(0) (percentile a 0.5)
          a.(Array.length a - 1))
      (List.sort_uniq compare (List.map fst phases)));
  pr
    "\n\
     Percentiles: '-' when no sample lies above (it would be the max), '*' \
     when fewer than 10 do.\n";
  let text = Buffer.contents b in
  let oc = open_out (file "summary.txt") in
  output_string oc text;
  close_out oc;
  text
