(* An HTML page comparing two runs visually, with Vega-Lite charts.

   1. Inputs, shown once: requests per 5 s by stream, and upstream moves. When
   the runs are comparable one to one, both had the same inputs; the page checks
   and says so. 2. Raw output, one row per metric, run A above run B on the same
   scales, each with its update windows shaded: CPU, memory, GC pauses, latency.
   3. Comparison views: update cycles lined up at their start, distributions
   (ECDF), summary metrics as ratios, flicker between runs, and the same request
   in both runs.

   The page loads Vega, Vega-Lite and vega-embed (pinned versions) from
   jsDelivr; the data is embedded. Colours: the first two categorical slots of
   the reference palette (validated light), A blue, B orange. *)

let color_a = "#2a78d6"
let color_b = "#eb6834"
let muted = "#898781"
let ink2 = "#52514e"
let grid = "#e1e0d9"
let surface = "#fcfcfb"

(* {1 JSON helpers} *)

let s x : Yojson.Safe.t = `String x
let i x : Yojson.Safe.t = `Int x
let jb x : Yojson.Safe.t = `Bool x
let n = Summary.jnum
let o l : Yojson.Safe.t = `Assoc l
let l x : Yojson.Safe.t = `List x
let schema = ("$schema", s "https://vega.github.io/schema/vega-lite/v5.json")

let config =
  o
    [
      ("background", s surface);
      ("view", o [ ("stroke", `Null) ]);
      ("font", s "sans-serif");
      ( "axis",
        o
          [
            ("gridColor", s grid);
            ("domainColor", s muted);
            ("tickColor", s muted);
            ("labelColor", s ink2);
            ("titleColor", s ink2);
            ("titleFontWeight", s "normal");
          ] );
      ("legend", o [ ("labelColor", s ink2); ("titleColor", s ink2) ]);
      ("header", o [ ("labelColor", s "#0b0b0b"); ("labelFontSize", i 12) ]);
      ("title", o [ ("anchor", s "start"); ("subtitleColor", s ink2) ]);
    ]

(* A subtitle with "\n" in it becomes several lines: Vega-Lite does not wrap. *)
let title text sub =
  let lines = String.split_on_char (Char.chr 10) sub in
  o
    [
      ("text", s text);
      ( "subtitle",
        match lines with [ one ] -> s one | _ -> l (List.map s lines) );
    ]

let run_color ~na ~nb =
  o
    [
      ("field", s "run");
      ("type", s "nominal");
      ("title", s "build");
      ( "scale",
        o
          [
            ("domain", l [ s na; s nb ]); ("range", l [ s color_a; s color_b ]);
          ] );
      ("legend", o [ ("orient", s "top") ]);
    ]

let log_axis values =
  o [ ("values", l (List.map (fun v -> n v) values)); ("format", s "~g") ]

(* {1 Inputs} *)

let feed_rows dir =
  List.filter_map
    (function
      | t :: sha :: _ -> (
          match float_of_string_opt t with
          | Some t -> Some (t, sha)
          | None -> None)
      | _ -> None)
    (Summary.rows dir "feed.csv")

let inputs ~a ~b ~run_end =
  let reqs = Summary.read_traffic a in
  let bins =
    let tbl = Hashtbl.create 256 in
    List.iter
      (fun (r : Summary.req) ->
        let k = (r.stream, int_of_float (r.t /. 5.)) in
        Hashtbl.replace tbl k
          (1 + Option.value ~default:0 (Hashtbl.find_opt tbl k)))
      reqs;
    Hashtbl.fold
      (fun (st, bin) c acc ->
        o
          [
            ("kind", s "req");
            ("stream", s st);
            ("t", n (float_of_int bin *. 5.));
            ("n", i c);
          ]
        :: acc)
      tbl []
  in
  let moves =
    List.map
      (fun (t, sha) ->
        o [ ("kind", s "move"); ("t", n t); ("sha", s (String.sub sha 0 8)) ])
      (feed_rows a)
  in
  let inp = Compare.inputs a b in
  let same_upstream = inp.same_upstream and same_traffic = inp.same_traffic in
  let total_a = List.length reqs in
  let x =
    o
      [
        ("field", s "t");
        ("type", s "quantitative");
        ("title", s "seconds since start");
        ("scale", o [ ("domain", l [ i 0; n run_end ]) ]);
      ]
  in
  let spec =
    o
      [
        schema;
        ( "title",
          title "Inputs (shown once)"
            "requests sent per 5 s by stream (run A's; see the note above), \
             and each upstream opam-repository move (ticks; hover for the \
             commit)" );
        ("data", o [ ("values", l (bins @ moves)) ]);
        ( "vconcat",
          l
            [
              o
                [
                  ("width", i 900);
                  ("height", i 110);
                  ("transform", l [ o [ ("filter", s "datum.kind == 'req'") ] ]);
                  ( "mark",
                    o
                      [
                        ("type", s "line");
                        ("interpolate", s "step-after");
                        ("strokeWidth", i 2);
                      ] );
                  ( "encoding",
                    o
                      [
                        ("x", x);
                        ( "y",
                          o
                            [
                              ("field", s "n");
                              ("type", s "quantitative");
                              ("title", s "requests / 5 s");
                            ] );
                        ( "strokeDash",
                          o
                            [
                              ("field", s "stream");
                              ("type", s "nominal");
                              ( "scale",
                                o
                                  [
                                    ("domain", l [ s "human"; s "bot" ]);
                                    ( "range",
                                      l [ l [ i 1; i 0 ]; l [ i 4; i 3 ] ] );
                                  ] );
                              ("legend", o [ ("orient", s "top") ]);
                            ] );
                        ("color", o [ ("value", s ink2) ]);
                        ( "tooltip",
                          l
                            [
                              o [ ("field", s "stream") ];
                              o [ ("field", s "t"); ("title", s "from (s)") ];
                              o [ ("field", s "n"); ("title", s "requests") ];
                            ] );
                      ] );
                ];
              o
                [
                  ("width", i 900);
                  ("height", i 30);
                  ("transform", l [ o [ ("filter", s "datum.kind == 'move'") ] ]);
                  ( "mark",
                    o
                      [
                        ("type", s "tick");
                        ("color", s "#1baf7a");
                        ("thickness", i 2);
                      ] );
                  ( "encoding",
                    o
                      [
                        ("x", x);
                        ( "tooltip",
                          l
                            [
                              o
                                [
                                  ("field", s "t");
                                  ("title", s "t (s)");
                                  ("format", s ".2f");
                                ];
                              o
                                [
                                  ("field", s "sha");
                                  ("title", s "upstream now at");
                                ];
                            ] );
                      ] );
                ];
            ] );
        ("config", config);
      ]
  in
  (spec, same_traffic, same_upstream, List.length moves, total_a)

(* {1 Raw output} *)

(* One chart: rows of run A then run B (facet), each with its update windows
   shaded under [layer]. [rows] carry a "run" field. *)
