(* Search-ranking benchmark for ocaml.org package search.

   Loads the on-disk package-state cache, runs the query set through each
   ranking arm ([current] = the production binary-presence scorer, [bm25f] = the
   experimental BM25F arm), and emits one CSV row per (query, arm) with:

   - p1 precision@1 against a known-item expected package (if given) - mrr
   reciprocal rank of the expected package (known-item only) - ndcg5 nDCG@5 from
   LLM-judged graded relevance (if a judge ran) - ndcg10 nDCG@10 - latency_ms
   wall-clock of the search call (warmed, so BM25F's one-time corpus-stats build
   is excluded)

   Effectiveness vs efficiency are measured separately. The known-item tier is
   free and needs no network (good as a CI regression guard); the graded tier
   uses an LLM judge and only runs when ANTHROPIC_API_KEY is set. Because the
   two arms rank the *same* matched set (re-ordering only), each (query,
   package) pair is judged once and the grade is reused across arms.

   Aggregate the CSV with awk/gnuplot (see README) — no Python, per repo
   convention. *)

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
   opam-user data table; here a substring over the raw author string is enough
   for benchmarking (author queries are rare in the set). *)
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

(* Parse a query-set line: "query" or "query,expected-package". Lines starting
   with '#' and blank lines are ignored. *)
let parse_query_line line =
  let line = String.trim line in
  if line = "" || (String.length line > 0 && line.[0] = '#') then None
  else
    match String.index_opt line ',' with
    | None -> Some (line, None)
    | Some i ->
        let q = String.trim (String.sub line 0 i) in
        let e =
          String.trim (String.sub line (i + 1) (String.length line - i - 1))
        in
        Some (q, if e = "" then None else Some e)

(* ----------------------------------------------------------------------- *)
(* metrics                                                                 *)

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

(* ----------------------------------------------------------------------- *)
(* LLM judge (raw HTTP; OCaml has no official Anthropic SDK)               *)

(* Keep this in sync with tool/search-bench/README.md §Judge prompt. *)
let judge_system_prompt =
  "You are a strict relevance judge for an OCaml package search engine. Given \
   a user's search query and a numbered list of candidate packages (name and \
   one-line synopsis), grade how well each candidate answers the query on this \
   scale:\n\
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
    (fun (i, name, synopsis) ->
      Buffer.add_string buf
        (Printf.sprintf "[%d] %s \xe2\x80\x94 %s\n" i name synopsis))
    candidates;
  Buffer.add_string buf
    "\nReturn ONLY the JSON array of {\"index\",\"grade\"} objects.";
  Buffer.contents buf

(* Pull the first balanced top-level JSON array out of a string, tolerating a
   model that wraps the array in prose or a code fence. *)
let extract_json_array s =
  match (String.index_opt s '[', String.rindex_opt s ']') with
  | Some i, Some j when j > i -> Some (String.sub s i (j - i + 1))
  | _ -> None

