(* The per-document attribution pipeline and the JSON Lines store.

   For each document we collect its commit history (following renames), filter
   trivial commits, aggregate contributors, and fold in the trailer vocabulary,
   then emit one [Record.t] per document into [data/attribution.jsonl], sorted
   by path. See the issue for the step-by-step specification. *)

type config = {
  root : string; (* repository root passed to [git -C] *)
  output : string; (* the JSON Lines store *)
  docs_roots : string list; (* directories scanned for *.md documents *)
  min_lines_added : int; (* drop commits adding fewer non-ws lines (0 = off) *)
}

let default_config =
  {
    root = ".";
    output = "data/attribution.jsonl";
    docs_roots = [ "data/tutorials"; "data/tool_pages" ];
    min_lines_added = 0;
  }

(* --- commit parsing ------------------------------------------------------- *)

type commit = {
  hash : string;
  ts : int;
  author : string;
  author_email : string;
  co_authors : string list; (* raw "Name <email>", resolved later *)
  derived_from : string list;
  provenance : string;
  imported_from : string list;
  assisted_by : string list;
  ai_sections : string list;
  ai_context : string list;
  added : int; (* non-whitespace lines added; [max_int] for a binary change *)
  removed : int;
}

let parse_int_or_dash = function "-" | "" -> max_int | s -> int_of_string s

