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
   imported-repo clone: everything already summed is carried in [base]. [sync]
   folds every record with it; a periodic full [seed] re-bases any drift from
   [compute_record]. *)
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

(* Recompute the full store and compare it against what is committed, ignoring
   the generation-time provenance stamp so an advancing HEAD does not flag an
   otherwise-fresh store. This is the local, full-history check; CI only runs
   the shallow [sync] below. *)
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

(* --- post-merge synchronisation ------------------------------------------- *)

(* Bring the whole store up to date with HEAD, which must be a commit of the
   default branch: the post-merge workflow (attribution-sync.yml) runs this on a
   checkout of [main] and proposes the result as a pull request.

   This is the store's only writer in normal operation. Pull requests never
   touch it, so they cannot conflict over it. Every record is folded forward
   from its own watermark and re-stamped at HEAD. HEAD is a commit of the
   default branch, not a PR head that a squash merge would discard, so the
   watermark stays reachable; and since every record shares it after a sync, the
   next sync only needs the history since then.

   Structural changes since a record's watermark are handled as well: - a
   deleted document loses its record; - a renamed document (detected at the
   -M90% threshold [git log --follow] uses) keeps its record, re-keyed to the
   new path and folded forward; - a new document gets a record from its own
   history.

   A deletion and an addition that rename detection could not pair (a rename
   combined with heavy edits, say) are ambiguous. Treating them as unrelated
   would silently drop the old document's history, including authors recovered
   from imports, which need clones CI does not have. So [sync] fails and asks
   for a maintainer [seed] instead. *)
let sync cfg =
  let head = Git.head_commit ~root:cfg.root () in
  let generator =
    Git.version ~root:cfg.root () ^ "; " ^ Git.generator_options
  in
  let ignore_revs = Inputs.load_ignore_revs () in
  let sources = Inputs.load_sources () in
  let store = List.map Record.of_line (read_lines cfg.output) in
  let on_disk = documents cfg in
  (* Folding over a history that does not reach a watermark would silently
     under-count (a too-shallow clone looks like "no new commits"), so
     refuse. *)
  List.sort_uniq compare
    (List.map (fun (r : Record.t) -> r.generated_at_commit) store)
  |> List.iter (fun wm ->
         if not (Git.is_ancestor ~root:cfg.root wm) then
           Fmt.failwith
             "watermark %s is not an ancestor of HEAD in the local history \
              (unreachable, or the clone is too shallow); cannot fold from it"
             wm);
  let recorded p = List.exists (fun (r : Record.t) -> r.path = p) store in
  let missing =
    List.filter (fun (r : Record.t) -> not (List.mem r.path on_disk)) store
  in
  let carried, dropped =
    List.partition_map
      (fun (r : Record.t) ->
        let targets =
          Git.renames ~root:cfg.root ~since:r.generated_at_commit ()
          |> List.filter_map (fun (o, n) ->
                 if o = r.path && List.mem n on_disk && not (recorded n) then
                   Some n
                 else None)
        in
        match targets with
        | n :: _ -> Left (n, { r with path = n })
        | [] -> Right r.path)
      missing
  in
  let fresh =
    List.filter (fun p -> not (recorded p || List.mem_assoc p carried)) on_disk
  in
  if dropped <> [] && fresh <> [] then
    Fmt.failwith
      "cannot tell whether %s %s renamed to %s: rename detection found no \
       pairing. Run `make attribution-seed` on an up-to-date main checkout and \
       open a pull request with the result."
      (String.concat ", " dropped)
      (if List.length dropped = 1 then "was" else "were")
      (String.concat ", " fresh);
  let base_of p =
    match List.assoc_opt p carried with
    | Some r -> Some r
    | None -> List.find_opt (fun (r : Record.t) -> r.path = p) store
  in
  let lines =
    List.map
      (fun p ->
        Record.to_line
          (append_record ~cfg ~head ~generator ~ignore_revs ~sources
             ~base:(base_of p) p))
      on_disk
  in
  write_lines cfg.output (sort_lines lines);
  Printf.printf
    "synced %d record(s) at %s in %s (%d renamed, %d removed, %d new)\n"
    (List.length lines) head cfg.output (List.length carried)
    (List.length dropped) (List.length fresh)
