(* Compare two runs, A and B, typically the same simulation against two images.

   - Every number of the two [summary.json] files, side by side, with B - A and
   B / A, and a mark when a percentile on either side rests on fewer than 10
   samples. - The run parameters that differ, apart from the image: if anything
   else differs (seed, speedup, history, profile...), the runs are not
   comparable one to one. - Paired latency: requests are matched by stream and
   [id] (their position in the planned schedule) and the difference B - A is
   summarised per stream. This is the most direct comparison, because each pair
   is the same request at the same offset.

   The result is printed as text and, with [-o], written as a single
   [report.json]: the entry point for a program or a language model, with
   reading instructions, definitions, key metrics, every metric, the paired
   breakdowns, both runs' events, and where each run's files are. *)

(* Numeric leaves of a summary, as [(path, value, reliable)]. Percentile objects
   ([value], [samples_above], [reliable]) become one leaf. The run parameters,
   per-cycle details and events are left out: they are not paired. *)
let flatten (j : Yojson.Safe.t) =
  let skip = [ "schema"; "run"; "notes"; "cycles"; "events" ] in
  (* where or how wide a window is, not a measurement *)
  let positional = [ "window_s"; "worst_at_s" ] in
  let rec go path acc (j : Yojson.Safe.t) =
    match j with
    | `Assoc fields when List.mem_assoc "reliable" fields -> (
        let reliable =
          match List.assoc "reliable" fields with `Bool b -> b | _ -> true
        in
        match List.assoc_opt "value" fields with
        | Some (`Float x) -> (path, x, Some reliable) :: acc
        | Some (`Int x) -> (path, float_of_int x, Some reliable) :: acc
        | _ -> (path, nan, Some false) :: acc)
    | `Assoc fields ->
        List.fold_left
          (fun acc (k, v) ->
            if (path = "" && List.mem k skip) || List.mem k positional then acc
            else go (if path = "" then k else path ^ "." ^ k) acc v)
          acc fields
    | `Float x -> (path, x, None) :: acc
    | `Int x -> (path, float_of_int x, None) :: acc
    | _ -> acc
  in
  List.rev (go "" [] j)

let differing_params (a : Yojson.Safe.t) (b : Yojson.Safe.t) =
  let ignore = [ "image"; "image_id"; "started"; "ready_after" ] in
  match (a, b) with
  | `Assoc fa, `Assoc fb ->
      List.filter_map
        (fun (k, va) ->
          if List.mem k ignore then None
          else
            match List.assoc_opt k fb with
            | Some vb when Yojson.Safe.equal va vb -> None
            | vb ->
                Some
                  ( k,
                    Yojson.Safe.to_string va,
                    match vb with
                    | Some v -> Yojson.Safe.to_string v
                    | None -> "absent" ))
        fa
  | _ -> [ ("run", "missing meta.json", "") ]

(* {1 Paired requests} *)

type pair = {
  stream : string;
  cls : string;  (** page class *)
  a_ms : float;
  b_ms : float;
  during_update : bool;  (** in an update window in either run *)
}

type matching = {
  pairs : pair list;  (** both successful *)
  mismatches : int;  (** same id, different path: schedules differ *)
  ok_only_in_a : int;
  ok_only_in_b : int;
}

let in_windows wins t = List.exists (fun (s, e) -> t >= s && t <= e) wins

let match_requests a b =
  let ra = Summary.read_traffic a and rb = Summary.read_traffic b in
  let wa = Summary.windows a and wb = Summary.windows b in
  let key (r : Summary.req) = Option.map (fun id -> (r.stream, id)) r.id in
  let tbl = Hashtbl.create 4096 in
  List.iter (fun r -> Option.iter (fun k -> Hashtbl.replace tbl k r) (key r)) ra;
  List.fold_left
    (fun m (r : Summary.req) ->
      match Option.bind (key r) (Hashtbl.find_opt tbl) with
      | None -> m
      | Some (q : Summary.req) ->
          if q.path <> r.path then { m with mismatches = m.mismatches + 1 }
          else
            let oa = Summary.ok q.status and ob = Summary.ok r.status in
            if oa && ob then
              {
                m with
                pairs =
                  {
                    stream = r.stream;
                    cls = r.cls;
                    a_ms = q.latency_ms;
                    b_ms = r.latency_ms;
                    during_update = in_windows wa q.t || in_windows wb r.t;
                  }
                  :: m.pairs;
              }
            else if oa then { m with ok_only_in_a = m.ok_only_in_a + 1 }
            else if ob then { m with ok_only_in_b = m.ok_only_in_b + 1 }
            else m)
    { pairs = []; mismatches = 0; ok_only_in_a = 0; ok_only_in_b = 0 }
    rb
  |> fun m -> { m with pairs = List.rev m.pairs }

(* A group of pairs: how often B is faster, and the distribution of B - A. *)
type group = {
  n : int;
  b_faster : float;  (** share of pairs where B took less time *)
  diff : float array;  (** sorted B - A, ms *)
}

let group pairs =
  let diff =
    Summary.sorted_of_list (List.map (fun p -> p.b_ms -. p.a_ms) pairs)
  in
  let n = Array.length diff in
  {
    n;
    b_faster =
      (if n = 0 then nan
       else
         float_of_int
           (List.length (List.filter (fun p -> p.b_ms < p.a_ms) pairs))
         /. float_of_int n);
    diff;
  }

(* Fewer pairs than this and a group's figures are flagged as small. *)
let small_group = 20

let by f pairs =
  List.sort_uniq compare (List.map f pairs)
  |> List.map (fun k -> (k, group (List.filter (fun p -> f p = k) pairs)))

(* Are the slow requests the same in both runs? Slow means slower than
   [Summary.burst_ms]. A small overlap means slowness depends on when a request
   arrives rather than on what it asks for. *)
type slow = { both : int; only_a : int; only_b : int; overlap : float }

let slow pairs =
  let t = Summary.burst_ms in
  let count p = List.length (List.filter p pairs) in
  let both = count (fun p -> p.a_ms > t && p.b_ms > t) in
  let only_a = count (fun p -> p.a_ms > t && p.b_ms <= t) in
  let only_b = count (fun p -> p.a_ms <= t && p.b_ms > t) in
  let either = both + only_a + only_b in
  {
    both;
    only_a;
    only_b;
    overlap =
      (if either = 0 then nan else float_of_int both /. float_of_int either);
  }

(* {1 Report} *)

let load dir name =
  let path = Filename.concat dir name in
  if Sys.file_exists path then Yojson.Safe.from_file path else `Null