(* Sum the numstat lines that follow a commit's format line. *)
let parse_numstat lines =
  List.fold_left
    (fun (a, r) line ->
      match String.split_on_char '\t' line with
      | added :: removed :: _ ->
          (a + parse_int_or_dash added, r + parse_int_or_dash removed)
      | _ -> (a, r))
    (0, 0)
    (List.filter (fun l -> String.contains l '\t') lines)

let field a i = if i < Array.length a then a.(i) else ""

let parse_commit chunk =
  match String.split_on_char '\n' chunk with
  | [] -> None
  | head :: numstat ->
      let f = Array.of_list (String.split_on_char '\t' head) in
      if Array.length f < 4 || field f 0 = "" then None
      else
        let added, removed = parse_numstat numstat in
        Some
          {
            hash = field f 0;
            ts = int_of_string (String.trim (field f 1));
            author = String.trim (field f 2);
            author_email = String.trim (field f 3);
            co_authors = Trailer.values (field f 4);
            derived_from = Trailer.values (field f 5);
            provenance = field f 6;
            imported_from = Trailer.values (field f 7);
            assisted_by = Trailer.co_authors (field f 8);
            ai_sections = Trailer.values (field f 9);
            ai_context = Trailer.values (field f 10);
            added;
            removed;
          }

let parse_log raw =
  String.split_on_char '\x1e' raw
  |> List.filter_map (fun chunk ->
         if String.trim chunk = "" then None else parse_commit chunk)

(* --- helpers -------------------------------------------------------------- *)

let date_of_ts ts =
  let tm = Unix.gmtime (float_of_int ts) in
  Printf.sprintf "%04d-%02d-%02d" (tm.Unix.tm_year + 1900) (tm.Unix.tm_mon + 1)
    tm.Unix.tm_mday

let sort_uniq_strings l = List.sort_uniq compare l
let is_import c = c.imported_from <> [] || Trailer.is_unknown c.provenance

(* Midnight-UTC unix timestamp for a "YYYY-MM-DD" date (civil-to-days, after
   Howard Hinnant). Used to re-seed [aggregate_contributors] from a base
   record's day-granularity [first_date]; exact enough because the new commits
   folded on top are strictly later. 0 for an empty/unparseable date. *)
let ts_of_date s =
  try
    Scanf.sscanf s "%d-%d-%d" (fun y m d ->
        let y = if m <= 2 then y - 1 else y in
        let era = (if y >= 0 then y else y - 399) / 400 in
        let yoe = y - (era * 400) in
        let doy = (((153 * if m > 2 then m - 3 else m + 9) + 2) / 5) + d - 1 in
        let doe = (yoe * 365) + (yoe / 4) - (yoe / 100) + doy in
        ((era * 146097) + doe - 719468) * 86400)
  with _ -> 0

(* --- aggregation ---------------------------------------------------------- *)

(* Collect per-name (count, earliest-ts, hash-at-earliest), choosing the
   lexicographically smallest hash on a timestamp tie for determinism.

   The final order is keyed on (first_date, name), NOT the raw timestamp: the
   incremental fold re-anchors a base contributor at midnight of its recorded
   [first_date] (day granularity is all the record carries), so ordering on the
   sub-day timestamp would make [seed] and the fold disagree whenever two
   contributors share a first date. Day + name is identical on both paths. *)
let aggregate_contributors events =
  let tbl = Hashtbl.create 16 in
  List.iter
    (fun (name, hash, ts) ->
      match Hashtbl.find_opt tbl name with
      | None -> Hashtbl.replace tbl name (1, ts, hash)
      | Some (n, best_ts, best_hash) ->
          let best_ts, best_hash =
            if ts < best_ts || (ts = best_ts && hash < best_hash) then (ts, hash)
            else (best_ts, best_hash)
          in
          Hashtbl.replace tbl name (n + 1, best_ts, best_hash))
    events;
  Hashtbl.fold
    (fun name (commits, ts, hash) acc ->
      { Record.name; commits; first_commit = hash; first_date = date_of_ts ts }
      :: acc)
    tbl []
  |> List.sort (fun (a : Record.contributor) b ->
         compare (a.first_date, a.name) (b.first_date, b.name))

(* --- shared commit processing --------------------------------------------- *)

(* Is this commit kept for attribution (not blame-ignored, not
   override-excluded, not an import marker, and not a trivial
   whitespace-only/too-small change)? *)
let keep_commit ~cfg ~ignore_revs ~excluded c =
  (not (Inputs.is_ignored ignore_revs c.hash))
  && (not (List.mem c.hash excluded))
  && (not (is_import c))
  && (c.added = max_int (* binary: keep *)
     || ((not (c.added = 0 && c.removed = 0)) && c.added >= cfg.min_lines_added)
     )

(* Resolve a co-author "Name <email>" through .mailmap (git only mailmaps the
   commit author's %aN automatically; trailer text is literal), caching the
   work. Returns the canonical name and the e-mail, for classification. *)
let make_resolver ~cfg =
  let cache = Hashtbl.create 16 in
  fun raw ->
    match Hashtbl.find_opt cache raw with
    | Some pair -> pair
    | None ->
        let resolved = Git.resolve_identity ~root:cfg.root raw in
        let pair = (Trailer.name_only resolved, Trailer.email_of raw) in
        Hashtbl.replace cache raw pair;
        pair

(* Every credited identity on a commit: the author (resolved through this repo's
   .mailmap too — a commit mined from an imported repo was mailmapped by that
   repo, so cross-repo identities still need this repo's .mailmap on top; for a
   commit from this repo the author is already canonical, so it is a no-op) plus
   its Co-authored-by trailers. *)
let credited ~resolve c =
  let author_raw =
    if c.author_email = "" then c.author
    else Printf.sprintf "%s <%s>" c.author c.author_email
  in
  resolve author_raw :: List.map resolve c.co_authors

(* Fold kept commits into (human contributor events, AI entries tagged with
   their timestamp, raw Derived-from values). Splitting every credited identity
   into human contributors, AI tools (surfaced in the AI facet, not as human
   authors), and bots (dropped). Override- and import-declared derived-from are
   merged in by the caller. *)
let fold_kept ~resolve kept =
  let events = ref [] in
  let ai = Hashtbl.create 8 in
  List.iter
    (fun c ->
      (* A commit credits each distinct identity once. Someone who is both the
         author and a Co-authored-by trailer on the same commit — or appears
         under two e-mail spellings that mailmap to one name — must count once,
         not twice, towards their commit tally. *)
      let people = List.sort_uniq compare (credited ~resolve c) in
      let humans = ref [] in
      let ai_tools =
        List.filter_map
          (fun (name, email) ->
            match Identity.classify ~name ~email with
            | Identity.Human ->
                humans := name :: !humans;
                None
            | Identity.Ai -> Some name
            | Identity.Bot -> None)
          people
      in
      List.iter
        (fun name -> events := (name, c.hash, c.ts) :: !events)
        (List.sort_uniq compare !humans);
      if
        ai_tools <> [] || c.assisted_by <> [] || c.ai_sections <> []
        || c.ai_context <> []
      then
        Hashtbl.replace ai c.hash
          ( c.ts,
            {
              Record.commit = c.hash;
              assisted_by = sort_uniq_strings (ai_tools @ c.assisted_by);
              sections = c.ai_sections;
              context = c.ai_context;
            } ))
    kept;
  let ai_entries = Hashtbl.fold (fun _ entry acc -> entry :: acc) ai [] in
  let derived_raw = List.concat_map (fun c -> c.derived_from) kept in
  (!events, ai_entries, derived_raw)

(* Derived-from: internal "path@commit" stay as-is; "source:<key>" resolve to
   external authors through the manifest. *)
let split_derived ~sources values =
  List.fold_left
    (fun (int_acc, ext_acc) v ->
      match String.index_opt v ':' with
      | Some i when String.sub v 0 i = "source" ->
          let key = String.sub v (i + 1) (String.length v - i - 1) in
          (int_acc, Inputs.source_authors sources key @ ext_acc)
      | _ -> (v :: int_acc, ext_acc))
    ([], []) values

(* Surface a pure override-add (ts 0, no commit of its own) with empty
   first_*. *)
let blank_override_adds =
  List.map (fun c ->
      if c.Record.first_commit = "" then { c with Record.first_date = "" }
      else c)

let ai_sorted entries =
  entries
  |> List.sort (fun (ta, a) (tb, b) ->
         compare (ta, a.Record.commit) (tb, b.Record.commit))
  |> List.map snd

(* --- the per-document record ---------------------------------------------- *)

let compute_record ~cfg ~head ~generator ~ignore_revs ~sources ~imports path =
  let override = Inputs.load_override ~doc_path:path () in
  let excluded = override.Inputs.exclude_commits in
  (* Commits from this repo, plus — for an imported document whose source clone
     is present — the history it had in that earlier repo, so contributors
     aggregate across the whole lineage. *)
  let import = Inputs.import_of imports path in
  let imported_commits =
    match (imports, import) with
    | Some i, Some (src_path, _) when Inputs.repo_present imports ->
        parse_log (Git.log_document ~root:i.Inputs.repo ~path:src_path ())
    | _ -> []
  in
  let import_df = match import with Some (_, df) -> df | None -> [] in
  let commits =
    parse_log (Git.log_document ~root:cfg.root ~path ()) @ imported_commits
  in
  let kept = List.filter (keep_commit ~cfg ~ignore_revs ~excluded) commits in
  let resolve = make_resolver ~cfg in
  let events, ai_entries, derived_raw = fold_kept ~resolve kept in
  (* Overrides may credit extra names; they carry no commit of their own. *)
  let events = events @ List.map (fun n -> (n, "", 0)) override.Inputs.add in
  let contributors = blank_override_adds (aggregate_contributors events) in
  let internal, external_authors =
    split_derived ~sources
      (derived_raw @ override.Inputs.derived_from @ import_df)
  in
  let ai_assisted = ai_sorted ai_entries in
  let provenance_unknown_before =
    List.filter is_import commits
    |> List.fold_left (fun acc c -> max acc c.ts) 0
    |> fun ts -> if ts = 0 then None else Some (date_of_ts ts)
  in
  let overrides_applied =
    (* Sorted/deduped to match [append_record], which applies
       [sort_uniq_strings] to its own audit trail; otherwise seed and fold would
       differ on any document carrying more than one override category. *)
    sort_uniq_strings
      (List.filter_map
         (fun h ->
           if List.exists (fun c -> c.hash = h) commits then
             Some ("exclude:" ^ h)
           else None)
         excluded
      @ List.map (fun n -> "add:" ^ n) override.Inputs.add
      @ List.map (fun d -> "derived:" ^ d) override.Inputs.derived_from
      @ (match import with
        | Some (src, _) when imported_commits <> [] -> [ "import:" ^ src ]
        | _ -> [])
      @
      match override.Inputs.notes with Some n -> [ "note:" ^ n ] | None -> [])
  in
  {
    Record.path;
    contributors;
    derived_from = sort_uniq_strings internal;
    external_authors = sort_uniq_strings external_authors;
    provenance_unknown_before;
    ai_assisted;
    overrides_applied;
    generated_at_commit = head;
    generator;
  }

(* --- incremental fold: base record + only the new commits
   ------------------ *)

(* Extend a committed record ([base]) with the commits that touched [path] since
   that record's own watermark ([generated_at_commit]), for a new document the
   full history. Additions-only, so it needs neither the full clone nor the
   imported-repo clone: everything already summed is carried in [base]. [update]
   and [verify] share this, so what a maintainer commits locally and what CI
   recomputes are identical by construction; a periodic full [seed] re-bases any
   drift from [compute_record]. *)
let append_record ~cfg ~head ~generator ~ignore_revs ~sources ~base path =
  let override = Inputs.load_override ~doc_path:path () in
  let excluded = override.Inputs.exclude_commits in
  let range =
    match base with
    | Some (r : Record.t) -> Some (r.generated_at_commit ^ "..HEAD")
    | None -> None
  in
  let commits = parse_log (Git.log_document ~root:cfg.root ?range ~path ()) in
  let kept = List.filter (keep_commit ~cfg ~ignore_revs ~excluded) commits in
  let resolve = make_resolver ~cfg in
  let new_events, new_ai, derived_raw = fold_kept ~resolve kept in
  (* Reconstruct the base's real contributors as synthetic events — an anchor at
     the recorded first commit/date plus [commits-1] far-future fillers — so
     [aggregate_contributors] reproduces their counts and earliest commit while
     the new (strictly later) events fold on top. Base override-adds (empty
     first_commit) are dropped and re-added below. *)
  let base_events =
    match base with
    | None -> []
    | Some r ->
        List.concat_map
          (fun (c : Record.contributor) ->
            if c.first_commit = "" then []
            else
              (c.name, c.first_commit, ts_of_date c.first_date)
              :: List.init
                   (max 0 (c.commits - 1))
                   (fun _ -> (c.name, "", max_int)))
          r.contributors
  in
  let events =
    base_events @ new_events
    @ List.map (fun n -> (n, "", 0)) override.Inputs.add
  in
  let contributors = blank_override_adds (aggregate_contributors events) in
  let base_internal, base_external, base_ai, base_pub, base_oa =
    match base with
    | Some (r : Record.t) ->
        ( r.derived_from,
          r.external_authors,
          r.ai_assisted,
          r.provenance_unknown_before,
          r.overrides_applied )
    | None -> ([], [], [], None, [])
  in
  let internal_new, external_new =
    split_derived ~sources (derived_raw @ override.Inputs.derived_from)
  in
  let base_ai_commits = List.map (fun e -> e.Record.commit) base_ai in
  let ai_assisted =
    base_ai
    @ List.filter
        (fun e -> not (List.mem e.Record.commit base_ai_commits))
        (ai_sorted new_ai)
  in
  let provenance_unknown_before =
    let dates =
      (match base_pub with Some d -> [ d ] | None -> [])
      @ (List.filter is_import commits |> List.map (fun c -> date_of_ts c.ts))
    in
    match List.sort compare dates with
    | [] -> None
    | l -> Some (List.nth l (List.length l - 1))
  in
  let overrides_applied =
    sort_uniq_strings
      (base_oa
      @ List.filter_map
          (fun h ->
            if List.exists (fun c -> c.hash = h) commits then
              Some ("exclude:" ^ h)
            else None)
          excluded
      @ List.map (fun n -> "add:" ^ n) override.Inputs.add
      @ List.map (fun d -> "derived:" ^ d) override.Inputs.derived_from
      @
      match override.Inputs.notes with Some n -> [ "note:" ^ n ] | None -> [])
  in
  {
    Record.path;
    contributors;
    derived_from = sort_uniq_strings (base_internal @ internal_new);
    external_authors = sort_uniq_strings (base_external @ external_new);
    provenance_unknown_before;
    ai_assisted;
    overrides_applied;
    generated_at_commit = head;
    generator;
  }

(* Kept commits that touch [path] after [stamp] — a non-empty result means the
   committed record's watermark lags its content, which would cause a later
   incremental fold to double-count, so it must fail the freshness gate. *)
let unfolded_commits ~cfg ~ignore_revs ~stamp path =
  let override = Inputs.load_override ~doc_path:path () in
  let excluded = override.Inputs.exclude_commits in
  parse_log (Git.log_document ~root:cfg.root ~range:(stamp ^ "..HEAD") ~path ())
  |> List.filter (keep_commit ~cfg ~ignore_revs ~excluded)

(* --- document discovery --------------------------------------------------- *)

let documents cfg =
  List.concat_map
    (fun dir ->
      let add p acc = if Fpath.has_ext "md" p then p :: acc else acc in
      match Bos.OS.Dir.fold_contents add [] (Fpath.v dir) with
      | Ok paths -> paths
      | Error (`Msg m) -> failwith m)
    cfg.docs_roots
  |> List.map Fpath.to_string |> List.sort compare

(* --- the JSON Lines store ------------------------------------------------- *)

let read_lines path =
  match Bos.OS.File.read (Fpath.v path) with
  | Error _ -> []
  | Ok s ->
      String.split_on_char '\n' s |> List.filter (fun l -> String.trim l <> "")

let write_lines path lines =
  let content = String.concat "\n" lines ^ "\n" in
  match Bos.OS.File.write (Fpath.v path) content with
  | Ok () -> ()
  | Error (`Msg m) -> failwith m

let sort_lines lines =
  List.sort
    (fun a b -> compare (Record.path_of_line a) (Record.path_of_line b))
    lines

(* --- commands ------------------------------------------------------------- *)

let context cfg =
  let head = Git.head_commit ~root:cfg.root () in
  let generator =
    Git.version ~root:cfg.root () ^ "; " ^ Git.generator_options
  in
  let ignore_revs = Inputs.load_ignore_revs () in
  let sources = Inputs.load_sources () in
  let imports = Inputs.load_imports () in
  (head, generator, ignore_revs, sources, imports)

let records_for cfg paths =
  let head, generator, ignore_revs, sources, imports = context cfg in
  List.map
    (fun path ->
      compute_record ~cfg ~head ~generator ~ignore_revs ~sources ~imports path)
    paths

let seed cfg =
  let paths = documents cfg in
  let lines = List.map Record.to_line (records_for cfg paths) in
  write_lines cfg.output (sort_lines lines);
  Printf.printf "wrote %d records to %s\n" (List.length lines) cfg.output

(* Incrementally fold each path's record forward from its own committed
   watermark and splice it back in place. Needs only the commits since that
   watermark (shallow-friendly), not the full history [seed] uses. *)
let update cfg paths =
  (* Guard against a typo'd path silently writing an empty record: a document
     must exist on disk to be folded. *)
  List.iter
    (fun path ->
      if not (Sys.file_exists (Filename.concat cfg.root path)) then
        Fmt.failwith "no such document: %s (nothing to update)" path)
    paths;
  let head = Git.head_commit ~root:cfg.root () in
  let generator =
    Git.version ~root:cfg.root () ^ "; " ^ Git.generator_options
  in
  let ignore_revs = Inputs.load_ignore_revs () in
  let sources = Inputs.load_sources () in
  let store = read_lines cfg.output in
  let base_of path =
    List.find_opt (fun l -> Record.path_of_line l = path) store
    |> Option.map Record.of_line
  in
  let updated =
    List.map
      (fun path ->
        let base = base_of path in
        let r =
          append_record ~cfg ~head ~generator ~ignore_revs ~sources ~base path
        in
        (path, Record.to_line r))
      paths
  in
  let kept =
    store
    |> List.filter (fun l ->
           not (List.mem_assoc (Record.path_of_line l) updated))
  in
  write_lines cfg.output (sort_lines (kept @ List.map snd updated));
  Printf.printf "updated %d record(s) in %s\n" (List.length updated) cfg.output

(* Re-anchor the watermark onto a reachable commit, WITHOUT folding anything:
   set [generated_at_commit] (and refresh [generator]) to the current HEAD for
   the given documents, leaving every content field exactly as committed.

   This exists because the project squash-merges PRs. [update]/[verify] stamp a
   record at the PR's branch head; a squash merge discards that commit, so once
   merged the watermark names a commit that is no longer on the branch, and the
   next document edit's fold ([<watermark>..HEAD]) cannot resolve it. Running
   [restamp] on the default branch after a merge moves each touched record's
   watermark onto the (reachable) merge commit, so incremental maintenance stays
   anchored. It is safe precisely because it does no folding: the attribution
   gate already verified this tree's content before the merge, so only the stamp
   needs to advance. A document with no committed record yet is skipped. *)
let restamp cfg paths =
  List.iter
    (fun path ->
      if not (Sys.file_exists (Filename.concat cfg.root path)) then
        Fmt.failwith "no such document: %s (nothing to restamp)" path)
    paths;
  let head = Git.head_commit ~root:cfg.root () in
  let generator =
    Git.version ~root:cfg.root () ^ "; " ^ Git.generator_options
  in
  let targets = List.sort_uniq compare paths in
  let restamped = ref 0 in
  let lines =
    List.map
      (fun line ->
        if List.mem (Record.path_of_line line) targets then (
          incr restamped;
          Record.to_line
            { (Record.of_line line) with generated_at_commit = head; generator })
        else line)
      (read_lines cfg.output)
  in
  write_lines cfg.output (sort_lines lines);
  Printf.printf "restamped %d record(s) at %s in %s\n" !restamped head
    cfg.output

(* Recompute the full store and compare it against what is committed, ignoring
   the generation-time provenance stamp so an advancing HEAD does not flag an
   otherwise-fresh store. This is the local, full-history check; CI uses the
   shallow [verify] below instead. *)
let check cfg =
  let paths = documents cfg in
  let content l = (Record.path_of_line l, Record.content_of_line l) in
  let expected =
    List.map content (List.map Record.to_line (records_for cfg paths))
  in
  let actual = List.map content (read_lines cfg.output) in
  if List.sort compare expected = List.sort compare actual then (
    Printf.printf "%s is up to date (%d records)\n" cfg.output
      (List.length expected);
    0)
  else (
    (match
       List.find_opt
         (fun (path, c) -> List.assoc_opt path actual <> Some c)
         expected
     with
    | Some (path, _) ->
        Printf.eprintf "%s is stale; recompute differs at %s\n" cfg.output path
    | None ->
        let missing =
          List.filter (fun (p, _) -> not (List.mem_assoc p expected)) actual
        in
        List.iter
          (fun (p, _) ->
            Printf.eprintf "%s has a stale record for a removed document: %s\n"
              cfg.output p)
          missing);
    1)

(* The shallow CI gate. For each changed document, independently recompute the
   expected record by folding the PR's commits onto the base branch's committed
   record, and require that:

   - the committed record's content matches that recompute (so the author ran
   [update] and it is correct), and - no kept commit touches the document after
   the committed record's watermark (so the watermark covers the content and a
   later fold will not double-count).

   This needs only the base record (via [git show]) and the commits since each
   watermark — never the full history — so CI stays shallow. *)
let verify cfg ~base paths =
  let head = Git.head_commit ~root:cfg.root () in
  let generator =
    Git.version ~root:cfg.root () ^ "; " ^ Git.generator_options
  in
  let ignore_revs = Inputs.load_ignore_revs () in
  let sources = Inputs.load_sources () in
  let base_lines =
    match Git.show_file ~root:cfg.root ~rev:base ~path:cfg.output () with
    | Some s ->
        String.split_on_char '\n' s
        |> List.filter (fun l -> String.trim l <> "")
    | None -> []
  in
  let line_for lines path =
    List.find_opt (fun l -> Record.path_of_line l = path) lines
  in
  let committed = read_lines cfg.output in
  let hint path =
    Printf.sprintf
      "run `make attribution-update PATHS=%s` and commit the result" path
  in
  let failures =
    List.filter_map
      (fun path ->
        let base_record =
          Option.map Record.of_line (line_for base_lines path)
        in
        let expected =
          append_record ~cfg ~head ~generator ~ignore_revs ~sources
            ~base:base_record path
        in
        match line_for committed path with
        | None ->
            Some
              (Printf.sprintf "%s: changed but has no attribution record; %s"
                 path (hint path))
        | Some line ->
            let committed_record = Record.of_line line in
            let content_ok =
              Record.content_of_line (Record.to_line expected)
              = Record.content_of_line line
            in
            let fresh_ok =
              unfolded_commits ~cfg ~ignore_revs
                ~stamp:committed_record.generated_at_commit path
              = []
            in
            if not content_ok then
              Some
                (Printf.sprintf
                   "%s: attribution record does not match base + PR commits; %s"
                   path (hint path))
            else if not fresh_ok then
              Some
                (Printf.sprintf
                   "%s: attribution record is not re-stamped past its newest \
                    commit; %s"
                   path (hint path))
            else None)
      paths
  in
  match failures with
  | [] ->
      Printf.printf "attribution: %d record(s) verified\n" (List.length paths);
      0
  | fs ->
      List.iter (Printf.eprintf "%s\n") fs;
      1