let raw_chart ~na ~nb ~wa ~wb ~run_end ~title_ ~sub ~rows ~layer =
  let wins run ws =
    List.map
      (fun (st, e) ->
        o [ ("run", s run); ("kind", s "win"); ("s", n st); ("e", n e) ])
      ws
  in
  o
    [
      schema;
      ("title", title title_ sub);
      ("data", o [ ("values", l (wins na wa @ wins nb wb @ rows)) ]);
      ( "facet",
        o
          [
            ( "row",
              o
                [
                  ("field", s "run");
                  ("type", s "nominal");
                  ("title", `Null);
                  ("sort", l [ s na; s nb ]);
                ] );
          ] );
      ( "spec",
        o
          [
            ("width", i 900);
            ("height", i 120);
            ( "layer",
              l
                [
                  o
                    [
                      ( "transform",
                        l [ o [ ("filter", s "datum.kind == 'win'") ] ] );
                      ( "mark",
                        o
                          [
                            ("type", s "rect");
                            ("color", s grid);
                            ("opacity", n 0.8);
                          ] );
                      ( "encoding",
                        o
                          [
                            ( "x",
                              o
                                [
                                  ("field", s "s");
                                  ("type", s "quantitative");
                                  ("title", s "seconds since start");
                                  ( "scale",
                                    o [ ("domain", l [ i 0; n run_end ]) ] );
                                ] );
                            ("x2", o [ ("field", s "e") ]);
                          ] );
                    ];
                  layer;
                ] );
          ] );
      ("resolve", o [ ("scale", o [ ("y", s "shared") ]) ]);
      ("config", config);
    ]

let raw_charts ~a ~b ~na ~nb ~run_end =
  let wa = Summary.windows a and wb = Summary.windows b in
  let color = run_color ~na ~nb in
  let x = o [ ("field", s "t"); ("type", s "quantitative") ] in
  let samples dir run =
    Array.to_list (Summary.read_resources dir)
    |> List.filter_map (fun (x : Summary.sample) ->
           if Float.is_nan x.cpu then None
           else
             Some
               (o
                  [
                    ("run", s run);
                    ("kind", s "cpu");
                    ("t", n x.st);
                    ("v", n x.cpu);
                  ]))
  in
  let cpu =
    raw_chart ~na ~nb ~wa ~wb ~run_end ~title_:"CPU"
      ~sub:"% of a core, 1 s samples; shaded = update windows"
      ~rows:(samples a na @ samples b nb)
      ~layer:
        (o
           [
             ("transform", l [ o [ ("filter", s "datum.kind == 'cpu'") ] ]);
             ("mark", o [ ("type", s "line"); ("strokeWidth", n 1.5) ]);
             ( "encoding",
               o
                 [
                   ("x", x);
                   ( "y",
                     o
                       [
                         ("field", s "v");
                         ("type", s "quantitative");
                         ("title", s "CPU (% of a core)");
                       ] );
                   ("color", color);
                   ( "tooltip",
                     l
                       [
                         o [ ("field", s "run") ];
                         o [ ("field", s "t"); ("format", s ".0f") ];
                         o
                           [
                             ("field", s "v");
                             ("title", s "CPU %");
                             ("format", s ".0f");
                           ];
                       ] );
                 ] );
           ])
  in
  let memory dir run =
    let res = Array.to_list (Summary.read_resources dir) in
    let heap = Summary.read_heap dir in
    List.concat_map
      (fun (x : Summary.sample) ->
        List.filter_map
          (fun (series, v) ->
            if Float.is_nan v then None
            else
              Some
                (o
                   [
                     ("run", s run);
                     ("kind", s "mem");
                     ("series", s series);
                     ("t", n x.st);
                     ("v", n v);
                   ]))
          [ ("server RSS", x.rss); ("container (cgroup)", x.mem) ])
      res
    @ List.map
        (fun (t, h) ->
          o
            [
              ("run", s run);
              ("kind", s "mem");
              ("series", s "OCaml major heap");
              ("t", n t);
              ("v", n h);
            ])
        heap
  in
  let mem =
    raw_chart ~na ~nb ~wa ~wb ~run_end ~title_:"Memory"
      ~sub:
        "MB; solid = server RSS, dashed = OCaml major heap, dotted = whole \
         container (cgroup)"
      ~rows:(memory a na @ memory b nb)
      ~layer:
        (o
           [
             ("transform", l [ o [ ("filter", s "datum.kind == 'mem'") ] ]);
             ("mark", o [ ("type", s "line"); ("strokeWidth", n 1.5) ]);
             ( "encoding",
               o
                 [
                   ("x", x);
                   ( "y",
                     o
                       [
                         ("field", s "v");
                         ("type", s "quantitative");
                         ("title", s "MB");
                       ] );
                   ("color", color);
                   ( "strokeDash",
                     o
                       [
                         ("field", s "series");
                         ("type", s "nominal");
                         ("title", `Null);
                         ( "scale",
                           o
                             [
                               ( "domain",
                                 l
                                   [
                                     s "server RSS";
                                     s "OCaml major heap";
                                     s "container (cgroup)";
                                   ] );
                               ( "range",
                                 l
                                   [
                                     l [ i 1; i 0 ];
                                     l [ i 6; i 3 ];
                                     l [ i 1; i 2 ];
                                   ] );
                             ] );
                         ("legend", o [ ("orient", s "top") ]);
                       ] );
                   ( "tooltip",
                     l
                       [
                         o [ ("field", s "run") ];
                         o [ ("field", s "series") ];
                         o [ ("field", s "t"); ("format", s ".0f") ];
                         o
                           [
                             ("field", s "v");
                             ("title", s "MB");
                             ("format", s ".0f");
                           ];
                       ] );
                 ] );
           ])
  in
  let threshold = 0.5 in
  let pauses dir run =
    let ps = Summary.read_pauses dir in
    ( List.length ps,
      List.filter_map
        (fun (p : Summary.pause) ->
          if p.ms < threshold then None
          else
            Some
              (o
                 [
                   ("run", s run);
                   ("kind", s "gc");
                   ( "gc",
                     s (if p.kind = "minor" then "minor GC" else "major slice")
                   );
                   ("t", n p.start);
                   ("v", n p.ms);
                 ]))
        ps )
  in
  let na_total, pa = pauses a na and nb_total, pb = pauses b nb in
  let gc =
    raw_chart ~na ~nb ~wa ~wb ~run_end ~title_:"GC pauses"
      ~sub:
        (Printf.sprintf
           "every pause of at least %.1f ms (%d of %d in %s, %d of %d in %s); \
            circle = minor GC, triangle = major slice; log scale"
           threshold (List.length pa) na_total na (List.length pb) nb_total nb)
      ~rows:(pa @ pb)
      ~layer:
        (o
           [
             ("transform", l [ o [ ("filter", s "datum.kind == 'gc'") ] ]);
             ( "mark",
               o
                 [
                   ("type", s "point");
                   ("filled", jb true);
                   ("size", i 14);
                   ("opacity", n 0.6);
                 ] );
             ( "encoding",
               o
                 [
                   ("x", x);
                   ( "y",
                     o
                       [
                         ("field", s "v");
                         ("type", s "quantitative");
                         ("title", s "pause (ms, log)");
                         ("scale", o [ ("type", s "log") ]);
                         ( "axis",
                           log_axis [ 0.5; 1.; 2.; 5.; 10.; 20.; 50.; 100. ] );
                       ] );
                   ("color", color);
                   ( "shape",
                     o
                       [
                         ("field", s "gc");
                         ("type", s "nominal");
                         ("title", `Null);
                         ( "scale",
                           o
                             [
                               ("domain", l [ s "minor GC"; s "major slice" ]);
                               ("range", l [ s "circle"; s "triangle-up" ]);
                             ] );
                         ("legend", o [ ("orient", s "top") ]);
                       ] );
                   ( "tooltip",
                     l
                       [
                         o [ ("field", s "run") ];
                         o [ ("field", s "gc") ];
                         o [ ("field", s "t"); ("format", s ".2f") ];
                         o
                           [
                             ("field", s "v");
                             ("title", s "ms");
                             ("format", s ".2f");
                           ];
                       ] );
                 ] );
           ])
  in
  let requests dir run =
    List.filter_map
      (fun (r : Summary.req) ->
        if not (Summary.ok r.status) then None
        else
          Some
            (o
               [
                 ("run", s run);
                 ("kind", s "req");
                 ("stream", s r.stream);
                 ("cls", s r.cls);
                 ("t", n r.t);
                 ("v", n (Float.max 0.1 r.latency_ms));
               ]))
      (Summary.read_traffic dir)
  in
  let lat =
    raw_chart ~na ~nb ~wa ~wb ~run_end ~title_:"Request latency"
      ~sub:
        "every successful request, by scheduled send time; circle = human, \
         square = bot; log scale"
      ~rows:(requests a na @ requests b nb)
      ~layer:
        (o
           [
             ("transform", l [ o [ ("filter", s "datum.kind == 'req'") ] ]);
             ( "mark",
               o
                 [
                   ("type", s "point");
                   ("filled", jb true);
                   ("size", i 14);
                   ("opacity", n 0.55);
                 ] );
             ( "encoding",
               o
                 [
                   ("x", x);
                   ( "y",
                     o
                       [
                         ("field", s "v");
                         ("type", s "quantitative");
                         ("title", s "latency (ms, log)");
                         ("scale", o [ ("type", s "log") ]);
                         ("axis", log_axis [ 1.; 10.; 100.; 1000.; 10000. ]);
                       ] );
                   ("color", color);
                   ( "shape",
                     o
                       [
                         ("field", s "stream");
                         ("type", s "nominal");
                         ("title", `Null);
                         ( "scale",
                           o
                             [
                               ("domain", l [ s "human"; s "bot" ]);
                               ("range", l [ s "circle"; s "square" ]);
                             ] );
                         ("legend", o [ ("orient", s "top") ]);
                       ] );
                   ( "tooltip",
                     l
                       [
                         o [ ("field", s "run") ];
                         o [ ("field", s "stream") ];
                         o [ ("field", s "cls"); ("title", s "page class") ];
                         o [ ("field", s "t"); ("format", s ".2f") ];
                         o
                           [
                             ("field", s "v");
                             ("title", s "ms");
                             ("format", s ".1f");
                           ];
                       ] );
                 ] );
           ])
  in
  [ ("CPU", cpu); ("Memory", mem); ("GC pauses", gc); ("Request latency", lat) ]

