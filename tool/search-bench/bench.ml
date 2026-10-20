(* Search-ranking benchmark for ocaml.org package search.

   Loads the on-disk package-state cache, runs the query set through each
   ranking arm ([current] = the production binary-presence scorer, [bm25f] = the
   BM25F arm, plus ablation/sweep arms under [--ablate]), and emits one CSV row
   per (query, arm):

   query,arm,split,p1,mrr,ndcg5,ndcg10,latency_ms

   - p1/mrr known-item metrics vs an expected package (if given). Free, no net.
   - ndcg5 nDCG@5 — the autocomplete surface (handler shows top 5). - ndcg10
   nDCG@10 — the results page. From the LLM judge (if it ran). - latency warmed
   wall-clock of the search call (BM25F stats build excluded).

   Effectiveness and efficiency are measured separately. The known-item tier is
   free and network-free (CI regression guard); the graded tier uses an LLM
   judge and runs only when ANTHROPIC_API_KEY is set. Both arms rank the *same*
   matched set (re-ordering only), so each (query, package) pair is judged once
   per pass and reused across arms.

   Flags: --ablate run the full ablation/sweep arm set --show dump each arm's
   top-10 per query (grades in parens) --passes N judge passes per query,
   averaged (default 5) --split S keep queries tagged train|holdout (plus
   untagged); default all --validate-judge compare the judge model vs
   claude-opus-4-8 on a sample, then exit Env: SEARCH_BENCH_JUDGE_MODEL (default
   claude-haiku-4-5), ANTHROPIC_API_KEY.

   Aggregate the CSV with awk/gnuplot (see README) — no Python, per repo
   convention. The paired bootstrap CI + sign test are also printed to
   stderr. *)

module P = Ocamlorg_package

(* ----------------------------------------------------------------------- *)
(* small helpers                                                           *)

let lowercase = String.lowercase_ascii

let contains_s haystack needle =
  let hl = String.length haystack and nl = String.length needle in
  if nl = 0 then true
  else
    let rec go i =
      if i > hl - nl then false
      else if String.sub haystack i nl = needle then true
      else go (i + 1)
    in
    go 0

(* Simplified author match: the production handler resolves authors through the
   opam-user data table (ocamlorg_data); here a substring over the raw author
   string is enough (the query set has no author: queries). Wiring the real
   table is a documented follow-up — see README. *)
let is_author_match name pattern =
  contains_s (lowercase name) (lowercase pattern)

let read_lines path =
  let ic = open_in path in
  Fun.protect
    ~finally:(fun () -> close_in ic)
    (fun () ->
      let rec go acc =
        match input_line ic with
        | line -> go (line :: acc)
        | exception End_of_file -> List.rev acc
      in
      go [])

(* Parse a query-set line: "query", "query,expected", or "query,expected,split"
   (split in {train,holdout,all}; default all). Lines starting with '#' and
   blank lines are ignored. *)
let parse_query_line line =
  let line = String.trim line in
  if line = "" || line.[0] = '#' then None
  else
    match String.split_on_char ',' line |> List.map String.trim with
    | [] -> None
    | [ q ] -> Some (q, None, "all")
    | [ q; e ] -> Some (q, (if e = "" then None else Some e), "all")
    | q :: e :: s :: _ ->
        let split = if s = "" then "all" else s in
        Some (q, (if e = "" then None else Some e), split)

(* ----------------------------------------------------------------------- *)
(* metrics + stats                                                         *)

let reciprocal_rank expected names =
  let rec go r = function
    | [] -> 0.0
    | n :: tl -> if n = expected then 1.0 /. float_of_int r else go (r + 1) tl
  in
  go 1 names

let precision_at1 expected = function
  | n :: _ -> if n = expected then 1.0 else 0.0
  | [] -> 0.0

let log2 x = log x /. log 2.0

let dcg_at k grades =
  let rec go r acc = function
    | [] -> acc
    | _ when r > k -> acc
    | g :: tl ->
        go (r + 1)
          (acc +. (((2.0 ** g) -. 1.0) /. log2 (float_of_int (r + 1))))
          tl
  in
  go 1 0.0 grades

let ndcg_at k grades =
  let ideal = List.sort (fun a b -> compare b a) grades in
  let idcg = dcg_at k ideal in
  if idcg = 0.0 then 0.0 else dcg_at k grades /. idcg

