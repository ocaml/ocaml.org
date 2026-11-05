(* Run-to-run noise: the same simulation of the same image, repeated.

   With the same seed and options, the repeats get the same requests and the
   same upstream moves at the same offsets, so whatever differs between them
   comes from the server and its environment (scheduling, caches, GC timing, the
   machine). For every number in [summary.json], this gives its mean, standard
   deviation, minimum, maximum and spread (max - min) across the repeats; and,
   for latency, the request-by-request differences between the first repeat and
   each other one.

   [sim compare --noise] then marks which A/B differences exceed the spread seen
   between repeats of a single image. *)

type metric = {
  name : string;
  n : int;
  mean : float;
  sd : float;  (** sample standard deviation *)
  min : float;
  max : float;
}

let stats name values =
  let values = List.filter Float.is_finite values in
  let n = List.length values in
  let fn = float_of_int n in
  let mean = if n = 0 then nan else List.fold_left ( +. ) 0. values /. fn in
  let sd =
    if n < 2 then nan
    else
      sqrt
        (List.fold_left (fun acc v -> acc +. ((v -. mean) ** 2.)) 0. values
        /. (fn -. 1.))
  in
  {
    name;
    n;
    mean;
    sd;
    min = List.fold_left Float.min infinity values;
    max = List.fold_left Float.max neg_infinity values;
  }

let spread m = if m.n < 2 then nan else m.max -. m.min

let metrics dirs =
  let flat =
    List.map (fun d -> Compare.flatten (Compare.load d "summary.json")) dirs
  in
  match flat with
  | [] -> []
  | first :: _ ->
      List.map
        (fun (path, _, _) ->
          stats path
            (List.filter_map
               (fun f ->
                 List.find_map
                   (fun (p, v, _) -> if p = path then Some v else None)
                   f)
               flat))
        first

let json_of_metric m : Yojson.Safe.t =
  let n = Summary.jnum in
  `Assoc
    [
      ("metric", `String m.name);
      ("n", `Int m.n);
      ("mean", n m.mean);
      ("sd", n m.sd);
      ("min", n m.min);
      ("max", n m.max);
      ("spread", n (spread m));
      ( "cv",
        if m.mean <> 0. && Float.is_finite m.sd then
          n (Float.abs (m.sd /. m.mean))
        else `Null );
    ]

(* [~summarised:true] when every run in [dirs] has just been summarised. *)
let run ?(summarised = false) ~out dirs =
  if not summarised then List.iter (fun d -> ignore (Summary.run d)) dirs;
  let first = List.hd dirs in
  let image =
    match Compare.member "image" (Compare.load first "meta.json") with
    | Some (`String s) -> s
    | _ -> "?"
  in
  (* the first repeat's requests matched against each other one's, once *)
  let matched =
    List.map (fun d -> (d, Compare.match_requests first d)) (List.tl dirs)
  in
  let inputs =
    List.map (fun (d, m) -> (d, Compare.inputs ~m first d)) matched
  in
  let identical =
    List.for_all
      (fun (_, (i : Compare.inputs)) ->
        i.same_traffic && i.same_upstream && i.docs_a = i.docs_b)
      inputs
  in
  let ms = metrics dirs in
  (* request-level noise: first repeat against each other one, pooled *)
  let pairs =
    List.concat_map (fun (_, (m : Compare.matching)) -> m.pairs) matched
  in
  let streams = Compare.by (fun (p : Compare.pair) -> p.stream) pairs in
  let buf = Buffer.create 4096 in
  let pr fmt = Printf.bprintf buf fmt in
  pr "Run-to-run noise: %s, %d repeats\n" image (List.length dirs);
  pr "Inputs identical across repeats: %s\n"
    (if identical then "yes" else "NO: these runs are not plain repeats");
  pr "\n%-48s %12s %10s %12s %7s\n" "key metric" "mean" "sd" "spread" "cv";
  List.iter
    (fun (label, metric, _) ->
      match List.find_opt (fun m -> m.name = metric) ms with
      | None -> ()
      | Some m ->
          pr "%-48s %12.3f %10.3f %12.3f %6.1f%%\n" label m.mean m.sd (spread m)
            (if m.mean <> 0. then Float.abs (m.sd /. m.mean) *. 100. else nan))
    Compare.repeat_metrics;
  pr "\nSame request across repeats (repeat k - repeat 1, ms), pooled\n";
  List.iter
    (fun (s, (g : Compare.group)) ->
      let q x = if g.n = 0 then nan else Summary.percentile g.diff x in
      pr "  %-6s pairs=%-6d later faster=%5.1f%%  p10=%.3f p50=%.3f p90=%.3f\n"
        s g.n (g.b_faster *. 100.) (q 0.1) (q 0.5) (q 0.9))
    streams;
  let n = Summary.jnum in
  let json : Yojson.Safe.t =
    `Assoc
      [
        ("schema", `String "ocamlorg-sim-noise/1");
        ("image", `String image);
        ("runs", `List (List.map (fun d -> `String d) dirs));
        ("inputs_identical", `Bool identical);
        ( "how_to_read",
          `String
            "The same simulation of one image, repeated with the same seed: \
             same requests and same upstream moves. For each summary number, \
             spread is max - min across the repeats and sd the sample standard \
             deviation. An A/B difference no larger than the spread is within \
             run-to-run noise. paired_latency_ms gives the request-by-request \
             differences between repeats." );
        ("metrics", `List (List.map json_of_metric ms));
        ( "paired_latency_ms",
          `Assoc
            (List.map
               (fun (s, (g : Compare.group)) ->
                 let q x =
                   if g.n = 0 then `Null else n (Summary.percentile g.diff x)
                 in
                 ( s,
                   `Assoc
                     [
                       ("pairs", `Int g.n);
                       ("later_faster_share", n g.b_faster);
                       ("diff_p10", q 0.1);
                       ("diff_p50", q 0.5);
                       ("diff_p90", q 0.9);
                     ] ))
               streams) );
      ]
  in
  Yojson.Safe.to_file (Filename.concat out "noise.json") json;
  let text = Buffer.contents buf in
  let oc = open_out (Filename.concat out "noise.txt") in
  output_string oc text;
  close_out oc;
  text
