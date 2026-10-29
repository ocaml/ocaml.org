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

(* --- aggregation ---------------------------------------------------------- *)

(* Collect per-name (count, earliest-ts, hash-at-earliest), choosing the
   lexicographically smallest hash on a timestamp tie for determinism. *)
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
    (fun name (commits, ts, hash) acc -> (ts, name, commits, hash) :: acc)
    tbl []
  |> List.sort compare
  |> List.map (fun (ts, name, commits, hash) ->
         {
           Record.name;
           commits;
           first_commit = hash;
           first_date = date_of_ts ts;
         })

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
  let kept =
    List.filter
      (fun c ->
        (not (Inputs.is_ignored ignore_revs c.hash))
        && (not (List.mem c.hash excluded))
        && (not (is_import c))
        && (c.added = max_int (* binary: keep *)
           || (not (c.added = 0 && c.removed = 0))
              && c.added >= cfg.min_lines_added))
      commits
  in
  (* Resolve a co-author "Name <email>" through .mailmap (git only mailmaps the
     commit author's %aN automatically; trailer text is literal), caching the
     work. Returns the canonical name and the e-mail, for classification. *)
  let resolve =
    let cache = Hashtbl.create 16 in
    fun raw ->
      match Hashtbl.find_opt cache raw with
      | Some pair -> pair
      | None ->
          let resolved = Git.resolve_identity ~root:cfg.root raw in
          let pair = (Trailer.name_only resolved, Trailer.email_of raw) in
          Hashtbl.replace cache raw pair;
          pair
  in
  (* Split every credited identity on a kept commit into human contributors, AI
     tools (surfaced in the AI facet, not as human authors), and bots (dropped).
     The author is resolved through this repo's .mailmap as well — git mailmaps
     the author of a commit in *its own* repo, but a commit mined from an
     imported repo (v2) was mailmapped by that repo, so it still needs this
     repo's .mailmap applied on top for cross-repo identities to unify. For a
     commit from this repo the author is already canonical, so this is a
     no-op. *)
  let credited c =
    let author_raw =
      if c.author_email = "" then c.author
      else Printf.sprintf "%s <%s>" c.author c.author_email
    in
    resolve author_raw :: List.map resolve c.co_authors
  in
  let events = ref [] in
  let ai = Hashtbl.create 8 in
  List.iter
    (fun c ->
      let ai_tools =
        List.filter_map
          (fun (name, email) ->
            match Identity.classify ~name ~email with
            | Identity.Human ->
                events := (name, c.hash, c.ts) :: !events;
                None
            | Identity.Ai -> Some name
            | Identity.Bot -> None)
          (credited c)
      in
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
  (* Overrides may credit extra names; they carry no commit of their own. *)
  let events = !events @ List.map (fun n -> (n, "", 0)) override.Inputs.add in
  let contributors =
    aggregate_contributors events
    (* A pure override-add has ts 0; surface it with an empty first_commit. *)
    |> List.map (fun c ->
           if c.Record.first_commit = "" then { c with Record.first_date = "" }
           else c)
  in
  (* Derived-from: internal "path@commit" stay as-is; "source:<key>" resolve to
     external authors through the manifest. Declared both by commit trailers and
     by the per-document override (for imports with no trailer). *)
  let internal, external_authors =
    List.concat_map (fun c -> c.derived_from) kept
    @ override.Inputs.derived_from @ import_df
    |> List.fold_left
         (fun (int_acc, ext_acc) v ->
           match String.index_opt v ':' with
           | Some i when String.sub v 0 i = "source" ->
               let key = String.sub v (i + 1) (String.length v - i - 1) in
               (int_acc, Inputs.source_authors sources key @ ext_acc)
           | _ -> (v :: int_acc, ext_acc))
         ([], [])
  in
  let ai_assisted =
    Hashtbl.fold (fun _ entry acc -> entry :: acc) ai []
    |> List.sort (fun (ta, a) (tb, b) ->
           compare (ta, a.Record.commit) (tb, b.Record.commit))
    |> List.map snd
  in
  let provenance_unknown_before =
    List.filter is_import commits
    |> List.fold_left (fun acc c -> max acc c.ts) 0
    |> fun ts -> if ts = 0 then None else Some (date_of_ts ts)
  in
  let overrides_applied =
    List.filter_map
      (fun h ->
        if List.exists (fun c -> c.hash = h) commits then Some ("exclude:" ^ h)
        else None)
      excluded
    @ List.map (fun n -> "add:" ^ n) override.Inputs.add
    @ List.map (fun d -> "derived:" ^ d) override.Inputs.derived_from
    @ (match import with
      | Some (src, _) when imported_commits <> [] -> [ "import:" ^ src ]
      | _ -> [])
    @ match override.Inputs.notes with Some n -> [ "note:" ^ n ] | None -> []
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

let update cfg paths =
  let fresh = records_for cfg paths in
  let updated = List.map (fun r -> (r.Record.path, Record.to_line r)) fresh in
  let kept =
    read_lines cfg.output
    |> List.filter (fun l ->
           not (List.mem_assoc (Record.path_of_line l) updated))
  in
  let lines = kept @ List.map snd updated in
  write_lines cfg.output (sort_lines lines);
  Printf.printf "updated %d record(s) in %s\n" (List.length updated) cfg.output

(* Recompute the full store and compare it against what is committed, ignoring
   the generation-time provenance stamp so an advancing HEAD does not flag an
   otherwise-fresh store. Per-PR CI freshness (scoped to the changed files) is
   wired up in Phase 2. *)
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