let mean l =
  let l = List.filter (fun v -> not (Float.is_nan v)) l in
  match l with
  | [] -> nan
  | _ -> List.fold_left ( +. ) 0.0 l /. float_of_int (List.length l)

(* Paired bootstrap 95% CI of the mean of [deltas], seeded for
   reproducibility. *)
let bootstrap_ci ?(resamples = 10000) deltas =
  let a = Array.of_list deltas in
  let n = Array.length a in
  if n = 0 then (nan, nan, nan)
  else
    let st = Random.State.make [| 42 |] in
    let means =
      Array.init resamples (fun _ ->
          let s = ref 0.0 in
          for _ = 1 to n do
            s := !s +. a.(Random.State.int st n)
          done;
          !s /. float_of_int n)
    in
    Array.sort compare means;
    let m = Array.fold_left ( +. ) 0.0 a /. float_of_int n in
    ( m,
      means.(int_of_float (float_of_int resamples *. 0.025)),
      means.(int_of_float (float_of_int resamples *. 0.975)) )

let sign_counts deltas =
  List.fold_left
    (fun (w, l, t) d ->
      if d > 1e-9 then (w + 1, l, t)
      else if d < -1e-9 then (w, l + 1, t)
      else (w, l, t + 1))
    (0, 0, 0) deltas

let pearson xs ys =
  let n = float_of_int (List.length xs) in
  if n < 2.0 then nan
  else
    let mx = mean xs and my = mean ys in
    let num = ref 0.0 and dx = ref 0.0 and dy = ref 0.0 in
    List.iter2
      (fun x y ->
        num := !num +. ((x -. mx) *. (y -. my));
        dx := !dx +. ((x -. mx) ** 2.0);
        dy := !dy +. ((y -. my) ** 2.0))
      xs ys;
    if !dx = 0.0 || !dy = 0.0 then nan else !num /. sqrt (!dx *. !dy)

(* ----------------------------------------------------------------------- *)
(* LLM judge (raw HTTP; OCaml has no official Anthropic SDK)               *)

(* Keep this in sync with tool/search-bench/README.md §Judge prompt. *)
let judge_system_prompt =
  "You are a strict relevance judge for an OCaml package search engine. Given \
   a user's search query and a numbered list of candidate packages (name, \
   synopsis, tags and a description excerpt), grade how well each candidate \
   answers the query on this scale:\n\
   3 = perfect: the package is exactly what the query asks for.\n\
   2 = highly relevant: a strong, directly useful match.\n\
   1 = marginally relevant: related but not a good answer.\n\
   0 = irrelevant.\n\n\
   Judge only from the query and the candidate text. Do not reward popularity \
   or name familiarity. Reply with ONLY a JSON array of objects, one per \
   candidate, each {\"index\": <int>, \"grade\": <0-3>}. No prose."

let build_judge_user query candidates =
  let buf = Buffer.create 512 in
  Buffer.add_string buf ("Query: " ^ query ^ "\n\nCandidates:\n");
  List.iter
    (fun (i, _name, text) ->
      Buffer.add_string buf (Printf.sprintf "[%d] %s\n" i text))
    candidates;
  Buffer.add_string buf
    "\nReturn ONLY the JSON array of {\"index\",\"grade\"} objects.";
  Buffer.contents buf

let extract_json_array s =
  match (String.index_opt s '[', String.rindex_opt s ']') with
  | Some i, Some j when j > i -> Some (String.sub s i (j - i + 1))
  | _ -> None