(* {1 Comparison views} *)

(* Update cycles lined up at their start, warm-up excluded. *)
let epoch_rows dir run =
  let wins = Summary.windows dir in
  let res = Summary.read_resources dir in
  let reqs = Summary.read_traffic dir in
  List.concat
    (List.mapi
       (fun k (st, _) ->
         if k = 0 then []
         else
           let base =
             Array.fold_left
               (fun acc (x : Summary.sample) ->
                 if x.st <= st && not (Float.is_nan x.rss) then x.rss else acc)
               nan res
           in
           let rs =
             Array.to_list res
             |> List.filter_map (fun (x : Summary.sample) ->
                    let d = x.st -. st in
                    if
                      d >= -10. && d <= 45.
                      && not (Float.is_nan x.cpu || Float.is_nan x.rss)
                    then
                      Some
                        (o
                           [
                             ("run", s run);
                             ("cycle", i k);
                             ("t", n d);
                             ("cpu", n x.cpu);
                             ("drss", n (x.rss -. base));
                           ])
                    else None)
           in
           let ls =
             List.filter_map
               (fun (r : Summary.req) ->
                 let d = r.t -. st in
                 if d >= -10. && d <= 45. && Summary.ok r.status then
                   Some
                     (o
                        [
                          ("run", s run);
                          ("cycle", i k);
                          ("t", n d);
                          ("latency", n (Float.max 0.1 r.latency_ms));
                          ("stream", s r.stream);
                        ])
                 else None)
               reqs
           in
           rs @ ls)
       wins)