let member k = function `Assoc f -> List.assoc_opt k f | _ -> None

(* The figures a reader should look at first: (label, metric, which way is
   better). *)
let key_metrics =
  [
    ( "update duration, median after warm-up (s)",
      "cycles_excluding_warmup.median_duration_s",
      "lower" );
    ( "CPU-seconds per update, median",
      "cycles_excluding_warmup.median_cpu_s",
      "lower" );
    ("total CPU-seconds", "cpu.total_cpu_s", "lower");
    ( "CPU baseline outside updates (% of a core)",
      "cpu.baseline_outside_updates_pct_core",
      "lower" );
    ("peak RSS (MB)", "memory_peak_mb.rss", "lower");
    ("peak cgroup memory (MB)", "memory_peak_mb.cgroup", "lower");
    ( "RSS floor trend (MB per update)",
      "cycles_excluding_warmup.rss_floor_trend_mb_per_update",
      "lower" );
    ("MMU, 100 ms window", "mmu.100ms.utilisation", "higher");
    ("MMU, 1 s window", "mmu.1s.utilisation", "higher");
    ( "longest major slice during updates (ms)",
      "gc_pause_ms.major_slice.during_update.max",
      "lower" );
    ("major slice p99.9 (ms)", "gc_pause_ms.major_slice.all.p999", "lower");
    ("minor GC p99.9 (ms)", "gc_pause_ms.minor.all.p999", "lower");
    ("human latency p50 (ms)", "latency_ms.human.all.p50", "lower");
    ("human latency p99 (ms)", "latency_ms.human.all.p99", "lower");
    ("bot latency p50 (ms)", "latency_ms.bot.all.p50", "lower");
    ("bot latency p99 (ms)", "latency_ms.bot.all.p99", "lower");
  ]

let how_to_read =
  [
    "A and B are two runs of the same simulation of the ocaml.org server \
     against two server images. They are comparable one to one only when \
     comparable_one_to_one is true: the run parameters are the same \
     (differing_params is empty) and the inputs block confirms the same \
     requests, the same upstream opam-repository moves and the same \
     documentation server in both runs.";
    "Check inputs.docs_server. With 'stub', every request the server makes to \
     the documentation server gets 404 (no documentation built), so package \
     pages take the no-documentation path: their latencies measure the server \
     without documentation and without the network, not what a visitor sees in \
     production for a package with documentation.";
    "Start with key_metrics. b_over_a below 1 means B is lower; 'better' says \
     which direction is an improvement.";
    "paired_latency_ms compares the same request in both runs: B - A in ms, \
     negative when B was faster. by_stream_and_class and by_stream_and_when \
     break it down; groups with small = true have fewer than 20 pairs.";
    "slow_requests tells whether the requests slower than the burst threshold \
     are the same in both runs. A low overlap means slowness depends on when a \
     request arrived, not on what it asked for.";
    "A percentile with reliable = false rests on fewer than 10 samples above \
     it; treat it as indicative.";
    "The run-to-run noise of a single image is not measured here: treat small \
     differences as unconfirmed until repeated.";
    "loaded_commits lists the opam-repository commits each server actually \
     loaded. Both runs replay the same upstream states at the same offsets, \
     but each server polls on its own schedule (5 s after its previous update \
     ends), so a server with longer updates loads fewer, larger steps. Totals \
     such as total CPU partly reflect that; per-update medians do not.";
    "events lists each run's updates, upstream advances, longest GC pauses and \
     latency bursts; files lists each run's data for detail (timeline.csv \
     first, then the raw CSVs).";
  ]

let paired_definitions =
  [
    ( "docs_stub",
      "a local stand-in for the external documentation server that answers 404 \
       to every request; removes the network and name resolution from the \
       measurements" );
    ( "pair",
      "the same planned request (stream and id, same path) in both runs, \
       successful in both" );
    ( "during_update",
      "the request was scheduled inside an update window in either run" );
    ( "slow_overlap",
      Printf.sprintf
        "of the requests slower than %.0f ms in either run, the share slower \
         in both"
        Summary.burst_ms );
  ]

(* {1 Inputs}

   Whether the two runs had the same inputs, checked rather than assumed from
   their parameters: the same planned requests, the same upstream moves, and the
   same documentation server. *)

type inputs = {
  requests_a : int;
  requests_b : int;
  planned : bool;  (** both runs have request ids (planned schedules) *)
  path_mismatches : int;
  same_traffic : bool;
  moves_a : string list;  (** upstream commits, in order *)
  moves_b : string list;
  same_upstream : bool;
  docs_a : string;
  docs_b : string;
}

let feed_shas dir =
  List.filter_map
    (function _ :: sha :: _ -> Some sha | _ -> None)
    (Summary.rows dir "feed.csv")

let inputs a b =
  let ra = Summary.read_traffic a and rb = Summary.read_traffic b in
  let ids l = List.exists (fun (r : Summary.req) -> r.id <> None) l in
  let m = match_requests a b in
  let docs d =
    match member "docs" (load d "meta.json") with
    | Some (`String x) -> x
    | _ -> "real (not recorded)"
  in
  let planned = ids ra && ids rb in
  let moves_a = feed_shas a and moves_b = feed_shas b in
  {
    requests_a = List.length ra;
    requests_b = List.length rb;
    planned;
    path_mismatches = m.mismatches;
    same_traffic =
      planned && m.mismatches = 0 && List.length ra = List.length rb;
    moves_a;
    moves_b;
    same_upstream = moves_a = moves_b;
    docs_a = docs a;
    docs_b = docs b;
  }

