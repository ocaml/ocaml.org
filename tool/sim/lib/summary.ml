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

(* Index of the [p]-th percentile (nearest rank) among [n > 0] sorted
   samples. *)
let rank n p =
  min (n - 1) (int_of_float (ceil (p *. float_of_int n)) - 1 |> max 0)

let percentile sorted p =
  let n = Array.length sorted in
  if n = 0 then nan else sorted.(rank n p)

let quantiles =
  [ (0.5, "p50"); (0.9, "p90"); (0.95, "p95"); (0.99, "p99"); (0.999, "p99.9") ]

(* Number of samples ranked above the [p]-th percentile: counted from its index,
   since [n *. (1. -. p)] truncates wrongly ([1. -. 0.9 < 0.1]). *)
let above n p = if n = 0 then 0 else n - 1 - rank n p

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

(* Requests that count in latency distributions: successful ones, and the two
   kinds that got no answer in time, counted at a lower bound. A timeout counts
   at its measured latency, at least the timeout; a request dropped because
   [max_inflight] were outstanding counts at the timeout, since a real visitor
   would have waited at least that long. Leaving them out would make a build
   that stalls look faster. Errors (failed connections, 4xx, 5xx) stay out. *)
let has_latency status = ok status || status = "timeout" || status = "drop"

(* The client timeout of a run, in seconds: [meta.json], or the default for runs
   that predate it there. *)