let epoch_spec ~na ~nb rows =
  let color = run_color ~na ~nb in
  let rule =
    o
      [
        ("data", o [ ("values", l [ o [ ("x", i 0) ] ]) ]);
        ( "mark",
          o
            [
              ("type", s "rule");
              ("color", s muted);
              ("strokeDash", l [ i 4; i 3 ]);
            ] );
        ( "encoding",
          o [ ("x", o [ ("field", s "x"); ("type", s "quantitative") ]) ] );
      ]
  in
  let xdom title_ =
    o
      [
        ("field", s "t");
        ("type", s "quantitative");
        ("title", title_);
        ("scale", o [ ("domain", l [ i (-10); i 45 ]) ]);
      ]
  in
  let panel field ytitle =
    let valid = o [ ("filter", s ("isValid(datum." ^ field ^ ")")) ] in
    let med =
      [
        valid;
        o [ ("calculate", s "round(datum.t)"); ("as", s "tb") ];
        o
          [
            ( "aggregate",
              l [ o [ ("op", s "median"); ("field", s field); ("as", s "m") ] ]
            );
            ("groupby", l [ s "run"; s "tb" ]);
          ];
      ]
    in
    o
      [
        ("width", i 640);
        ("height", i 150);
        ( "layer",
          l
            [
              o
                [
                  ("transform", l [ valid ]);
                  ( "mark",
                    o
                      [
                        ("type", s "line");
                        ("strokeWidth", i 1);
                        ("opacity", n 0.25);
                        ("interpolate", s "monotone");
                      ] );
                  ( "encoding",
                    o
                      [
                        ("x", xdom `Null);
                        ( "y",
                          o
                            [
                              ("field", s field);
                              ("type", s "quantitative");
                              ("title", s ytitle);
                            ] );
                        ("detail", o [ ("field", s "cycle") ]);
                        ("color", color);
                      ] );
                ];
              o
                [
                  ("transform", l med);
                  ( "mark",
                    o
                      [
                        ("type", s "line");
                        ("strokeWidth", i 2);
                        ("interpolate", s "monotone");
                      ] );
                  ( "encoding",
                    o
                      [
                        ( "x",
                          o [ ("field", s "tb"); ("type", s "quantitative") ] );
                        ("y", o [ ("field", s "m"); ("type", s "quantitative") ]);
                        ("color", color);
                      ] );
                ];
              o
                [
                  ("transform", l med);
                  ( "mark",
                    o
                      [
                        ("type", s "point");
                        ("size", i 80);
                        ("opacity", i 0);
                        ("filled", jb true);
                      ] );
                  ( "encoding",
                    o
                      [
                        ( "x",
                          o [ ("field", s "tb"); ("type", s "quantitative") ] );
                        ("y", o [ ("field", s "m"); ("type", s "quantitative") ]);
                        ("color", color);
                        ( "tooltip",
                          l
                            [
                              o [ ("field", s "run") ];
                              o
                                [
                                  ("field", s "tb");
                                  ("title", s "s from update start");
                                ];
                              o
                                [
                                  ("field", s "m");
                                  ("title", s "median over cycles");
                                  ("format", s ".1f");
                                ];
                            ] );
                      ] );
                ];
              rule;
            ] );
      ]
  in
  o
    [
      schema;
      ( "title",
        title "A typical update, both builds"
          "every update after the warm-up, lined up at its start (dashed); \
           thin = one cycle, thick = median" );
      ("data", o [ ("values", l rows) ]);
      ( "vconcat",
        l
          [
            panel "cpu" "CPU (% of a core)";
            panel "drss" "RSS change since update start (MB)";
            o
              [
                ("width", i 640);
                ("height", i 170);
                ( "layer",
                  l
                    [
                      o
                        [
                          ( "transform",
                            l [ o [ ("filter", s "isValid(datum.latency)") ] ]
                          );
                          ( "mark",
                            o
                              [
                                ("type", s "point");
                                ("filled", jb true);
                                ("size", i 14);
                                ("opacity", n 0.35);
                              ] );
                          ( "encoding",
                            o
                              [
                                ("x", xdom (s "seconds from update start"));
                                ( "y",
                                  o
                                    [
                                      ("field", s "latency");
                                      ("type", s "quantitative");
                                      ("title", s "request latency (ms, log)");
                                      ("scale", o [ ("type", s "log") ]);
                                      ( "axis",
                                        log_axis
                                          [ 1.; 10.; 100.; 1000.; 10000. ] );
                                    ] );
                                ("color", color);
                                ( "tooltip",
                                  l
                                    [
                                      o [ ("field", s "run") ];
                                      o [ ("field", s "stream") ];
                                      o
                                        [
                                          ("field", s "t"); ("format", s ".1f");
                                        ];
                                      o
                                        [
                                          ("field", s "latency");
                                          ("format", s ".1f");
                                        ];
                                    ] );
                              ] );
                        ];
                      rule;
                    ] );
              ];
          ] );
      ("config", config);
    ]

(* ECDF: 200 quantiles per series. *)
let ecdf_rows ?(src = "compared") dir run =
  let q name values =
    let a = Summary.sorted_of_list values in
    let len = Array.length a in
    if len = 0 then []
    else
      List.init 200 (fun k ->
          let p = (float_of_int k +. 0.5) /. 200. in
          let idx =
            max 0 (min (len - 1) (int_of_float (p *. float_of_int len) - 1))
          in
          o
            [
              ("run", s run);
              ("src", s src);
              ("series", s name);
              ("q", n p);
              ("value", n (Float.max 0.001 a.(idx)));
            ])
  in
  let ps = Summary.read_pauses dir in
  let gc k =
    List.filter_map
      (fun (p : Summary.pause) -> if p.kind = k then Some p.ms else None)
      ps
  in
  q "minor GC pause (ms)" (gc "minor") @ q "major slice (ms)" (gc "major")

let ecdf_spec ?(repeats = false) ~na ~nb rows =
  let color = run_color ~na ~nb in
  let compared = o [ ("filter", s "datum.src == 'compared'") ] in
  o
    [
      schema;
      ( "title",
        title "GC pause distributions: ECDF, log x"
          ("share of pauses at or below each duration; the right end is the \
            tail"
          ^
          if repeats then
            "; thin lines = the noise runs (repeats of each image), thick = \
             the two runs compared"
          else "") );
      ("data", o [ ("values", l rows) ]);
      ( "facet",
        o
          [
            ("field", s "series");
            ("type", s "nominal");
            ("title", `Null);
            ("sort", l [ s "minor GC pause (ms)"; s "major slice (ms)" ]);
          ] );
      ("columns", i 2);
      ("resolve", o [ ("scale", o [ ("x", s "independent") ]) ]);
      ( "spec",
        o
          [
            ("width", i 300);
            ("height", i 180);
            ( "layer",
              l
                [
                  (* the noise runs, thin, behind *)
                  o
                    [
                      ( "transform",
                        l [ o [ ("filter", s "datum.src != 'compared'") ] ] );
                      ( "mark",
                        o
                          [
                            ("type", s "line");
                            ("strokeWidth", i 1);
                            ("opacity", n 0.35);
                            ("interpolate", s "step-after");
                          ] );
                      ( "encoding",
                        o
                          [
                            ( "x",
                              o
                                [
                                  ("field", s "value");
                                  ("type", s "quantitative");
                                ] );
                            ( "y",
                              o [ ("field", s "q"); ("type", s "quantitative") ]
                            );
                            ("detail", o [ ("field", s "src") ]);
                            ("color", color);
                          ] );
                    ];
                  o
                    [
                      ("transform", l [ compared ]);
                      ( "mark",
                        o
                          [
                            ("type", s "line");
                            ("strokeWidth", i 2);
                            ("interpolate", s "step-after");
                          ] );
                      ( "encoding",
                        o
                          [
                            ( "x",
                              o
                                [
                                  ("field", s "value");
                                  ("type", s "quantitative");
                                  ("title", `Null);
                                  ("scale", o [ ("type", s "log") ]);
                                  ( "axis",
                                    o [ ("tickCount", i 5); ("format", s "~g") ]
                                  );
                                ] );
                            ( "y",
                              o
                                [
                                  ("field", s "q");
                                  ("type", s "quantitative");
                                  ("title", s "share ≤ value");
                                  ("axis", o [ ("format", s "%") ]);
                                ] );
                            ("color", color);
                          ] );
                    ];
                  o
                    [
                      ("transform", l [ compared ]);
                      ( "mark",
                        o
                          [
                            ("type", s "point");
                            ("size", i 60);
                            ("opacity", i 0);
                            ("filled", jb true);
                          ] );
                      ( "encoding",
                        o
                          [
                            ( "x",
                              o
                                [
                                  ("field", s "value");
                                  ("type", s "quantitative");
                                ] );
                            ( "y",
                              o [ ("field", s "q"); ("type", s "quantitative") ]
                            );
                            ("color", color);
                            ( "tooltip",
                              l
                                [
                                  o [ ("field", s "run") ];
                                  o
                                    [
                                      ("field", s "q");
                                      ("title", s "quantile");
                                      ("format", s ".1%");
                                    ];
                                  o
                                    [
                                      ("field", s "value"); ("format", s ".2f");
                                    ];
                                ] );
                          ] );
                    ];
                ] );
          ] );
      ("config", config);
    ]

(* {2 Latency views: split, overlaid, merged}

   The latency charts share a signal [lv]: "split" (one panel per stream),
   "overlaid" (both streams in one panel, told apart by dash or shape) or
   "merged" (one panel, all requests together). A merged distribution is not a
   mix of the per-stream ones, so the ECDF data carries a third, "all", stream.
   The page sets [lv] on every chart from one control. *)

let lv_param = o [ ("name", s "lv"); ("value", s "split") ]

(* Which rows a view shows, and in which panel. *)
let lv_transforms =
  [
    o [ ("filter", s "(lv == 'merged') == (datum.stream == 'all')") ];
    o
      [
        ( "calculate",
          s
            "lv == 'split' ? (datum.stream == 'human' ? 'human' : 'bot') : (lv \
             == 'merged' ? 'all requests' : 'human and bot')" );
        ("as", s "panel");
      ];
    o
      [
        ("calculate", s "lv == 'overlaid' ? datum.stream : 'one stream'");
        ("as", s "look");
      ];
  ]

let latency_rows ?(src = "compared") dir run =
  let reqs = Summary.read_traffic dir in
  let lat f =
    List.filter_map
      (fun (r : Summary.req) ->
        if f r && Summary.ok r.status then Some r.latency_ms else None)
      reqs
  in
  let q stream values =
    let a = Summary.sorted_of_list values in
    let len = Array.length a in
    if len = 0 then []
    else
      List.init 200 (fun k ->
          let p = (float_of_int k +. 0.5) /. 200. in
          let idx =
            max 0 (min (len - 1) (int_of_float (p *. float_of_int len) - 1))
          in
          o
            [
              ("run", s run);
              ("src", s src);
              ("stream", s stream);
              ("q", n p);
              ("value", n (Float.max 0.01 a.(idx)));
            ])
  in
  q "human" (lat (fun r -> r.stream = "human"))
  @ q "bot" (lat (fun r -> r.stream = "bot"))
  @ q "all" (lat (fun _ -> true))

let latency_ecdf_spec ?(repeats = false) ~na ~nb rows =
  let color = run_color ~na ~nb in
  let dash =
    o
      [
        ("field", s "look");
        ("type", s "nominal");
        ("title", `Null);
        ( "scale",
          o
            [
              ("domain", l [ s "one stream"; s "human"; s "bot" ]);
              ("range", l [ l [ i 1; i 0 ]; l [ i 1; i 0 ]; l [ i 5; i 3 ] ]);
            ] );
        ("legend", `Null);
      ]
  in
  let x =
    o
      [
        ("field", s "value");
        ("type", s "quantitative");
        ("title", s "latency (ms, log)");
        ("scale", o [ ("type", s "log") ]);
        ("axis", log_axis [ 0.1; 1.; 10.; 100.; 1000.; 10000. ]);
      ]
  in
  let y =
    o
      [
        ("field", s "q");
        ("type", s "quantitative");
        ("title", s "share ≤ value");
        ("axis", o [ ("format", s "%") ]);
      ]
  in
  let compared = o [ ("filter", s "datum.src == 'compared'") ] in
  o
    [
      schema;
      ( "title",
        title "Latency distributions: ECDF, log x"
          ("share of requests at or below each latency; split = one panel per \
            stream,\n\
            overlaid = both streams in one panel (dashed = bot), merged = all \
            requests together"
          ^ if repeats then "; thin lines = the noise runs" else "") );
      ("params", l [ lv_param ]);
      ("data", o [ ("values", l rows) ]);
      ("transform", l lv_transforms);
      ( "facet",
        o
          [
            ("field", s "panel");
            ("type", s "nominal");
            ("title", `Null);
            ( "sort",
              l [ s "human"; s "bot"; s "human and bot"; s "all requests" ] );
          ] );
      ("columns", i 2);
      ( "spec",
        o
          [
            ("width", i 360);
            ("height", i 220);
            ( "layer",
              l
                [
                  o
                    [
                      ( "transform",
                        l [ o [ ("filter", s "datum.src != 'compared'") ] ] );
                      ( "mark",
                        o
                          [
                            ("type", s "line");
                            ("strokeWidth", i 1);
                            ("opacity", n 0.35);
                            ("interpolate", s "step-after");
                          ] );
                      ( "encoding",
                        o
                          [
                            ("x", x);
                            ("y", y);
                            ("detail", o [ ("field", s "src") ]);
                            ("strokeDash", dash);
                            ("color", color);
                          ] );
                    ];
                  o
                    [
                      ("transform", l [ compared ]);
                      ( "mark",
                        o
                          [
                            ("type", s "line");
                            ("strokeWidth", i 2);
                            ("interpolate", s "step-after");
                          ] );
                      ( "encoding",
                        o
                          [
                            ("x", x);
                            ("y", y);
                            ("detail", o [ ("field", s "stream") ]);
                            ("strokeDash", dash);
                            ("color", color);
                          ] );
                    ];
                  o
                    [
                      ("transform", l [ compared ]);
                      ( "mark",
                        o
                          [
                            ("type", s "point");
                            ("size", i 60);
                            ("opacity", i 0);
                            ("filled", jb true);
                          ] );
                      ( "encoding",
                        o
                          [
                            ("x", x);
                            ("y", y);
                            ("color", color);
                            ( "tooltip",
                              l
                                [
                                  o [ ("field", s "run") ];
                                  o [ ("field", s "stream") ];
                                  o
                                    [
                                      ("field", s "q");
                                      ("title", s "quantile");
                                      ("format", s ".1%");
                                    ];
                                  o
                                    [
                                      ("field", s "value");
                                      ("title", s "ms");
                                      ("format", s ".2f");
                                    ];
                                ] );
                          ] );
                    ];
                ] );
          ] );
      ("config", config);
    ]

(* Summary metrics as B / A, from the comparison's key metrics. *)
let dumbbell_spec ?noise ~na ~nb metrics =
  let has_noise = noise <> None in
  let rows =
    List.filter_map
      (fun (label, metric, better) ->
        match List.find_opt (fun (p, _, _, _) -> p = metric) metrics with
        | Some (_, x, y, rel)
          when Float.is_finite x && Float.is_finite y && x > 0. && y > 0. ->
            let label =
              if better = "higher" then label ^ " (higher is better)" else label
            in
            (* the noise band, as ratios to A: A +- the spread between
               repeats *)
            let sp =
              match noise with
              | Some tbl -> (
                  match Hashtbl.find_opt tbl metric with
                  | Some (sp, _) -> sp
                  | None -> nan)
              | None -> nan
            in
            let band =
              if Float.is_finite sp then
                [
                  ("lo", n (Float.max 0.005 ((x -. sp) /. x)));
                  ("hi", n ((x +. sp) /. x));
                ]
              else []
            in
            let beyond =
              (* same tolerance as [Compare] for rounding *)
              (not (Float.is_finite sp))
              || Float.abs (y -. x) > sp +. 0.001 +. (1e-4 *. Float.abs sp)
            in
            Some
              (o
                 ([
                    ("label", s label);
                    ("a", n x);
                    ("b", n y);
                    ("beyond", jb beyond);
                    ("ratio", n (y /. x));
                    ("txt", s (Printf.sprintf "×%.2f" (y /. x)));
                    ("reliable", match rel with Some r -> jb r | None -> `Null);
                  ]
                 @ band))
        | _ -> None)
      Compare.key_metrics
  in
  let order =
    List.filter_map
      (fun r -> match r with `Assoc f -> List.assoc_opt "label" f | _ -> None)
      rows
  in
  let y =
    o
      [
        ("field", s "label");
        ("type", s "nominal");
        ("sort", l order);
        ("title", `Null);
        ("axis", o [ ("labelLimit", i 300); ("labelColor", s "#0b0b0b") ]);
      ]
  in
  let one = o [ ("field", s "one"); ("type", s "quantitative") ] in
  o
    [
      schema;
      ( "title",
        title
          (Printf.sprintf "Summary metrics, %s relative to %s" nb na)
          ("ratio B / A on a log scale; 1 = no change; unless noted, lower is \
            better"
          ^
          if has_noise then
            ";\ngrey band = run-to-run noise around A (largest spread between \
             repeats of either image); filled dot = beyond noise, hollow = \
             within"
          else "") );
      ("data", o [ ("values", l rows) ]);
      ("width", i 520);
      ("height", o [ ("step", i 22) ]);
      ("transform", l [ o [ ("calculate", s "1"); ("as", s "one") ] ]);
      ( "layer",
        l
          [
            o
              [
                ("data", o [ ("values", l [ o [ ("one", i 1) ] ]) ]);
                ( "mark",
                  o
                    [
                      ("type", s "rule");
                      ("color", s muted);
                      ("strokeDash", l [ i 4; i 3 ]);
                    ] );
                ( "encoding",
                  o
                    [
                      ( "x",
                        o
                          [
                            ("field", s "one");
                            ("type", s "quantitative");
                            ("scale", o [ ("type", s "log") ]);
                          ] );
                    ] );
              ];
            o
              [
                ("transform", l [ o [ ("filter", s "isValid(datum.lo)") ] ]);
                ( "mark",
                  o
                    [
                      ("type", s "rule");
                      ("strokeWidth", i 12);
                      ("color", s grid);
                    ] );
                ( "encoding",
                  o
                    [
                      ("y", y);
                      ("x", o [ ("field", s "lo"); ("type", s "quantitative") ]);
                      ("x2", o [ ("field", s "hi") ]);
                    ] );
              ];
            o
              [
                ( "mark",
                  o
                    [
                      ("type", s "rule");
                      ("strokeWidth", i 2);
                      ("color", s "#c3c2b7");
                    ] );
                ( "encoding",
                  o [ ("y", y); ("x", one); ("x2", o [ ("field", s "ratio") ]) ]
                );
              ];
            o
              [
                ( "mark",
                  o
                    [
                      ("type", s "point");
                      ("filled", jb true);
                      ("size", i 90);
                      ("color", s color_a);
                      ("stroke", s surface);
                      ("strokeWidth", i 2);
                    ] );
                ( "encoding",
                  o
                    [
                      ("y", y);
                      ( "x",
                        o
                          [
                            ("field", s "one");
                            ("type", s "quantitative");
                            ("title", s "B / A (log)");
                          ] );
                      ( "tooltip",
                        l
                          [
                            o [ ("field", s "label") ];
                            o
                              [
                                ("field", s "a");
                                ("title", s na);
                                ("format", s ".3f");
                              ];
                          ] );
                    ] );
              ];
            o
              [
                ( "mark",
                  o
                    [
                      ("type", s "point");
                      ("filled", jb true);
                      ("size", i 90);
                      ("color", s color_b);
                      ("stroke", s color_b);
                      ("strokeWidth", i 2);
                    ] );
                ( "encoding",
                  o
                    [
                      ("y", y);
                      ( "fill",
                        o
                          [
                            ( "condition",
                              o
                                [
                                  ("test", s "datum.beyond");
                                  ("value", s color_b);
                                ] );
                            ("value", s surface);
                          ] );
                      ( "x",
                        o [ ("field", s "ratio"); ("type", s "quantitative") ]
                      );
                      ( "tooltip",
                        l
                          [
                            o [ ("field", s "label") ];
                            o
                              [
                                ("field", s "a");
                                ("title", s na);
                                ("format", s ".3f");
                              ];
                            o
                              [
                                ("field", s "b");
                                ("title", s nb);
                                ("format", s ".3f");
                              ];
                            o
                              [
                                ("field", s "ratio");
                                ("title", s "B / A");
                                ("format", s ".2f");
                              ];
                            o [ ("field", s "reliable") ];
                            o
                              [
                                ("field", s "beyond");
                                ("title", s "beyond noise");
                              ];
                          ] );
                    ] );
              ];
            o
              [
                ( "mark",
                  o
                    [
                      ("type", s "text");
                      ("align", s "left");
                      ("dx", i 10);
                      ("color", s ink2);
                      ("fontSize", i 11);
                    ] );
                ( "encoding",
                  o
                    [
                      ("y", y);
                      ("x", o [ ("value", i 530) ]);
                      ("text", o [ ("field", s "txt") ]);
                    ] );
              ];
          ] );
      ("config", config);
    ]

(* Flicker: the 10 s timelines of both runs, one at a time, fixed scales. *)
let flicker_rows dir run =
  let header, rows = Csv.read (Filename.concat dir "timeline.csv") in
  let col name =
    let rec go k = function
      | [] -> None
      | h :: _ when h = name -> Some k
      | _ :: tl -> go (k + 1) tl
    in
    go 0 header
  in
  let get r name =
    Option.bind (col name) (fun k ->
        Option.bind (List.nth_opt r k) float_of_string_opt)
  in
  List.filter_map
    (fun r ->
      match get r "t" with
      | None -> None
      | Some t ->
          let f name = match get r name with Some v -> n v | None -> `Null in
          Some
            (o
               [
                 ("run", s run);
                 ("t", n t);
                 ("update", f "update_share");
                 ("rss", f "rss_max_mb");
                 ("cpu", f "cpu_pct");
                 ("gc_ms", f "gc_pause_ms");
                 ("human_max", f "human_max_ms");
               ]))
    rows

let flicker_spec ~na ~nb ~run_end rows =
  let color = run_color ~na ~nb in
  let mx field =
    List.fold_left
      (fun acc r ->
        match r with
        | `Assoc f -> (
            match List.assoc_opt field f with
            | Some (`Intlit v) -> Float.max acc (float_of_string v)
            | Some (`Float v) -> Float.max acc v
            | _ -> acc)
        | _ -> acc)
      1. rows
  in
  let panel field ytitle log last =
    let scale =
      if log then o [ ("type", s "log"); ("domain", l [ i 1; n (mx field) ]) ]
      else o [ ("domain", l [ i 0; n (mx field) ]) ]
    in
    o
      [
        ("height", i 110);
        ("width", i 900);
        ( "transform",
          l
            [
              o
                [
                  ( "filter",
                    s ("datum.run == run && isValid(datum." ^ field ^ ")") );
                ];
            ] );
        ( "layer",
          l
            [
              o
                [
                  ( "mark",
                    o
                      [
                        ("type", s "area");
                        ("color", s grid);
                        ("opacity", n 0.8);
                        ("interpolate", s "step-after");
                      ] );
                  ( "encoding",
                    o
                      [
                        ( "x",
                          o
                            [
                              ("field", s "t");
                              ("type", s "quantitative");
                              ( "title",
                                if last then s "seconds since start" else `Null
                              );
                              ("scale", o [ ("domain", l [ i 0; n run_end ]) ]);
                            ] );
                        ( "y",
                          o
                            [
                              ("field", s "update");
                              ("type", s "quantitative");
                              ("title", `Null);
                              ("axis", `Null);
                              ("scale", o [ ("domain", l [ i 0; i 1 ]) ]);
                            ] );
                      ] );
                ];
              o
                [
                  ( "mark",
                    o
                      [
                        ("type", s "line");
                        ("strokeWidth", i 2);
                        ("interpolate", s "step-after");
                      ] );
                  ( "encoding",
                    o
                      [
                        ("x", o [ ("field", s "t"); ("type", s "quantitative") ]);
                        ( "y",
                          o
                            ([
                               ("field", s field);
                               ("type", s "quantitative");
                               ("title", s ytitle);
                               ("scale", scale);
                             ]
                            @
                            if log then
                              [
                                ( "axis",
                                  log_axis [ 1.; 10.; 100.; 1000.; 10000. ] );
                              ]
                            else []) );
                        ("color", color);
                        ( "tooltip",
                          l
                            [
                              o [ ("field", s "run") ];
                              o [ ("field", s "t"); ("title", s "t (s)") ];
                              o
                                [
                                  ("field", s field);
                                  ("title", s ytitle);
                                  ("format", s ".1f");
                                ];
                              o
                                [
                                  ("field", s "update");
                                  ("title", s "share of 10 s in an update");
                                  ("format", s ".0%");
                                ];
                            ] );
                      ] );
                ];
            ] );
        ("resolve", o [ ("scale", o [ ("y", s "independent") ]) ]);
      ]
  in
  o
    [
      schema;
      ( "title",
        title "Flicker: switch builds, same scales"
          "toggle the build below and watch what moves; grey = share of each \
           10 s spent in an update" );
      ("data", o [ ("values", l rows) ]);
      ( "params",
        l
          [
            o
              [
                ("name", s "run");
                ("value", s na);
                ( "bind",
                  o
                    [
                      ("input", s "radio");
                      ("options", l [ s na; s nb ]);
                      ("name", s "build: ");
                    ] );
              ];
          ] );
      ( "vconcat",
        l
          [
            panel "rss" "RSS max (MB)" false false;
            panel "cpu" "CPU (% of a core)" false false;
            panel "gc_ms" "GC pause time per 10 s (ms)" false false;
            panel "human_max" "human max latency (ms, log)" true true;
          ] );
      ("config", config);
    ]

(* The same request in both runs. *)
let paired_spec ~na ~nb (m : Compare.matching) =
  let rows =
    List.map
      (fun (p : Compare.pair) ->
        o
          [
            ("stream", s p.stream);
            ("cls", s p.cls);
            ("a", n (Float.max 0.1 p.a_ms));
            ("b", n (Float.max 0.1 p.b_ms));
            ( "upd",
              s
                (if p.during_update then "during an update (either run)"
                 else "outside updates") );
          ])
      m.pairs
  in
  let ax title_ field =
    o
      [
        ("field", s field);
        ("type", s "quantitative");
        ("title", s title_);
        ("scale", o [ ("type", s "log"); ("domain", l [ n 0.1; i 20000 ]) ]);
        ("axis", log_axis [ 0.1; 1.; 10.; 100.; 1000.; 10000. ]);
      ]
  in
  o
    [
      schema;
      ( "title",
        title "Same request, both builds"
          (Printf.sprintf
             "each dot is one request (same stream and id): below the diagonal \
              = faster on %s; log axes;\n\
              split = one panel per stream, overlaid = one panel (square = \
              bot), merged = one panel"
             nb) );
      ("params", l [ lv_param ]);
      ("data", o [ ("values", l rows) ]);
      ( "transform",
        l
          [
            o
              [
                ( "calculate",
                  s
                    "lv == 'split' ? datum.stream : (lv == 'merged' ? 'all \
                     requests' : 'human and bot')" );
                ("as", s "panel");
              ];
            o
              [
                ("calculate", s "lv == 'overlaid' ? datum.stream : 'one stream'");
                ("as", s "look");
              ];
          ] );
      ( "facet",
        o
          [
            ("field", s "panel");
            ("type", s "nominal");
            ("title", `Null);
            ( "sort",
              l [ s "human"; s "bot"; s "human and bot"; s "all requests" ] );
          ] );
      ( "spec",
        o
          [
            ("width", i 320);
            ("height", i 320);
            ( "layer",
              l
                [
                  o
                    [
                      ( "data",
                        o
                          [
                            ( "values",
                              l [ o [ ("v", n 0.1) ]; o [ ("v", i 20000) ] ] );
                          ] );
                      ( "mark",
                        o
                          [
                            ("type", s "line");
                            ("color", s muted);
                            ("strokeDash", l [ i 4; i 3 ]);
                          ] );
                      ( "encoding",
                        o
                          [
                            ( "x",
                              o [ ("field", s "v"); ("type", s "quantitative") ]
                            );
                            ( "y",
                              o [ ("field", s "v"); ("type", s "quantitative") ]
                            );
                          ] );
                    ];
                  o
                    [
                      ( "mark",
                        o
                          [
                            ("type", s "point");
                            ("filled", jb true);
                            ("size", i 22);
                            ("opacity", n 0.55);
                          ] );
                      ( "encoding",
                        o
                          [
                            ("x", ax (na ^ " latency (ms, log)") "a");
                            ("y", ax (nb ^ " latency (ms, log)") "b");
                            ( "shape",
                              o
                                [
                                  ("field", s "look");
                                  ("type", s "nominal");
                                  ( "scale",
                                    o
                                      [
                                        ( "domain",
                                          l
                                            [
                                              s "one stream"; s "human"; s "bot";
                                            ] );
                                        ( "range",
                                          l
                                            [
                                              s "circle"; s "circle"; s "square";
                                            ] );
                                      ] );
                                  ("legend", `Null);
                                ] );
                            ( "color",
                              o
                                [
                                  ("field", s "upd");
                                  ("type", s "nominal");
                                  ("title", `Null);
                                  ( "scale",
                                    o
                                      [
                                        ( "domain",
                                          l
                                            [
                                              s "outside updates";
                                              s "during an update (either run)";
                                            ] );
                                        ("range", l [ s muted; s "#1baf7a" ]);
                                      ] );
                                  ("legend", o [ ("orient", s "top") ]);
                                ] );
                            ( "tooltip",
                              l
                                [
                                  o [ ("field", s "stream") ];
                                  o
                                    [
                                      ("field", s "cls");
                                      ("title", s "page class");
                                    ];
                                  o
                                    [
                                      ("field", s "a");
                                      ("title", s na);
                                      ("format", s ".1f");
                                    ];
                                  o
                                    [
                                      ("field", s "b");
                                      ("title", s nb);
                                      ("format", s ".1f");
                                    ];
                                  o [ ("field", s "upd"); ("title", s "when") ];
                                ] );
                          ] );
                    ];
                ] );
          ] );
      ("config", config);
    ]

(* {1 Page} *)

let html_escape str =
  let buf = Buffer.create (String.length str) in
  String.iter
    (function
      | '<' -> Buffer.add_string buf "&lt;"
      | '>' -> Buffer.add_string buf "&gt;"
      | '&' -> Buffer.add_string buf "&amp;"
      | c -> Buffer.add_char buf c)
    str;
  Buffer.contents buf

let run ?(noise = []) ~output a b =
  ignore (Summary.run a);
  ignore (Summary.run b);
  let meta d = Compare.load d "meta.json" in
  let ma = meta a and mb = meta b in
  let image m =
    match Compare.member "image" m with Some (`String x) -> x | _ -> "?"
  in
  let image_a = image ma and image_b = image mb in
  let na = image_a and nb = image_b in
  let na, nb = if na = nb then (na ^ " (A)", nb ^ " (B)") else (na, nb) in
  let params = Compare.differing_params ma mb in
  let run_end dir =
    let r = Summary.read_resources dir in
    if Array.length r = 0 then 0. else r.(Array.length r - 1).st
  in
  let run_end = Float.max (run_end a) (run_end b) in
  let inputs_spec, same_traffic, same_upstream, moves, total =
    inputs ~a ~b ~run_end
  in
  let raw = raw_charts ~a ~b ~na ~nb ~run_end in
  let fa = Compare.flatten (Compare.load a "summary.json")
  and fb = Compare.flatten (Compare.load b "summary.json") in
  let metrics =
    List.map
      (fun (p, x, r) ->
        match List.find_opt (fun (q, _, _) -> q = p) fb with
        | Some (_, y, r') ->
            ( p,
              x,
              y,
              match (r, r') with
              | Some u, Some v -> Some (u && v)
              | u, None | None, u -> u )
        | None -> (p, x, nan, r))
      fa
  in
  let m = Compare.match_requests a b in
  (* The noise runs: each noise.json names its image and its repeats; they are
     drawn in the colour of the compared run with the same image. *)
  let noise_runs =
    List.map
      (fun file ->
        let j = Yojson.Safe.from_file file in
        let image =
          match Compare.member "image" j with Some (`String x) -> x | _ -> "?"
        in
        let dirs =
          match Compare.member "runs" j with
          | Some (`List l) ->
              List.filter_map (function `String d -> Some d | _ -> None) l
          | _ -> []
        in
        (file, image, dirs))
      noise
  in
  let label_of image =
    if image = image_a then Some na
    else if image = image_b then Some nb
    else None
  in
  let repeat_rows =
    List.concat_map
      (fun (_, image, dirs) ->
        match label_of image with
        | None -> []
        | Some label ->
            List.concat_map
              (fun d ->
                if Sys.file_exists d then ecdf_rows ~src:d d label else [])
              dirs)
      noise_runs
  in
  let latency_repeat_rows =
    List.concat_map
      (fun (_, image, dirs) ->
        match label_of image with
        | None -> []
        | Some label ->
            List.concat_map
              (fun d ->
                if Sys.file_exists d then latency_rows ~src:d d label else [])
              dirs)
      noise_runs
  in
  let comparison =
    [
      ( "A typical update, lined up",
        epoch_spec ~na ~nb (epoch_rows a na @ epoch_rows b nb) );
      ( "Latency distributions (ECDF)",
        latency_ecdf_spec
          ~repeats:(latency_repeat_rows <> [])
          ~na ~nb
          (latency_repeat_rows @ latency_rows a na @ latency_rows b nb) );
      ( "GC pause distributions (ECDF)",
        ecdf_spec ~repeats:(repeat_rows <> []) ~na ~nb
          (repeat_rows @ ecdf_rows a na @ ecdf_rows b nb) );
      ( "Summary metrics as ratios",
        dumbbell_spec
          ?noise:(if noise = [] then None else Some (Compare.load_noise noise))
          ~na ~nb metrics );
      ( "Flicker",
        flicker_spec ~na ~nb ~run_end (flicker_rows a na @ flicker_rows b nb) );
      ("Same request, both builds", paired_spec ~na ~nb m);
    ]
  in
  let docs_a, docs_b =
    let inp = Compare.inputs a b in
    (inp.docs_a, inp.docs_b)
  in
  let docs_same = docs_a = docs_b in
  let note =
    let ok = "<span class=ok>✓</span>" and ko = "<span class=ko>✗</span>" in
    Printf.sprintf
      "<p>%s Run parameters %s.<br>%s Traffic: %s.<br>%s Upstream: %s.<br>%s \
       Docs server: %s.</p>"
      (if params = [] then ok else ko)
      (if params = [] then "identical apart from the image"
       else
         "differ: "
         ^ html_escape
             (String.concat "; "
                (List.map
                   (fun (k, x, y) -> Printf.sprintf "%s A=%s B=%s" k x y)
                   params)))
      (if same_traffic then ok else ko)
      (if same_traffic then
         Printf.sprintf "the same %d requests in both runs, paired one to one"
           total
       else "not the same requests in both runs; the inputs chart shows run A's")
      (if same_upstream then ok else ko)
      (if same_upstream then
         Printf.sprintf "the same %d moves, in the same order, in both runs"
           moves
       else "different moves in the two runs; the inputs chart shows run A's")
      (if docs_same then ok else ko)
      (let what = function
         | "stub" ->
             "stub (every documentation request gets 404: package pages take \
              the no-documentation path, without the network)"
         | "real" -> "the real external server"
         | x -> x
       in
       if docs_same then what docs_a
       else Printf.sprintf "A %s, B %s" (what docs_a) (what docs_b))
  in
  let noise_note =
    if noise_runs = [] then ""
    else
      Printf.sprintf
        "<p>Run-to-run noise: %s. In the ratio chart, the grey band is the \
         noise; in the distributions, thin lines are the repeats.</p>"
        (String.concat "; "
           (List.map
              (fun (file, image, dirs) ->
                Printf.sprintf "%d repeats of <code>%s</code> (<code>%s</code>)"
                  (List.length dirs) (html_escape image) (html_escape file))
              noise_runs))
  in
  let sections =
    [
      ("Inputs", [ ("Inputs", inputs_spec) ]);
      ("Raw output", raw);
      ("Comparison", comparison);
    ]
  in
  let buf = Buffer.create (1 lsl 20) in
  let pr fmt = Printf.bprintf buf fmt in
  pr
    "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta \
     name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\
     <title>sim: %s vs %s</title>\n\
     <script src=\"https://cdn.jsdelivr.net/npm/vega@5.30.0\"></script>\n\
     <script src=\"https://cdn.jsdelivr.net/npm/vega-lite@5.21.0\"></script>\n\
     <script src=\"https://cdn.jsdelivr.net/npm/vega-embed@6.26.0\"></script>\n\
     <style>body{font-family:sans-serif;margin:16px;background:%s;color:#0b0b0b;max-width:1150px}\n\
     h1{font-size:20px}h2{font-size:17px;margin-top:36px;border-bottom:1px \
     solid %s;padding-bottom:4px}\n\
     h3{font-size:14px;margin-top:24px}p{color:%s}code{font-size:13px}.chart{margin:6px \
     0 20px}\n\
     .err{color:#b00;white-space:pre-wrap}.lvt{margin:4px 0 \
     0;color:%s;font-size:14px}.ok{color:#008300}.ko{color:#e34948}</style></head><body>\n\
     <h1>sim: %s vs %s</h1>\n\
     <p>A = <code>%s</code>, B = <code>%s</code>. Colours: <b>%s</b> blue, \
     <b>%s</b> orange. Hover any mark for values.</p>\n\
     %s\n"
    (html_escape na) (html_escape nb) surface grid ink2 ink2 (html_escape na)
    (html_escape nb) (html_escape a) (html_escape b) (html_escape na)
    (html_escape nb) (note ^ noise_note);
  (* charts that take the human/bot toggle (the [lv] signal) *)
  let latency_charts =
    [ "Latency distributions (ECDF)"; "Same request, both builds" ]
  in
  let k = ref 0 in
  let specs = ref [] in
  List.iter
    (fun (sec, charts) ->
      pr "<h2>%s</h2>\n" sec;
      List.iter
        (fun (name, spec) ->
          incr k;
          if List.mem name latency_charts then
            pr
              "<div class=\"lvt\">Latency, human and bot: <label><input \
               type=\"radio\" name=\"lv%d\" value=\"split\" checked> \
               split</label> <label><input type=\"radio\" name=\"lv%d\" \
               value=\"overlaid\"> overlaid</label> <label><input \
               type=\"radio\" name=\"lv%d\" value=\"merged\"> \
               merged</label></div>\n"
              !k !k !k;
          pr "<div class=\"chart\" id=\"c%d\"></div>\n" !k;
          specs := (!k, spec) :: !specs)
        charts)
    sections;
  pr "<script>\nconst specs = {\n";
  List.iter
    (fun (k, spec) -> pr "c%d: %s,\n" k (Yojson.Safe.to_string spec))
    (List.rev !specs);
  pr
    "};\n\
     // One toggle drives the [lv] signal of every chart that has it; the\n\
     // radio groups above those charts stay in sync.\n\
     const views = [];\n\
     function setLV(v) {\n\
    \  for (const view of views) { try { view.signal('lv', v).runAsync(); } \
     catch (e) {} }\n\
    \  document.querySelectorAll('.lvt input').forEach(i => { i.checked = \
     (i.value === v); });\n\
     }\n\
     document.querySelectorAll('.lvt input').forEach(i => \
     i.addEventListener('change', e => setLV(e.target.value)));\n\
     for (const [id, spec] of Object.entries(specs)) {\n\
    \  vegaEmbed('#' + id, spec, {actions: false, renderer: 'canvas'}).then(r \
     => views.push(r.view)).catch(e => {\n\
    \    const d = document.getElementById(id); d.className = 'chart err'; \
     d.textContent = 'Error: ' + e.message;\n\
    \  });\n\
     }\n\
     </script></body></html>\n";
  let oc = open_out output in
  Buffer.output_buffer oc buf;
  close_out oc;
  Printf.sprintf "sim: wrote %s (%d charts)\n" output !k