(* For [sim compare]: the largest spread and sd per metric over the given noise
   files (one per image, typically). *)
let load_noise files =
  let tbl = Hashtbl.create 256 in
  List.iter
    (fun f ->
      match Yojson.Safe.from_file f with
      | `Assoc fields -> (
          match List.assoc_opt "metrics" fields with
          | Some (`List ms) ->
              List.iter
                (fun m ->
                  let get k =
                    match member k m with
                    | Some (`Float x) -> x
                    | Some (`Int x) -> float_of_int x
                    | _ -> nan
                  in
                  match member "metric" m with
                  | Some (`String name) ->
                      let sp = get "spread" and sd = get "sd" in
                      let sp0, sd0 =
                        Option.value ~default:(nan, nan)
                          (Hashtbl.find_opt tbl name)
                      in
                      Hashtbl.replace tbl name
                        (Summary.nanmax sp0 sp, Summary.nanmax sd0 sd)
                  | _ -> ())
                ms
          | _ -> ())
      | _ -> ())
    files;
  tbl

let run ?output ?(noise = []) a b =
  let nz = load_noise noise in
  (* [Some true] when |B - A| exceeds the largest spread seen between repeats of
     a single image, [None] without noise data for that metric. *)
  let beyond path x y =
    match Hashtbl.find_opt nz path with
    | Some (sp, _) when Float.is_finite sp && Float.is_finite (y -. x) ->
        (* the numbers come rounded from summary.json and noise.json: allow for
           that rounding *)
        let tol = 0.001 +. (1e-4 *. Float.abs sp) in
        Some (Float.abs (y -. x) > sp +. tol)
    | _ -> None
  in
  let spread_of path =
    match Hashtbl.find_opt nz path with Some (sp, _) -> sp | None -> nan
  in
  ignore (Summary.run a);
  ignore (Summary.run b);
  let sa = load a "summary.json" and sb = load b "summary.json" in
  let ma = load a "meta.json" and mb = load b "meta.json" in
  let image m =
    match member "image" m with Some (`String s) -> s | _ -> "?"
  in
  let params = differing_params ma mb in
  let inp = inputs a b in
  let same_docs = inp.docs_a = inp.docs_b in
  let one_to_one =
    params = [] && inp.same_traffic && inp.same_upstream && same_docs
  in
  let fa = flatten sa and fb = flatten sb in
  (* every metric of A, then those only B has; a missing side is nan *)
  let only_b =
    List.filter
      (fun (p, _, _) -> not (List.exists (fun (q, _, _) -> p = q) fa))
      fb
    |> List.map (fun (p, _, r) -> (p, nan, r))
  in
  let metrics =
    List.map
      (fun (path, x, ra) ->
        match List.find_opt (fun (p, _, _) -> p = path) fb with
        | None -> (path, x, nan, ra)
        | Some (_, y, rb) ->
            let reliable =
              match (ra, rb) with
              | Some a, Some b -> Some (a && b)
              | Some a, None | None, Some a -> Some a
              | None, None -> None
            in
            (path, x, y, reliable))
      (fa @ only_b)
  in
  let loaded s =
    match member "loaded_commits" s with
    | Some (`List l) ->
        List.filter_map
          (fun e ->
            match member "sha" e with Some (`String x) -> Some x | _ -> None)
          l
    | _ -> []
  in
  let la = loaded sa and lb = loaded sb in
  let only_in x y = List.filter (fun s -> not (List.mem s y)) x in
  let common = List.filter (fun s -> List.mem s lb) la in
  let m = match_requests a b in
  let streams = by (fun p -> p.stream) m.pairs in
  let by_class s =
    by (fun p -> p.cls) (List.filter (fun p -> p.stream = s) m.pairs)
  in
  let when_ p = if p.during_update then "during_update" else "outside_update" in
  let by_when s = by when_ (List.filter (fun p -> p.stream = s) m.pairs) in
  let slow_of s = slow (List.filter (fun p -> p.stream = s) m.pairs) in
  (* text *)
  let buf = Buffer.create 8192 in
  let pr fmt = Printf.bprintf buf fmt in
  let num x = if Float.is_finite x then Printf.sprintf "%.3f" x else "-" in
  pr "A: %s (%s)\nB: %s (%s)\n" a (image ma) b (image mb);
  if params = [] then pr "Run parameters: identical apart from the image.\n"
  else (
    pr
      "WARNING: run parameters differ; the runs are not comparable one to one:\n";
    List.iter (fun (k, va, vb) -> pr "  %s: A=%s B=%s\n" k va vb) params);
  let yes c = if c then "same" else "DIFFERENT" in
  pr
    "Inputs: traffic %s (%d vs %d requests, %d path mismatches%s); upstream %s \
     (%d vs %d moves); docs server %s (%s vs %s)\n"
    (yes inp.same_traffic) inp.requests_a inp.requests_b inp.path_mismatches
    (if inp.planned then "" else ", a run predates request ids")
    (yes inp.same_upstream) (List.length inp.moves_a) (List.length inp.moves_b)
    (yes same_docs) inp.docs_a inp.docs_b;
  if not one_to_one then pr "WARNING: the runs are not comparable one to one.\n";
  let short s = if String.length s > 8 then String.sub s 0 8 else s in
  let shas l = String.concat " " (List.map short l) in
  pr
    "\n\
     Commits each server loaded: A %d, B %d, both %d\n\
    \  only A: %s\n\
    \  only B: %s\n"
    (List.length la) (List.length lb) (List.length common)
    (match only_in la lb with [] -> "-" | l -> shas l)
    (match only_in lb la with [] -> "-" | l -> shas l);
  pr "\n%-58s %12s %12s %12s %8s%s\n" "metric" "A" "B" "B-A" "B/A"
    (if noise = [] then "" else Printf.sprintf " %12s" "noise");
  List.iter
    (fun (path, x, y, reliable) ->
      pr "%-58s %12s %12s %12s %8s%s%s%s\n" path (num x) (num y)
        (num (y -. x))
        (if x <> 0. && Float.is_finite (y /. x) then
           Printf.sprintf "%.2f" (y /. x)
         else "-")
        (if noise = [] then ""
         else Printf.sprintf " %12s" (num (spread_of path)))
        (if beyond path x y = Some true then "  !" else "")
        (if reliable = Some false then "  *" else ""))
    metrics;
  pr "  (* a percentile on at least one side rests on fewer than 10 samples)\n";
  if noise <> [] then
    pr "  (! |B-A| exceeds the spread between repeats of one image, from %s)\n"
      (String.concat ", " noise);
  let group_line label g =
    let q x = if g.n = 0 then "-" else num (Summary.percentile g.diff x) in
    pr "  %-28s n=%-6d B faster=%5.1f%%  p10=%-10s p50=%-10s p90=%-10s%s\n"
      label g.n (g.b_faster *. 100.) (q 0.1) (q 0.5) (q 0.9)
      (if g.n < small_group then "  (small)" else "")
  in
  pr "\nPaired latency, B - A in ms, same request (stream, id) in both runs\n";
  pr "  path mismatches=%d, ok only in A=%d, ok only in B=%d\n" m.mismatches
    m.ok_only_in_a m.ok_only_in_b;
  if m.pairs = [] then
    pr "  (no pairs: a run predates request ids, or the schedules differ)\n";
  List.iter
    (fun (s, g) ->
      group_line s g;
      List.iter (fun (w, g) -> group_line ("  " ^ w) g) (by_when s);
      List.iter (fun (c, g) -> group_line ("  class " ^ c) g) (by_class s);
      let sl = slow_of s in
      pr "    slower than %.0f ms: both=%d only A=%d only B=%d overlap=%s\n"
        Summary.burst_ms sl.both sl.only_a sl.only_b
        (if Float.is_finite sl.overlap then
           Printf.sprintf "%.0f%%" (sl.overlap *. 100.)
         else "-"))
    streams;
  (* report.json *)
  (match output with
  | None -> ()
  | Some path ->
      let jnum = Summary.jnum in
      let group_json g : Yojson.Safe.t =
        let q x =
          if g.n = 0 then `Null else jnum (Summary.percentile g.diff x)
        in
        `Assoc
          [
            ("n", `Int g.n);
            ("small", `Bool (g.n < small_group));
            ("b_faster_share", jnum g.b_faster);
            ("b_minus_a_p10", q 0.1);
            ("b_minus_a_p50", q 0.5);
            ("b_minus_a_p90", q 0.9);
          ]
      in
      let groups l = `Assoc (List.map (fun (k, g) -> (k, group_json g)) l) in
      let metric_json (path, x, y, reliable) =
        [
          ("metric", `String path);
          ("a", jnum x);
          ("b", jnum y);
          ("b_minus_a", jnum (y -. x));
          ("b_over_a", if x <> 0. then jnum (y /. x) else `Null);
          ("reliable", match reliable with Some r -> `Bool r | None -> `Null);
        ]
        @
        if noise = [] then []
        else
          [
            ("noise_spread", jnum (spread_of path));
            ( "beyond_noise",
              match beyond path x y with Some v -> `Bool v | None -> `Null );
          ]
      in
      let run_json dir meta : Yojson.Safe.t =
        `Assoc
          [
            ("dir", `String dir);
            ("image", `String (image meta));
            ("parameters", meta);
          ]
      in
      let files dir : Yojson.Safe.t =
        `Assoc
          (List.map
             (fun (k, f) -> (k, `String (Filename.concat dir f)))
             [
               ("summary", "summary.json");
               ("timeline", "timeline.csv");
               ("events", "events.csv");
               ("cycles", "cycles.csv");
               ("requests", "traffic.csv");
               ("gc_pauses", "gc-events.csv");
               ("resources", "resources.csv");
               ("server_log", "server.log");
             ])
      in
      let definitions : Yojson.Safe.t =
        let from_summary =
          match member "notes" sa with Some (`Assoc l) -> l | _ -> []
        in
        `Assoc
          (from_summary
          @ List.map (fun (k, v) -> (k, `String v)) paired_definitions)
      in
      let json : Yojson.Safe.t =
        `Assoc
          [
            ("schema", `String "ocamlorg-sim-report/1");
            ( "how_to_read",
              `List
                (List.map
                   (fun s -> `String s)
                   (how_to_read
                   @
                   if noise = [] then []
                   else
                     [
                       "noise_spread is the largest spread (max - min) of a \
                        metric between repeats of one image (see noise_files). \
                        beyond_noise is true when |B - A| exceeds it: only \
                        those differences are larger than run-to-run noise. \
                        With few repeats the spread underestimates the noise, \
                        so treat differences just above it with care.";
                     ])) );
            ("noise_files", `List (List.map (fun s -> `String s) noise));
            ("runs", `Assoc [ ("a", run_json a ma); ("b", run_json b mb) ]);
            ("comparable_one_to_one", `Bool one_to_one);
            ( "inputs",
              let strs l = `List (List.map (fun x -> `String x) l) in
              `Assoc
                [
                  ( "traffic",
                    `Assoc
                      [
                        ("same", `Bool inp.same_traffic);
                        ("requests_a", `Int inp.requests_a);
                        ("requests_b", `Int inp.requests_b);
                        ("planned_in_both", `Bool inp.planned);
                        ("path_mismatches", `Int inp.path_mismatches);
                      ] );
                  ( "upstream",
                    `Assoc
                      [
                        ("same", `Bool inp.same_upstream);
                        ("moves_a", strs inp.moves_a);
                        ("moves_b", strs inp.moves_b);
                      ] );
                  ( "docs_server",
                    `Assoc
                      [
                        ("same", `Bool same_docs);
                        ("a", `String inp.docs_a);
                        ("b", `String inp.docs_b);
                      ] );
                ] );
            ( "differing_params",
              `List
                (List.map
                   (fun (k, va, vb) ->
                     `Assoc
                       [
                         ("param", `String k);
                         ("a", `String va);
                         ("b", `String vb);
                       ])
                   params) );
            ("definitions", definitions);
            ( "key_metrics",
              `List
                (List.filter_map
                   (fun (label, metric, better) ->
                     List.find_opt (fun (p, _, _, _) -> p = metric) metrics
                     |> Option.map (fun mt ->
                            `Assoc
                              (("label", `String label)
                              :: ("better", `String better)
                              :: metric_json mt)))
                   key_metrics) );
            ( "metrics",
              `List (List.map (fun mt -> `Assoc (metric_json mt)) metrics) );
            ( "paired_latency_ms",
              `Assoc
                [
                  ("path_mismatches", `Int m.mismatches);
                  ("ok_only_in_a", `Int m.ok_only_in_a);
                  ("ok_only_in_b", `Int m.ok_only_in_b);
                  ("by_stream", groups streams);
                  ( "by_stream_and_when",
                    `Assoc
                      (List.map (fun (s, _) -> (s, groups (by_when s))) streams)
                  );
                  ( "by_stream_and_class",
                    `Assoc
                      (List.map
                         (fun (s, _) -> (s, groups (by_class s)))
                         streams) );
                  ( "slow_requests",
                    `Assoc
                      (List.map
                         (fun (s, _) ->
                           let sl = slow_of s in
                           ( s,
                             `Assoc
                               [
                                 ("threshold_ms", jnum Summary.burst_ms);
                                 ("slow_in_both", `Int sl.both);
                                 ("slow_only_in_a", `Int sl.only_a);
                                 ("slow_only_in_b", `Int sl.only_b);
                                 ("slow_overlap", jnum sl.overlap);
                               ] ))
                         streams) );
                ] );
            ( "loaded_commits",
              let strs l = `List (List.map (fun s -> `String s) l) in
              `Assoc
                [
                  ("a", strs la);
                  ("b", strs lb);
                  ("both", `Int (List.length common));
                  ("only_in_a", strs (only_in la lb));
                  ("only_in_b", strs (only_in lb la));
                ] );
            ( "events",
              `Assoc
                [
                  ("a", Option.value ~default:`Null (member "events" sa));
                  ("b", Option.value ~default:`Null (member "events" sb));
                ] );
            ("files", `Assoc [ ("a", files a); ("b", files b) ]);
          ]
      in
      Yojson.Safe.to_file path json);
  Buffer.contents buf