let run_timeout dir =
  let path = Filename.concat dir "meta.json" in
  match Yojson.Safe.from_file path with
  | `Assoc kv -> (
      match List.assoc_opt "timeout" kv with
      | Some (`Float f) -> f
      | Some (`Int i) -> float_of_int i
      | _ -> 30.)
  | _ -> 30.
  | exception _ -> 30.

type req = {
  t : float;  (** scheduled send time, seconds since the run started *)
  latency_ms : float;
  status : string;
  stream : string;
  cls : string;
  path : string;
  id : int option;  (** position in its stream; absent in runs before ids *)
}

let rows dir file =
  let path = Filename.concat dir file in
  if Sys.file_exists path then snd (Csv.read path) else []

let read_traffic_file dir =
  let timeout_ms = run_timeout dir *. 1000. in
  List.filter_map
    (function
      | t :: _ :: lat :: status :: _ :: stream :: cls :: path :: rest -> (
          match (float_of_string_opt t, float_of_string_opt lat) with
          | Some t, Some l ->
              let id =
                match rest with i :: _ -> int_of_string_opt i | [] -> None
              in
              let latency_ms =
                if status = "drop" then timeout_ms else l *. 1000.
              in
              Some { t; latency_ms; status; stream; cls; path; id }
          | _ -> None)
      | _ -> None)
    (rows dir "traffic.csv")

type pause = { start : float; ms : float; kind : string }

let read_pauses_file dir =
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
  swap : float;  (** cgroup memory.swap.current, MB *)
  majflt : float;  (** container major page faults per second *)
  stall : float;  (** % of the second the container was stalled on memory *)
  host_avail : float;  (** host MemAvailable, MB *)
  host_swap : float;  (** host swap in use, MB *)
  host_majflt : float;  (** host major page faults per second *)
  host_stall : float;  (** % of the second some host task stalled on memory *)
}

(* A sample at [st] with every value missing. *)
let empty_sample st =
  {
    st;
    mem = nan;
    rss = nan;
    cpu = nan;
    swap = nan;
    majflt = nan;
    stall = nan;
    host_avail = nan;
    host_swap = nan;
    host_majflt = nan;
    host_stall = nan;
  }

(* Runs made before the memory-pressure columns existed read them as [nan]. *)
let read_resources_file dir =
  let f s = Option.value ~default:nan (float_of_string_opt s) in
  List.filter_map
    (function
      | t :: mem :: _ :: _ :: _ :: rss :: _ :: cpu :: rest -> (
          let col k =
            match List.nth_opt rest k with Some s -> f s | None -> nan
          in
          match float_of_string_opt t with
          | Some st ->
              Some
                {
                  st;
                  mem = f mem;
                  rss = f rss;
                  cpu = f cpu;
                  swap = col 0;
                  majflt = col 1;
                  stall = col 2;
                  host_avail = col 3;
                  host_swap = col 4;
                  host_majflt = col 5;
                  host_stall = col 6;
                }
          | None -> None)
      | _ -> None)
    (rows dir "resources.csv")
  |> Array.of_list

(* [f dir], parsed once per command for each version of [dir]'s [file]: [sim
   viz] and [sim compare] read the same run's files from several places, and
   [sim run] summarises and then plots. Keyed by modification time and size, so
   a file that changes is read again. *)
let memo_by_file file f =
  let tbl = Hashtbl.create 8 in
  fun dir ->
    let path = Filename.concat dir file in
    let key =
      match Unix.stat path with
      | s -> (path, s.Unix.st_mtime, s.st_size)
      | exception Unix.Unix_error _ -> (path, 0., -1)
    in
    match Hashtbl.find_opt tbl key with
    | Some v -> v
    | None ->
        let v = f dir in
        Hashtbl.replace tbl key v;
        v

let read_traffic = memo_by_file "traffic.csv" read_traffic_file
let read_pauses = memo_by_file "gc-events.csv" read_pauses_file
let read_resources = memo_by_file "resources.csv" read_resources_file

let read_sync dir =
  List.filter_map
    (function
      | t :: ev :: secs :: detail :: _ ->
          Option.map (fun t -> (t, ev, secs, detail)) (float_of_string_opt t)
      | _ -> None)
    (rows dir "sync.csv")

(* Busy windows: from ["update"] to the following ["saved"] (or ["loaded"] when
   nothing is saved after it). With a separate builder process, the state the
   builder saved is then loaded by the server: a ["reloaded"] after ["saved"],
   before the next ["update"], extends the window to it. *)
let windows_of_events events =
  (* [ext]: the last window ended with ["saved"] and has not been extended *)
  let rec go acc start last ext = function
    | [] -> (
        match (start, last) with
        | Some s, Some e -> List.rev ((s, e) :: acc)
        | _ -> List.rev acc)
    | (t, "update") :: tl -> (
        match (start, last) with
        | Some s, Some e -> go ((s, e) :: acc) (Some t) None false tl
        | _ -> go acc (Some t) None false tl)
    | (t, "loaded") :: tl when start <> None -> go acc start (Some t) ext tl
    | (t, "saved") :: tl -> (
        match start with
        | Some s -> go ((s, t) :: acc) None None true tl
        | None -> go acc None None false tl)
    | (t, "reloaded") :: tl when ext && start = None -> (
        match acc with
        | (s, _) :: rest -> go ((s, t) :: rest) None None false tl
        | [] -> go acc None None false tl)
    | _ :: tl -> go acc start last ext tl
  in
  go [] None None false events

(* The server's load of a state written by a separate builder, logged as a
   timing line once it is done. *)
let reload_phase = "Reload package state"

(* Seconds added after each window's closing log line. The work around saving
   the state does not end exactly with the line that reports it: the largest
   major GC slices of an update land within 0.2 s of it, on either side. *)
let window_grace = 1.

(* The start of an update still running when the log ends: an ["update"] with no
   ["loaded"], ["saved"] or ["failed"] after it. A failed update has ended, like
   one that saved. *)
let unfinished_update events =
  List.fold_left
    (fun acc (t, ev) ->
      match ev with
      | "update" -> Some t
      | "loaded" | "saved" | "failed" -> None
      | _ -> acc)
    None events

(* With [~unfinished:true] (the default), an update still running when the run
   ends gets a window up to the last resource sample, so its time, CPU, requests
   and pauses count as during an update. Per-update statistics ([cycles]) take
   [~unfinished:false]: that update's duration is truncated. *)
let windows ?(unfinished = true) dir =
  let events =
    List.map
      (fun (t, ev, _, detail) ->
        (t, if ev = "phase" && detail = reload_phase then "reloaded" else ev))
      (read_sync dir)
  in
  let closed =
    windows_of_events events |> List.map (fun (s, e) -> (s, e +. window_grace))
  in
  if not unfinished then closed
  else
    let samples = read_resources dir in
    let run_end =
      if Array.length samples = 0 then neg_infinity
      else samples.(Array.length samples - 1).st
    in
    match unfinished_update events with
    | Some s when run_end > s -> closed @ [ (s, run_end) ]
    | _ -> closed

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
                (fun r ->
                  if has_latency r.status then Some r.latency_ms else None)
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

(* {1 Model-oriented outputs}

   [summary.json], [timeline.csv] and [events.csv] hold the same information as
   the text summary and the plot, for a program or a language model to read:
   explicit units in field names, the number of samples behind each percentile,
   a coarse timeline instead of a picture, and the run's notable events as a
   list. They are computed, like everything else here: rerunning the summary on
   the same run directory gives the same files. *)

(* Finite floats rounded to 3 decimals: more would be noise, and cost tokens. *)
let jnum x : Yojson.Safe.t =
  if Float.is_finite x then
    (* [`Float] would print the nearest double in full (71.39400000000001);
       [`Intlit] is written verbatim, and reads back as a float. *)
    `Intlit
      (* 3 decimals from 1 up; below that, 4 significant digits, so that a
         0.0004 ms GC pause does not become 0 *)
      (let s =
         if x = 0. || Float.abs x >= 1. then Printf.sprintf "%.3f" x
         else
           (* "%.4g" may use an exponent (4e-05): valid JSON, kept as is *)
           let g = Printf.sprintf "%.4g" x in
           if String.contains g 'e' || String.contains g '.' then g
           else g ^ ".0"
       in
       (* drop trailing zeros, keeping at least one digit after the point *)
       let rec trim s =
         let n = String.length s in
         if n > 2 && s.[n - 1] = '0' && s.[n - 2] <> '.' then
           trim (String.sub s 0 (n - 1))
         else s
       in
       if String.contains s 'e' then s else trim s)
  else `Null

let json_key = function "p99.9" -> "p999" | name -> name

let dist_json sorted : Yojson.Safe.t =
  let n = Array.length sorted in
  `Assoc
    ([
       ("n", `Int n); ("max", jnum (if n = 0 then nan else percentile sorted 1.));
     ]
    @ List.map
        (fun (p, name) ->
          let k = if n = 0 then 0 else above n p in
          ( json_key name,
            `Assoc
              [
                ("value", if k < 1 then `Null else jnum (percentile sorted p));
                ("samples_above", `Int k);
                ("reliable", `Bool (k >= 10));
              ] ))
        quantiles)

type event = {
  et : float;  (** seconds since the run started *)
  ekind : string;
  value : float;
  unit : string;
  detail : string;
}

(* Latency bursts: requests slower than [burst_ms], grouped when each is
   scheduled within [burst_gap] seconds of the previous one; a group of at least
   [burst_min] is a burst. *)
let burst_ms = 2000.
let burst_gap = 5.
let burst_min = 3

let bursts ~busy reqs =
  let slow =
    List.filter (fun r -> r.status <> "drop" && r.latency_ms > burst_ms) reqs
    |> List.sort (fun a b -> compare a.t b.t)
  in
  let emit group acc =
    let group = List.rev group in
    if List.length group < burst_min then acc
    else
      let first = List.hd group in
      let fin =
        List.fold_left
          (fun m r -> Float.max m (r.t +. (r.latency_ms /. 1000.)))
          neg_infinity group
      in
      let max_ms =
        List.fold_left (fun m r -> Float.max m r.latency_ms) 0. group
      in
      let classes =
        List.map (fun r -> r.stream ^ "/" ^ r.cls) group
        |> List.sort compare
        |> List.fold_left
             (fun acc c ->
               match acc with
               | (c', n) :: tl when c = c' -> (c, n + 1) :: tl
               | _ -> (c, 1) :: acc)
             []
        |> List.rev_map (fun (c, n) -> Printf.sprintf "%s:%d" c n)
        |> String.concat " "
      in
      {
        et = first.t;
        ekind = "latency_burst";
        value = max_ms;
        unit = "ms";
        detail =
          Printf.sprintf "%d requests over %.1f s >%.0f ms; %s%s"
            (List.length group) (fin -. first.t) burst_ms classes
            (if busy first.t then "; during update" else "");
      }
      :: acc
  in
  let rec go acc group last = function
    | [] -> List.rev (emit group acc)
    | r :: tl ->
        if group <> [] && r.t -. last <= burst_gap then
          go acc (r :: group) r.t tl
        else go (emit group acc) [ r ] r.t tl
  in
  go [] [] neg_infinity slow

let read_feed dir =
  List.filter_map
    (function
      | t :: _ :: commits :: _ -> (
          match (float_of_string_opt t, int_of_string_opt commits) with
          | Some t, Some c -> Some (t, c)
          | _ -> None)
      | _ -> None)
    (rows dir "feed.csv")

let read_heap dir =
  List.filter_map
    (function
      | t :: _ :: _ :: _ :: _ :: _ :: _ :: heap :: _ -> (
          match (float_of_string_opt t, float_of_string_opt heap) with
          | Some t, Some h -> Some (t, h)
          | _ -> None)
      | _ -> None)
    (rows dir "gc.csv")

let cell x = if Float.is_finite x then Printf.sprintf "%.1f" x else ""

let timeline ~bin ~run_end ~wins ~samples ~pauses ~reqs ~heap ~feed streams =
  let nbins = int_of_float (ceil (run_end /. bin)) in
  (* Each list is split into bins once: filtering it again for every bin would
     cost bins x events (720 bins x ~10^6 GC pauses in a 2 h run). *)
  let bin_of t = if t < 0. then -1 else int_of_float (t /. bin) in
  let bucket time l =
    let a = Array.make nbins [] in
    List.iter
      (fun x ->
        let k = bin_of (time x) in
        if k >= 0 && k < nbins then a.(k) <- x :: a.(k))
      l;
    Array.map List.rev a
  in
  let pauses_in = bucket (fun p -> p.start) pauses in
  let reqs_in = bucket (fun r -> r.t) reqs in
  let feed_in = bucket fst feed in
  (* the major heap size at the end of each bin: the last sample before it ends
     (samples come in time order) *)
  let heap_at =
    let last = Array.make nbins nan in
    let before = ref nan in
    List.iter
      (fun (t, h) ->
        let k = bin_of t in
        if k < 0 then before := h else if k < nbins then last.(k) <- h)
      heap;
    let acc = ref !before in
    Array.map
      (fun h ->
        if not (Float.is_nan h) then acc := h;
        !acc)
      last
  in
  List.init nbins (fun k ->
      let a = float_of_int k *. bin in
      let b = a +. bin in
      let busy =
        List.fold_left
          (fun acc (s, e) ->
            acc +. Float.max 0. (Float.min b e -. Float.max a s))
          0. wins
      in
      let smax f =
        fold_samples samples (a +. 1e-9) b (fun acc s -> nanmax acc (f s)) nan
      in
      let heap_now = heap_at.(k) in
      let ps = pauses_in.(k) in
      let count kind = List.length (List.filter (fun p -> p.kind = kind) ps) in
      let per_stream s =
        let rs = List.filter (fun r -> r.stream = s) reqs_in.(k) in
        let lat =
          sorted_of_list
            (List.filter_map
               (fun r ->
                 if has_latency r.status then Some r.latency_ms else None)
               rs)
        in
        let n = Array.length lat in
        [
          string_of_int (List.length rs);
          string_of_int (List.length rs - n);
          cell (if n = 0 then nan else percentile lat 0.5);
          cell (if n = 0 then nan else percentile lat 1.);
        ]
      in
      [
        Printf.sprintf "%.0f" a;
        Printf.sprintf "%.2f" (busy /. bin);
        cell (smax (fun s -> s.mem));
        cell (smax (fun s -> s.rss));
        cell heap_now;
        cell (cpu_seconds samples a b /. bin *. 100.);
        string_of_int (count "minor");
        string_of_int (count "major");
        cell (List.fold_left (fun acc p -> acc +. p.ms) 0. ps);
        cell (List.fold_left (fun acc p -> Float.max acc p.ms) 0. ps);
      ]
      @ List.concat_map per_stream streams
      @ [
          string_of_int
            (List.fold_left (fun acc (_, c) -> acc + c) 0 feed_in.(k));
        ])

let timeline_header streams =
  [
    "t";
    "update_share";
    "mem_max_mb";
    "rss_max_mb";
    "heap_mb";
    "cpu_pct";
    "gc_minor_n";
    "gc_major_n";
    "gc_pause_ms";
    "gc_max_ms";
  ]
  @ List.concat_map
      (fun s -> [ s ^ "_n"; s ^ "_failed"; s ^ "_p50_ms"; s ^ "_max_ms" ])
      streams
  @ [ "upstream_commits" ]

(* {1 Everything} *)

let mmu_windows = [ (0.001, "1ms"); (0.01, "10ms"); (0.1, "100ms"); (1., "1s") ]

let run ?(bucket = 5.) ?(bin = 10.) dir =
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
  let streams = List.sort_uniq compare (List.map (fun r -> r.stream) reqs) in
  (* computations *)
  let latency s f =
    sorted_of_list
      (List.filter_map
         (fun r ->
           if r.stream = s && has_latency r.status && f r.t then
             Some r.latency_ms
           else None)
         reqs)
  in
  let counts s =
    let rs = List.filter (fun r -> r.stream = s) reqs in
    let n p = List.length (List.filter p rs) in
    ( List.length rs,
      n (fun r -> r.status <> "drop" && not (ok r.status)),
      n (fun r -> r.status = "drop") )
  in
  let pause_ms kind f =
    sorted_of_list
      (List.filter_map
         (fun p -> if p.kind = kind && f p.start then Some p.ms else None)
         pauses)
  in
  let mmus =
    if pauses = [] then []
    else
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
      List.filter_map
        (fun (w, label) ->
          Option.map
            (fun (u, at) -> (w, label, Float.max 0. u, at))
            (mmu ivs ~lo ~hi w))
        mmu_windows
  in
  (* all windows, so that the floor after the last finished update stops where
     an unfinished one starts; then drop the unfinished one, whose duration and
     CPU are truncated *)
  let finished = List.length (windows ~unfinished:false dir) in
  let cs =
    cycles ~samples ~pauses ~run_end wins
    |> List.filteri (fun i _ -> i < finished)
  in
  let after_warmup = List.filter (fun c -> c.index > 1) cs in
  let median l =
    let a = sorted_of_list l in
    if Array.length a = 0 then nan else percentile a 0.5
  in
  let median_duration =
    median (List.map (fun c -> c.c_end -. c.c_start) after_warmup)
  in
  let median_cpu = median (List.map (fun c -> c.cpu_s) after_warmup) in
  let rss_trend = slope (List.map (fun c -> c.floor_rss) after_warmup) in
  let mem_trend = slope (List.map (fun c -> c.floor_mem) after_warmup) in
  let cpu =
    if Array.length samples < 2 then None
    else
      let total = cpu_seconds samples samples.(0).st run_end in
      let in_updates =
        List.fold_left
          (fun acc (s, e) -> acc +. cpu_seconds samples s e)
          0. wins
      in
      let busy_time =
        List.fold_left (fun acc (s, e) -> acc +. (e -. s)) 0. wins
      in
      let span = run_end -. samples.(0).st in
      let idle_time = span -. busy_time in
      Some
        ( total,
          span,
          in_updates,
          (if total > 0. then in_updates /. total else nan),
          if idle_time > 0. then (total -. in_updates) /. idle_time *. 100.
          else nan )
  in
  let peak f = Array.fold_left (fun acc s -> nanmax acc (f s)) nan samples in
  (* Memory pressure, in the container and on the host. Rates are integrated
     over the interval before each sample; [None] for runs that predate the
     columns. *)
  let integral f =
    let total = ref 0. and seen = ref false in
    Array.iteri
      (fun k s ->
        let v = f s in
        if k > 0 && not (Float.is_nan v) then (
          seen := true;
          total := !total +. (v *. (s.st -. samples.(k - 1).st))))
      samples;
    if !seen then Some !total else None
  in
  let some_peak f =
    let v = peak f in
    if Float.is_nan v then None else Some v
  in
  let some_low f =
    let v = Array.fold_left (fun acc s -> nanmin acc (f s)) nan samples in
    if Float.is_nan v then None else Some v
  in
  let pressure =
    match integral (fun s -> s.majflt) with
    | None -> None
    | Some majflt ->
        let pct_to_s = Option.map (fun v -> v /. 100.) in
        Some
          [
            ("container_swap_peak_mb", some_peak (fun s -> s.swap));
            ("container_major_faults", Some majflt);
            ("container_mem_stall_s", pct_to_s (integral (fun s -> s.stall)));
            ("host_min_available_mb", some_low (fun s -> s.host_avail));
            (* the most swap the run added over what was in use at its start
               (not peak minus lowest: swap freed during the run is no
               growth) *)
            ( "host_swap_growth_mb",
              Option.bind
                (some_peak (fun s -> s.host_swap))
                (fun hi ->
                  Array.find_opt
                    (fun s -> not (Float.is_nan s.host_swap))
                    samples
                  |> Option.map (fun s0 -> Float.max 0. (hi -. s0.host_swap)))
            );
            ("host_major_faults", integral (fun s -> s.host_majflt));
            ("host_mem_stall_s", pct_to_s (integral (fun s -> s.host_stall)));
          ]
  in
  let phases =
    let ps =
      List.filter_map
        (fun (t, ev, secs, name) ->
          match (ev, float_of_string_opt secs) with
          | "phase", Some s when not (in_warmup t) -> Some (name, s)
          | _ -> None)
        sync
    in
    List.map
      (fun name ->
        ( name,
          sorted_of_list
            (List.filter_map
               (fun (n, s) -> if n = name then Some s else None)
               ps) ))
      (List.sort_uniq compare (List.map fst ps))
  in
  (* The commits the server actually loaded, in order: a server that polls at
     other moments, or whose updates take longer, sees other intermediate states
     of the same upstream history. *)
  let loaded_commits =
    List.filter_map
      (fun (t, ev, _, sha) -> if ev = "at" then Some (t, sha) else None)
      sync
  in
  let events =
    let updates =
      List.map
        (fun c ->
          {
            et = c.c_start;
            ekind = "update";
            value = c.c_end -. c.c_start;
            unit = "s";
            detail =
              Printf.sprintf "cycle %d; %.1f CPU-s; peak RSS %.0f MB%s" c.index
                c.cpu_s c.peak_rss
                (if c.index = 1 then "; warm-up full rebuild" else "");
          })
        cs
    in
    let upstream =
      List.map
        (fun (t, n) ->
          {
            et = t;
            ekind = "upstream_advanced";
            value = float_of_int n;
            unit = "commits";
            detail = "";
          })
        (read_feed dir)
    in
    let loaded =
      List.map
        (fun (t, sha) ->
          {
            et = t;
            ekind = "commit_loaded";
            value = 0.;
            unit = "";
            detail = "server now at " ^ sha;
          })
        loaded_commits
    in
    let longest =
      List.sort (fun a b -> compare b.ms a.ms) pauses
      |> List.filteri (fun i _ -> i < 10)
      |> List.map (fun p ->
             {
               et = p.start;
               ekind = "gc_pause";
               value = p.ms;
               unit = "ms";
               detail =
                 ((if p.kind = "minor" then "minor GC" else "major slice")
                 ^ if busy p.start then "; during update" else "");
             })
    in
    List.sort
      (fun a b -> compare a.et b.et)
      (updates @ upstream @ loaded @ longest @ bursts ~busy reqs)
  in
  (* CSV files *)
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
  write_csv (file "timeline.csv") (timeline_header streams)
    (timeline ~bin ~run_end ~wins ~samples ~pauses ~reqs ~heap:(read_heap dir)
       ~feed:(read_feed dir) streams);
  write_csv (file "events.csv")
    [ "t"; "kind"; "value"; "unit"; "detail" ]
    (List.map
       (fun e ->
         [
           Csv.float e.et;
           e.ekind;
           Printf.sprintf "%.3f" e.value;
           e.unit;
           (* keep the CSV unambiguous *)
           String.map (fun c -> if c = ',' then ';' else c) e.detail;
         ])
       events);
  (* summary.json *)
  let meta =
    let path = file "meta.json" in
    if Sys.file_exists path then Yojson.Safe.from_file path else `Null
  in
  let opt_num = function Some x -> jnum x | None -> `Null in
  let json : Yojson.Safe.t =
    `Assoc
      [
        ("schema", `String "ocamlorg-sim-summary/1");
        ("run", meta);
        ( "notes",
          `Assoc
            [
              ("time", `String "seconds since the run started");
              ( "latency",
                `String
                  "from the scheduled send time; successful responses, plus \
                   timeouts (at their latency) and drops (at the timeout) as \
                   lower bounds; errors excluded" );
              ( "percentiles",
                `String
                  "nearest rank; value is null when no sample lies above it; \
                   reliable means at least 10 samples lie above it" );
              ( "update_window",
                `String
                  "from the server's 'Update server state' log line to \
                   'Package state saved' (or, with a separate builder, to the \
                   server's 'Reload package state' that follows), plus 1 s for \
                   the work that ends around that line; an update still \
                   running when the run ends gets a window up to the end but \
                   no cycle; the first one is the warm-up full rebuild" );
              ( "floor",
                `String
                  "lowest memory between the end of an update and the start of \
                   the next" );
              ( "mmu",
                `String
                  "minimum mutator utilisation: the worst share of any window \
                   of that length not spent in a GC pause" );
              ( "latency_burst",
                `String
                  (Printf.sprintf
                     "at least %d requests slower than %.0f ms, each scheduled \
                      within %.0f s of the previous one"
                     burst_min burst_ms burst_gap) );
            ] );
        ( "latency_ms",
          `Assoc
            (List.map
               (fun s ->
                 let sent, errors, dropped = counts s in
                 ( s,
                   `Assoc
                     [
                       ("sent", `Int sent);
                       ("errors", `Int errors);
                       ("dropped", `Int dropped);
                       ("all", dist_json (latency s (fun _ -> true)));
                       ("during_update", dist_json (latency s busy));
                       ( "outside_update",
                         dist_json (latency s (fun t -> not (busy t))) );
                     ] ))
               streams) );
        ( "gc_pause_ms",
          `Assoc
            (List.map
               (fun (kind, name) ->
                 ( name,
                   `Assoc
                     [
                       ("all", dist_json (pause_ms kind (fun _ -> true)));
                       ("during_update", dist_json (pause_ms kind busy));
                       ( "outside_update",
                         dist_json (pause_ms kind (fun t -> not (busy t))) );
                     ] ))
               [ ("minor", "minor"); ("major", "major_slice") ]) );
        ( "mmu",
          `Assoc
            (List.map
               (fun (w, label, u, at) ->
                 ( label,
                   `Assoc
                     [
                       ("window_s", `Float w);
                       ("utilisation", jnum u);
                       ("worst_at_s", jnum at);
                       ("worst_during_update", `Bool (busy at));
                     ] ))
               mmus) );
        ( "cycles",
          `List
            (List.map
               (fun c ->
                 `Assoc
                   [
                     ("cycle", `Int c.index);
                     ("warmup", `Bool (c.index = 1));
                     ("start_s", jnum c.c_start);
                     ("duration_s", jnum (c.c_end -. c.c_start));
                     ("cpu_s", jnum c.cpu_s);
                     ("peak_mem_mb", jnum c.peak_mem);
                     ("peak_rss_mb", jnum c.peak_rss);
                     ("floor_mem_after_mb", jnum c.floor_mem);
                     ("floor_rss_after_mb", jnum c.floor_rss);
                     ("max_gc_pause_ms", jnum c.max_pause);
                   ])
               cs) );
        ( "cycles_excluding_warmup",
          `Assoc
            [
              ("count", `Int (List.length after_warmup));
              ("median_duration_s", jnum median_duration);
              ("median_cpu_s", jnum median_cpu);
              ("rss_floor_trend_mb_per_update", opt_num rss_trend);
              ("mem_floor_trend_mb_per_update", opt_num mem_trend);
            ] );
        ( "loaded_commits",
          `List
            (List.map
               (fun (t, sha) -> `Assoc [ ("t", jnum t); ("sha", `String sha) ])
               loaded_commits) );
        ( "cpu",
          match cpu with
          | None -> `Null
          | Some (total, span, in_updates, share, baseline) ->
              `Assoc
                [
                  ("total_cpu_s", jnum total);
                  ("span_s", jnum span);
                  ("in_updates_cpu_s", jnum in_updates);
                  ("in_updates_share", jnum share);
                  ("baseline_outside_updates_pct_core", jnum baseline);
                ] );
        ( "memory_peak_mb",
          `Assoc
            [
              ("cgroup", jnum (peak (fun s -> s.mem)));
              ("rss", jnum (peak (fun s -> s.rss)));
            ] );
        ( "memory_pressure",
          match pressure with
          | None -> `Null
          | Some kvs ->
              `Assoc
                (List.map
                   (fun (k, v) ->
                     (k, match v with Some v -> jnum v | None -> `Null))
                   kvs) );
        ( "phases_excluding_warmup_s",
          `Assoc
            (List.map
               (fun (name, a) ->
                 ( name,
                   `Assoc
                     [
                       ("n", `Int (Array.length a));
                       ("min", jnum a.(0));
                       ("median", jnum (percentile a 0.5));
                       ("max", jnum a.(Array.length a - 1));
                     ] ))
               phases) );
        ( "events",
          `List
            (List.map
               (fun e ->
                 `Assoc
                   [
                     ("t", jnum e.et);
                     ("kind", `String e.ekind);
                     ("value", jnum e.value);
                     ("unit", `String e.unit);
                     ("detail", `String e.detail);
                   ])
               events) );
      ]
  in
  Yojson.Safe.to_file (file "summary.json") json;
  (* summary.txt *)
  let b = Buffer.create 4096 in
  let pr fmt = Printf.bprintf b fmt in
  let dist label a =
    pr "  %-26s n=%-7d %s\n" label (Array.length a) (distribution a)
  in
  pr
    "Latency, ms (from scheduled send time; timeouts and drops as lower bounds)\n";
  List.iter
    (fun s ->
      let sent, errors, dropped = counts s in
      pr "  %s: %d sent, %d errors, %d dropped\n" s sent errors dropped;
      dist (s ^ " all") (latency s (fun _ -> true));
      dist (s ^ " during update") (latency s busy);
      dist (s ^ " outside update") (latency s (fun t -> not (busy t))))
    streams;
  if pauses <> [] then (
    pr "\nGC pauses, ms\n";
    List.iter
      (fun (kind, name) ->
        dist (name ^ " all") (pause_ms kind (fun _ -> true));
        dist (name ^ " during update") (pause_ms kind busy);
        dist (name ^ " outside update") (pause_ms kind (fun t -> not (busy t))))
      [ ("minor", "minor GC"); ("major", "major slice") ];
    pr
      "\n\
       Minimum mutator utilisation (worst share of a window left to the program)\n";
    List.iter
      (fun (_, label, u, at) ->
        pr "  %-6s %5.1f%%   worst window at t=%.1fs%s\n" label (u *. 100.) at
          (if busy at then " (during update)" else ""))
      mmus);
  if cs <> [] then (
    pr
      "\n\
       Update cycles (update -> saved, or reloaded); #1 is the warm-up full \
       rebuild\n";
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
    pr "  excluding warm-up: median %.1f s and %.1f CPU-s per update\n"
      median_duration median_cpu;
    let pr_slope label = function
      | Some s -> pr "  %s floor trend: %+.1f MB per update\n" label s
      | None -> pr "  %s floor trend: - (needs 3 cycles after warm-up)\n" label
    in
    pr_slope "RSS" rss_trend;
    pr_slope "cgroup memory" mem_trend);
  (match cpu with
  | None -> ()
  | Some (total, span, in_updates, share, baseline) ->
      pr "\nCPU\n";
      pr "  total                  %8.1f CPU-s over %.0f s\n" total span;
      pr "  in updates             %8.1f CPU-s (%.0f%%)\n" in_updates
        (share *. 100.);
      pr "  baseline outside       %8.1f %% of a core\n" baseline;
      pr "\nMemory peaks\n";
      pr "  cgroup memory          %8.1f MB\n" (peak (fun s -> s.mem));
      pr "  server RSS             %8.1f MB\n" (peak (fun s -> s.rss)));
  (match pressure with
  | None -> ()
  | Some kvs ->
      let v k =
        match List.assoc_opt k kvs with
        | Some (Some v) -> Printf.sprintf "%8.1f" v
        | _ -> "       -"
      in
      pr "\nMemory pressure (container; host)\n";
      pr "  swap peak              %s MB\n" (v "container_swap_peak_mb");
      pr "  major page faults      %s; %s\n"
        (v "container_major_faults")
        (v "host_major_faults");
      pr "  stalled on memory      %s s; %s s\n"
        (v "container_mem_stall_s")
        (v "host_mem_stall_s");
      pr "  host available, lowest %s MB\n" (v "host_min_available_mb");
      pr "  host swap growth       %s MB\n" (v "host_swap_growth_mb"));
  if phases <> [] then (
    pr "\nUpdate phases excluding warm-up, s\n";
    List.iter
      (fun (name, a) ->
        pr "  %-24s n=%-3d min=%-7.2f median=%-7.2f max=%.2f\n" name
          (Array.length a) a.(0) (percentile a 0.5)
          a.(Array.length a - 1))
      phases);
  let n_bursts =
    List.length (List.filter (fun e -> e.ekind = "latency_burst") events)
  in
  pr "\nEvents: %d latency bursts (see events.csv)\n" n_bursts;
  pr
    "\n\
     Percentiles: '-' when no sample lies above (it would be the max), '*' \
     when fewer than 10 do.\n";
  let text = Buffer.contents b in
  let oc = open_out (file "summary.txt") in
  output_string oc text;
  close_out oc;
  text
