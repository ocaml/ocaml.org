(* Compare two runs, A and B, typically the same simulation against two images.

   - Every number of the two [summary.json] files, side by side, with B - A and
   B / A, and a mark when a percentile on either side rests on fewer than 10
   samples. - The run parameters that differ, apart from the image: if anything
   else differs (seed, speedup, history, profile...), the runs are not
   comparable one to one. - Paired latency: requests are matched by stream and
   [id] (their position in the planned schedule) and the difference B - A is
   summarised per stream. This is the most direct comparison, because each pair
   is the same request at the same offset.

   The result is printed as text and, with [-o], written as JSON. *)

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

type paired = {
  stream : string;
  pairs : int;
  path_mismatches : int;  (** same id, different path: schedules differ *)
  only_ok_in_a : int;
  only_ok_in_b : int;
  b_faster_share : float;
  diff_ms : float array;  (** sorted B - A *)
}

let paired a b =
  let ra = Summary.read_traffic a and rb = Summary.read_traffic b in
  let key (r : Summary.req) = Option.map (fun id -> (r.stream, id)) r.id in
  let tbl = Hashtbl.create 4096 in
  List.iter (fun r -> Option.iter (fun k -> Hashtbl.replace tbl k r) (key r)) ra;
  let streams =
    List.sort_uniq compare (List.map (fun (r : Summary.req) -> r.stream) rb)
  in
  List.map
    (fun s ->
      let mism = ref 0 and only_a = ref 0 and only_b = ref 0 in
      let diffs = ref [] in
      List.iter
        (fun (r : Summary.req) ->
          if r.stream = s then
            match Option.bind (key r) (Hashtbl.find_opt tbl) with
            | None -> ()
            | Some (q : Summary.req) ->
                if q.path <> r.path then incr mism
                else
                  let oa = Summary.ok q.status and ob = Summary.ok r.status in
                  if oa && ob then
                    diffs := (r.latency_ms -. q.latency_ms) :: !diffs
                  else if oa then incr only_a
                  else if ob then incr only_b)
        rb;
      let d = Summary.sorted_of_list !diffs in
      let n = Array.length d in
      {
        stream = s;
        pairs = n;
        path_mismatches = !mism;
        only_ok_in_a = !only_a;
        only_ok_in_b = !only_b;
        b_faster_share =
          (if n = 0 then nan
           else
             float_of_int
               (Array.fold_left (fun c x -> if x < 0. then c + 1 else c) 0 d)
             /. float_of_int n);
        diff_ms = d;
      })
    streams

let load dir name =
  let path = Filename.concat dir name in
  if Sys.file_exists path then Yojson.Safe.from_file path else `Null

let run ?output a b =
  ignore (Summary.run a);
  ignore (Summary.run b);
  let sa = load a "summary.json" and sb = load b "summary.json" in
  let ma = load a "meta.json" and mb = load b "meta.json" in
  let image m =
    match m with
    | `Assoc f -> (
        match List.assoc_opt "image" f with Some (`String s) -> s | _ -> "?")
    | _ -> "?"
  in
  let params = differing_params ma mb in
  let fa = flatten sa and fb = flatten sb in
  (* every metric of A, then those only B has; a missing side is nan *)
  let only_b =
    List.filter
      (fun (p, _, _) -> not (List.exists (fun (q, _, _) -> p = q) fa))
      fb
    |> List.map (fun (p, _, r) -> (p, nan, r))
  in
  let metrics =
    List.filter_map
      (fun (path, x, ra) ->
        match List.find_opt (fun (p, _, _) -> p = path) fb with
        | None -> Some (path, x, nan, ra)
        | Some (_, y, rb) ->
            let reliable =
              match (ra, rb) with
              | Some a, Some b -> Some (a && b)
              | Some a, None | None, Some a -> Some a
              | None, None -> None
            in
            Some (path, x, y, reliable))
      (fa @ only_b)
  in
  let pairs = paired a b in
  let buf = Buffer.create 8192 in
  let pr fmt = Printf.bprintf buf fmt in
  pr "A: %s (%s)\nB: %s (%s)\n" a (image ma) b (image mb);
  if params = [] then pr "Run parameters: identical apart from the image.\n"
  else (
    pr
      "WARNING: run parameters differ; the runs are not comparable one to one:\n";
    List.iter (fun (k, va, vb) -> pr "  %s: A=%s B=%s\n" k va vb) params);
  let num x = if Float.is_finite x then Printf.sprintf "%.3f" x else "-" in
  pr "\n%-58s %12s %12s %12s %8s\n" "metric" "A" "B" "B-A" "B/A";
  List.iter
    (fun (path, x, y, reliable) ->
      pr "%-58s %12s %12s %12s %8s%s\n" path (num x) (num y)
        (num (y -. x))
        (if x <> 0. && Float.is_finite (y /. x) then
           Printf.sprintf "%.2f" (y /. x)
         else "-")
        (if reliable = Some false then "  *" else ""))
    metrics;
  pr "  (* a percentile on at least one side rests on fewer than 10 samples)\n";
  pr "\nPaired latency, B - A in ms, same request (stream, id) in both runs\n";
  List.iter
    (fun p ->
      let q x =
        if p.pairs = 0 then "-" else num (Summary.percentile p.diff_ms x)
      in
      pr
        "  %-6s pairs=%-6d B faster=%5.1f%%  p10=%s p50=%s p90=%s  path \
         mismatches=%d  ok only in A=%d, only in B=%d\n"
        p.stream p.pairs (p.b_faster_share *. 100.) (q 0.1) (q 0.5) (q 0.9)
        p.path_mismatches p.only_ok_in_a p.only_ok_in_b)
    pairs;
  if List.for_all (fun p -> p.pairs = 0) pairs then
    pr "  (no pairs: a run predates request ids, or the schedules differ)\n";
  (match output with
  | None -> ()
  | Some path ->
      let jnum = Summary.jnum in
      let json : Yojson.Safe.t =
        `Assoc
          [
            ("schema", `String "ocamlorg-sim-compare/1");
            ("a", `Assoc [ ("dir", `String a); ("image", `String (image ma)) ]);
            ("b", `Assoc [ ("dir", `String b); ("image", `String (image mb)) ]);
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
            ( "metrics",
              `List
                (List.map
                   (fun (path, x, y, reliable) ->
                     `Assoc
                       [
                         ("metric", `String path);
                         ("a", jnum x);
                         ("b", jnum y);
                         ("b_minus_a", jnum (y -. x));
                         ("b_over_a", if x <> 0. then jnum (y /. x) else `Null);
                         ( "reliable",
                           match reliable with
                           | Some r -> `Bool r
                           | None -> `Null );
                       ])
                   metrics) );
            ( "paired_latency_ms",
              `Assoc
                (List.map
                   (fun p ->
                     let q x =
                       if p.pairs = 0 then `Null
                       else jnum (Summary.percentile p.diff_ms x)
                     in
                     ( p.stream,
                       `Assoc
                         [
                           ("pairs", `Int p.pairs);
                           ("path_mismatches", `Int p.path_mismatches);
                           ("ok_only_in_a", `Int p.only_ok_in_a);
                           ("ok_only_in_b", `Int p.only_ok_in_b);
                           ("b_faster_share", jnum p.b_faster_share);
                           ("b_minus_a_p10", q 0.1);
                           ("b_minus_a_p50", q 0.5);
                           ("b_minus_a_p90", q 0.9);
                         ] ))
                   pairs) );
          ]
      in
      Yojson.Safe.to_file path json);
  Buffer.contents buf