let parse_grades text =
  match extract_json_array text with
  | None -> []
  | Some arr -> (
      match Yojson.Safe.from_string arr with
      | `List items ->
          List.filter_map
            (function
              | `Assoc fields -> (
                  let idx =
                    match List.assoc_opt "index" fields with
                    | Some (`Int i) -> Some i
                    | _ -> None
                  in
                  let grade =
                    match List.assoc_opt "grade" fields with
                    | Some (`Int g) -> Some (float_of_int g)
                    | Some (`Float g) -> Some g
                    | _ -> None
                  in
                  match (idx, grade) with
                  | Some i, Some g -> Some (i, g)
                  | _ -> None)
              | _ -> None)
            items
      | _ -> []
      | exception _ -> [])

(* One judge call. Returns (index, grade) pairs. *)
let anthropic_judge ~api_key ~model ~query ~candidates =
  let open Lwt.Syntax in
  let body =
    `Assoc
      [
        ("model", `String model);
        ("max_tokens", `Int 1024);
        ("system", `String judge_system_prompt);
        ( "messages",
          `List
            [
              `Assoc
                [
                  ("role", `String "user");
                  ("content", `String (build_judge_user query candidates));
                ];
            ] );
      ]
  in
  let headers =
    Cohttp.Header.of_list
      [
        ("x-api-key", api_key);
        ("anthropic-version", "2023-06-01");
        ("content-type", "application/json");
      ]
  in
  let uri = Uri.of_string "https://api.anthropic.com/v1/messages" in
  Lwt.catch
    (fun () ->
      let* resp, resp_body =
        Cohttp_lwt_unix.Client.post ~headers
          ~body:(`String (Yojson.Safe.to_string body))
          uri
      in
      let* body_str = Cohttp_lwt.Body.to_string resp_body in
      let status = Cohttp.Response.status resp |> Cohttp.Code.code_of_status in
      if status < 200 || status >= 300 then (
        Printf.eprintf "judge: HTTP %d for %S: %s\n%!" status query
          (String.sub body_str 0 (min 200 (String.length body_str)));
        Lwt.return [])
      else
        let text =
          match Yojson.Safe.from_string body_str with
          | `Assoc top -> (
              match List.assoc_opt "content" top with
              | Some (`List blocks) ->
                  List.fold_left
                    (fun acc b ->
                      match b with
                      | `Assoc bf -> (
                          match
                            (List.assoc_opt "type" bf, List.assoc_opt "text" bf)
                          with
                          | Some (`String "text"), Some (`String t) -> acc ^ t
                          | _ -> acc)
                      | _ -> acc)
                    "" blocks
              | _ -> "")
          | _ -> ""
        in
        Lwt.return (parse_grades text))
    (fun exn ->
      Printf.eprintf "judge: exception for %S: %s\n%!" query
        (Printexc.to_string exn);
      Lwt.return [])

(* ----------------------------------------------------------------------- *)
(* main                                                                    *)

let k_auto = 5 (* autocomplete surface depth (handler shows top 5) *)
let k_results = 10 (* results-page / pooling depth *)
let name_depth = 50 (* how deep to keep names for MRR *)

let () =
  let args = Array.to_list Sys.argv |> List.tl in
  let has f = List.mem f args in
  let arg_value flag =
    let rec go = function
      | a :: v :: _ when a = flag -> Some v
      | _ :: tl -> go tl
      | [] -> None
    in
    go args
  in
  let show_lists = has "--show" and ablate = has "--ablate" in
  let validate_judge = has "--validate-judge" in
  let passes =
    match arg_value "--passes" with
    | Some s -> (
        match int_of_string_opt s with Some n when n > 0 -> n | _ -> 5)
    | None -> 5
  in
  let split_filter = Option.value ~default:"all" (arg_value "--split") in
  let judge_model =
    Option.value ~default:"claude-haiku-4-5"
      (Sys.getenv_opt "SEARCH_BENCH_JUDGE_MODEL")
  in
  let positional =
    List.filter
      (fun a ->
        (String.length a < 2 || String.sub a 0 2 <> "--")
        && not
             (List.exists
                (fun v -> Some a = arg_value v)
                [ "--passes"; "--split" ]))
      args
  in
  let query_file =
    match positional with f :: _ -> f | [] -> "tool/search-bench/queries.csv"
  in

  let state = P.load_cached () in
  let all = P.all_latest state in
  Printf.eprintf "Loaded %d packages\n%!" (List.length all);
  if all = [] then (
    prerr_endline
      "No packages in cache. Set OCAMLORG_PKG_STATE_PATH or run the site once \
       to populate ~/.cache/ocamlorg/package.state.";
    exit 1);

  (* keep queries matching the split filter; untagged ("all") always run *)
  let queries =
    read_lines query_file
    |> List.filter_map parse_query_line
    |> List.filter (fun (_, _, s) ->
           split_filter = "all" || s = "all" || s = split_filter)
  in
  Printf.eprintf "%d queries (split=%s, passes=%d, judge=%s)\n%!"
    (List.length queries) split_filter passes judge_model;

  let names_of pkgs =
    List.filteri (fun i _ -> i < name_depth) pkgs
    |> List.map (fun p -> P.Name.to_string (P.name p))
  in

  let base = P.default_bm25f_params in
  let bm25f label params =
    (label, fun q -> P.search ~is_author_match ~ranking:(P.Bm25f params) state q)
  in
  let current =
    ( "current",
      fun q -> P.search ~is_author_match ~sort_by_popularity:true state q )
  in
  let arms =
    if ablate then
      [
        current;
        bm25f "bm25f" base;
        bm25f "no-idf" { base with use_idf = false };
        bm25f "no-lennorm" { base with use_lennorm = false };
        bm25f "no-exact" { base with exact_bonus = false };
        bm25f "flat-boost" { base with boosts = [| 1.; 1.; 1.; 1.; 1. |] };
        bm25f "k1-2.0" { base with k1 = 2.0 };
        bm25f "b-0.0" { base with b = 0.0 };
        bm25f "b-0.4" { base with b = 0.4 };
        bm25f "b-1.0" { base with b = 1.0 };
      ]
    else [ current; bm25f "bm25f" base ]
  in

  (* Warm each arm once so BM25F's one-time corpus-stats build is excluded from
     the measured latency. *)
  List.iter (fun (_, run) -> ignore (run "json")) arms;

  (* search phase: per (query, arm) ranked names + latency *)
  let results =
    List.map
      (fun (query, expected, split) ->
        let per_arm =
          List.map
            (fun (label, run) ->
              let t0 = Unix.gettimeofday () in
              let pkgs = run query in
              let dt = (Unix.gettimeofday () -. t0) *. 1000.0 in
              (label, names_of pkgs, dt))
            arms
        in
        (query, expected, split, per_arm))
      queries
  in

  (* Rich candidate text the judge sees: synopsis + tags + description
     excerpt. *)
  let candidate_text name =
    match P.Name.of_string_opt name with
    | None -> name
    | Some n -> (
        match P.get_latest state n with
        | None -> name
        | Some pkg ->
            let i = P.info pkg in
            let tags =
              if i.tags = [] then ""
              else " [tags: " ^ String.concat ", " i.tags ^ "]"
            in
            let desc =
              if i.description = "" then ""
              else
                let d = i.description in
                let d =
                  if String.length d > 160 then
                    String.sub d 0 160 ^ "\xe2\x80\xa6"
                  else d
                in
                " \xe2\x80\x94 " ^ d
            in
            Printf.sprintf "%s %s%s%s" name i.synopsis tags desc)
  in

  (* Pool for a query = union of each arm's top-k_results, shuffled (seeded) to
     blind the judge against arm order. *)
  let shuffle_state = Random.State.make [| 20260102 |] in
  let pool_of per_arm =
    let pool =
      List.concat_map
        (fun (_, names, _) -> List.filteri (fun i _ -> i < k_results) names)
        per_arm
      |> List.sort_uniq compare
    in
    let a = Array.of_list pool in
    for i = Array.length a - 1 downto 1 do
      let j = Random.State.int shuffle_state (i + 1) in
      let t = a.(i) in
      a.(i) <- a.(j);
      a.(j) <- t
    done;
    Array.to_list a
  in

  (* --validate-judge: compare the judge model vs Opus on a sample, then
     exit. *)
  (if validate_judge then
     match Sys.getenv_opt "ANTHROPIC_API_KEY" with
     | None ->
         prerr_endline "ANTHROPIC_API_KEY unset: cannot validate the judge.";
         exit 1
     | Some api_key ->
         let sample = List.filteri (fun i _ -> i < 8) results in
         Lwt_main.run
           (let open Lwt.Syntax in
            let xs = ref [] and ys = ref [] and adiff = ref [] in
            let* () =
              Lwt_list.iter_s
                (fun (query, _e, _s, per_arm) ->
                  let pool = pool_of per_arm in
                  let candidates =
                    List.mapi (fun i n -> (i, n, candidate_text n)) pool
                  in
                  if candidates = [] then Lwt.return_unit
                  else
                    let* ga =
                      anthropic_judge ~api_key ~model:judge_model ~query
                        ~candidates
                    in
                    let* gb =
                      anthropic_judge ~api_key ~model:"claude-opus-4-8" ~query
                        ~candidates
                    in
                    List.iter
                      (fun (idx, a) ->
                        match List.assoc_opt idx gb with
                        | Some b ->
                            xs := a :: !xs;
                            ys := b :: !ys;
                            adiff := Float.abs (a -. b) :: !adiff
                        | None -> ())
                      ga;
                    Printf.eprintf "validated %S\n%!" query;
                    Lwt.return_unit)
                sample
            in
            Printf.eprintf
              "\n\
               === judge validation: %s vs claude-opus-4-8 (%d graded pairs) ===\n\
               mean |Δgrade| = %.3f   Pearson r = %.3f\n\
               %!"
              judge_model (List.length !xs) (mean !adiff) (pearson !xs !ys);
            Lwt.return_unit);
         exit 0);

  (* graded phase: judge each query's pool [passes] times, average; record the
     per-query mean grade stddev as a judge-noise readout. *)
  let grades_by_query = Hashtbl.create 64 in
  let grade_sd_by_query = Hashtbl.create 64 in
  (match Sys.getenv_opt "ANTHROPIC_API_KEY" with
  | None ->
      prerr_endline
        "ANTHROPIC_API_KEY unset: skipping graded (nDCG) tier; known-item and \
         latency only."
  | Some api_key ->
      Lwt_main.run
        (let open Lwt.Syntax in
         Lwt_list.iter_s
           (fun (query, _e, _s, per_arm) ->
             let pool = pool_of per_arm in
             let candidates =
               List.mapi (fun i n -> (i, n, candidate_text n)) pool
             in
             if candidates = [] then Lwt.return_unit
             else
               let sums = Hashtbl.create 16
               and sqs = Hashtbl.create 16
               and cnts = Hashtbl.create 16 in
               let get h k = Option.value ~default:0.0 (Hashtbl.find_opt h k) in
               let* () =
                 Lwt_list.iter_s
                   (fun _pass ->
                     let* graded =
                       anthropic_judge ~api_key ~model:judge_model ~query
                         ~candidates
                     in
                     List.iter
                       (fun (idx, g) ->
                         match List.nth_opt pool idx with
                         | Some name ->
                             Hashtbl.replace sums name (g +. get sums name);
                             Hashtbl.replace sqs name ((g *. g) +. get sqs name);
                             Hashtbl.replace cnts name (1.0 +. get cnts name)
                         | None -> ())
                       graded;
                     Lwt.return_unit)
                   (List.init passes (fun i -> i))
               in
               let avg = Hashtbl.create 16 in
               let sds = ref [] in
               Hashtbl.iter
                 (fun name s ->
                   let c = get cnts name in
                   if c > 0.0 then (
                     let m = s /. c in
                     Hashtbl.replace avg name m;
                     let v = (get sqs name /. c) -. (m *. m) in
                     sds := sqrt (Float.max 0.0 v) :: !sds))
                 sums;
               Hashtbl.replace grades_by_query query avg;
               Hashtbl.replace grade_sd_by_query query (mean !sds);
               Printf.eprintf "judged %S (%d candidates, %d passes)\n%!" query
                 (List.length candidates) passes;
               Lwt.return_unit)
           results));

  (* grade lookup for an arm's ranked names *)
  let graded_ranked query names k =
    match Hashtbl.find_opt grades_by_query query with
    | None -> None
    | Some tbl ->
        Some
          (List.filteri (fun i _ -> i < k) names
          |> List.map (fun n ->
                 Option.value ~default:0.0 (Hashtbl.find_opt tbl n)))
  in

  (* Emit CSV. *)
  print_endline "query,arm,split,p1,mrr,ndcg5,ndcg10,latency_ms";
  let csv = String.map (fun c -> if c = ',' then ' ' else c) in
  let f v = if Float.is_nan v then "" else Printf.sprintf "%.4f" v in
  List.iter
    (fun (query, expected, split, per_arm) ->
      List.iter
        (fun (label, names, dt) ->
          let p1, mrr =
            match expected with
            | Some e -> (precision_at1 e names, reciprocal_rank e names)
            | None -> (nan, nan)
          in
          let ndcg5 =
            match graded_ranked query names k_auto with
            | Some g -> ndcg_at k_auto g
            | None -> nan
          in
          let ndcg10 =
            match graded_ranked query names k_results with
            | Some g -> ndcg_at k_results g
            | None -> nan
          in
          Printf.printf "%s,%s,%s,%s,%s,%s,%s,%.3f\n" (csv query) label split
            (f p1) (f mrr) (f ndcg5) (f ndcg10) dt)
        per_arm)
    results;

  (* Per-arm means to stderr. *)
  let col label pick =
    List.filter_map
      (fun (query, expected, _s, per_arm) ->
        match List.find_opt (fun (l, _, _) -> l = label) per_arm with
        | Some (_, names, dt) -> Some (pick query expected names dt)
        | None -> None)
      results
  in
  Printf.eprintf "\n=== per-arm means ===\n%!";
  List.iter
    (fun (label, _) ->
      let p1 =
        col label (fun _ e n _ ->
            match e with Some e -> precision_at1 e n | None -> nan)
      in
      let mrr =
        col label (fun _ e n _ ->
            match e with Some e -> reciprocal_rank e n | None -> nan)
      in
      let nd5 =
        col label (fun q _ n _ ->
            match graded_ranked q n k_auto with
            | Some g -> ndcg_at k_auto g
            | None -> nan)
      in
      let nd10 =
        col label (fun q _ n _ ->
            match graded_ranked q n k_results with
            | Some g -> ndcg_at k_results g
            | None -> nan)
      in
      let lat = col label (fun _ _ _ dt -> dt) in
      Printf.eprintf
        "arm=%-10s p@1=%.3f mrr=%.3f ndcg@5=%.3f ndcg@10=%.3f latency_ms=%.3f\n\
         %!"
        label (mean p1) (mean mrr) (mean nd5) (mean nd10) (mean lat))
    arms;

  (* Paired stats vs [current] on nDCG@10 (graded queries only). *)
  if Hashtbl.length grades_by_query > 0 then (
    let ndcg10_by label =
      List.filter_map
        (fun (query, _e, _s, per_arm) ->
          match List.find_opt (fun (l, _, _) -> l = label) per_arm with
          | Some (_, names, _) -> (
              match graded_ranked query names k_results with
              | Some g -> Some (query, ndcg_at k_results g)
              | None -> None)
          | None -> None)
        results
    in
    let cur = ndcg10_by "current" in
    Printf.eprintf "\n=== nDCG@10 vs current (paired, graded queries) ===\n%!";
    List.iter
      (fun (label, _) ->
        if label <> "current" then
          let arm = ndcg10_by label in
          let deltas =
            List.filter_map
              (fun (q, v) ->
                match List.assoc_opt q cur with
                | Some c -> Some (v -. c)
                | None -> None)
              arm
          in
          let m, lo, hi = bootstrap_ci deltas in
          let w, l, t = sign_counts deltas in
          Printf.eprintf
            "%-10s Δmean=%+.4f  95%% CI=[%+.4f, %+.4f]%s  W/L/T=%d/%d/%d\n%!"
            label m lo hi
            (if lo <= 0.0 && hi >= 0.0 then " (crosses 0)" else "")
            w l t)
      arms;
    if passes > 1 then
      Printf.eprintf
        "judge noise: mean per-query grade stddev = %.3f (%d passes)\n%!"
        (mean (Hashtbl.fold (fun _ v acc -> v :: acc) grade_sd_by_query []))
        passes);

  (* --show: dump the top-10 ranked list of each arm per query. *)
  if show_lists then (
    prerr_endline "\n=== ranked lists (top 10, grade in parens) ===";
    List.iter
      (fun (query, _e, _s, per_arm) ->
        Printf.eprintf "\n# %s\n%!" query;
        let grades = Hashtbl.find_opt grades_by_query query in
        List.iter
          (fun (label, names, _dt) ->
            Printf.eprintf "  [%s]\n" label;
            List.iteri
              (fun i n ->
                if i < k_results then
                  let g =
                    match grades with
                    | Some tbl -> (
                        match Hashtbl.find_opt tbl n with
                        | Some g -> Printf.sprintf " (%.1f)" g
                        | None -> "")
                    | None -> ""
                  in
                  Printf.eprintf "    %2d. %s%s\n" (i + 1) n g)
              names)
          per_arm)
      results)