let parse_grades text =
  let json_opt =
    match extract_json_array text with Some a -> Some a | None -> None
  in
  match json_opt with
  | None -> []
  | Some arr -> (
      match Yojson.Safe.from_string arr with
      | `List items ->
          List.filter_map
            (fun item ->
              match item with
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

let anthropic_judge ~api_key ~query ~candidates =
  let open Lwt.Syntax in
  let body =
    `Assoc
      [
        ("model", `String "claude-opus-4-8");
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
        (* Extract the first text block's content, then the JSON grades. *)
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

let top_k = 10 (* pooling depth and nDCG cut *)
let name_depth = 50 (* how deep to keep names for MRR *)

let () =
  let query_file =
    if Array.length Sys.argv > 1 then Sys.argv.(1)
    else "tool/search-bench/queries.csv"
  in
  let state = P.load_cached () in
  let all = P.all_latest state in
  Printf.eprintf "Loaded %d packages\n%!" (List.length all);
  if all = [] then (
    prerr_endline
      "No packages in cache. Set OCAMLORG_PKG_STATE_PATH or run the site once \
       to populate ~/.cache/ocamlorg/package.state.";
    exit 1);

  let queries = List.filter_map parse_query_line (read_lines query_file) in
  Printf.eprintf "%d queries\n%!" (List.length queries);

  let names_of pkgs =
    List.filteri (fun i _ -> i < name_depth) pkgs
    |> List.map (fun p -> P.Name.to_string (P.name p))
  in

  (* arms: label, search function *)
  let arms =
    [
      ( "current",
        fun q -> P.search ~is_author_match ~sort_by_popularity:true state q );
      ("bm25f", fun q -> P.search ~is_author_match ~ranking:P.Bm25f state q);
    ]
  in

  (* Warm each arm once so BM25F's one-time corpus-stats build is excluded from
     the measured latency. *)
  List.iter (fun (_, run) -> ignore (run "json")) arms;

  (* Run the synchronous search phase: per (query, arm) collect ranked names +
     latency. *)
  let results =
    List.map
      (fun (query, expected) ->
        let per_arm =
          List.map
            (fun (label, run) ->
              let t0 = Unix.gettimeofday () in
              let pkgs = run query in
              let dt = (Unix.gettimeofday () -. t0) *. 1000.0 in
              (label, names_of pkgs, dt))
            arms
        in
        (query, expected, per_arm))
      queries
  in

  (* Graded phase (optional): judge the pooled top-k of each query once, reuse
     grades across arms. *)
  let synopsis_of name =
    match P.Name.of_string_opt name with
    | None -> ""
    | Some n -> (
        match P.get_latest state n with
        | None -> ""
        | Some pkg -> (P.info pkg).synopsis)
  in
  let grades_by_query = Hashtbl.create 64 in
  (match Sys.getenv_opt "ANTHROPIC_API_KEY" with
  | None ->
      prerr_endline
        "ANTHROPIC_API_KEY unset: skipping graded (nDCG) tier; known-item and \
         latency only."
  | Some api_key ->
      Lwt_main.run
        (let open Lwt.Syntax in
         Lwt_list.iter_s
           (fun (query, _expected, per_arm) ->
             (* pool = union of top_k names across arms *)
             let pool =
               List.concat_map
                 (fun (_, names, _) ->
                   List.filteri (fun i _ -> i < top_k) names)
                 per_arm
               |> List.sort_uniq compare
             in
             let candidates =
               List.mapi (fun i name -> (i, name, synopsis_of name)) pool
             in
             if candidates = [] then Lwt.return_unit
             else
               let* graded = anthropic_judge ~api_key ~query ~candidates in
               let tbl = Hashtbl.create 16 in
               List.iter
                 (fun (idx, g) ->
                   match List.nth_opt pool idx with
                   | Some name -> Hashtbl.replace tbl name g
                   | None -> ())
                 graded;
               Hashtbl.replace grades_by_query query tbl;
               Printf.eprintf "judged %S (%d candidates)\n%!" query
                 (List.length candidates);
               Lwt.return_unit)
           results));

  (* Emit CSV. *)
  print_endline "query,arm,p1,mrr,ndcg5,ndcg10,latency_ms";
  let csv_q = String.map (fun c -> if c = ',' then ' ' else c) in
  List.iter
    (fun (query, expected, per_arm) ->
      List.iter
        (fun (label, names, dt) ->
          let p1, mrr =
            match expected with
            | Some e -> (precision_at1 e names, reciprocal_rank e names)
            | None -> (nan, nan)
          in
          let ndcg5, ndcg10 =
            match Hashtbl.find_opt grades_by_query query with
            | None -> (nan, nan)
            | Some tbl ->
                let ranked_grades =
                  List.filteri (fun i _ -> i < top_k) names
                  |> List.map (fun n ->
                         Option.value ~default:0.0 (Hashtbl.find_opt tbl n))
                in
                (ndcg_at 5 ranked_grades, ndcg_at 10 ranked_grades)
          in
          let f v = if Float.is_nan v then "" else Printf.sprintf "%.4f" v in
          Printf.printf "%s,%s,%s,%s,%s,%s,%.3f\n" (csv_q query) label (f p1)
            (f mrr) (f ndcg5) (f ndcg10) dt)
        per_arm)
    results;

  (* Per-arm means to stderr for a quick read. *)
  let mean l =
    let l = List.filter (fun v -> not (Float.is_nan v)) l in
    match l with
    | [] -> nan
    | _ -> List.fold_left ( +. ) 0.0 l /. float_of_int (List.length l)
  in
  List.iter
    (fun (label, _) ->
      let col pick =
        List.filter_map
          (fun (query, expected, per_arm) ->
            match List.find_opt (fun (l, _, _) -> l = label) per_arm with
            | Some (_, names, dt) -> Some (pick query expected names dt)
            | None -> None)
          results
      in
      let p1 =
        col (fun _ e n _ ->
            match e with Some e -> precision_at1 e n | None -> nan)
      in
      let mrr =
        col (fun _ e n _ ->
            match e with Some e -> reciprocal_rank e n | None -> nan)
      in
      let lat = col (fun _ _ _ dt -> dt) in
      let ndcg10 =
        col (fun q _ n _ ->
            match Hashtbl.find_opt grades_by_query q with
            | None -> nan
            | Some tbl ->
                List.filteri (fun i _ -> i < top_k) n
                |> List.map (fun x ->
                       Option.value ~default:0.0 (Hashtbl.find_opt tbl x))
                |> ndcg_at 10)
      in
      Printf.eprintf
        "arm=%-8s  p@1=%.3f  mrr=%.3f  ndcg@10=%.3f  latency_ms(mean)=%.3f\n%!"
        label (mean p1) (mean mrr) (mean ndcg10) (mean lat))
    arms
