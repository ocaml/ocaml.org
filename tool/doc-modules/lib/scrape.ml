(* Scrape the module paths of every package's documentation into
   doc-modules.jsonl, the reference form that Compile turns into the index the
   server memory-maps (see #3982), to answer "which package provides module X".

   For each package of OPAM_REPOSITORY/packages, fetch doc/sidebar.json from the
   documentation backend for the latest version that has docs (the latest, then
   up to three older ones, in opam's version order), and extract its module
   paths (Sidebar).

   State. STATE_DIR/state.jsonl (State) is self-contained; the output is
   regenerated from it, never read back. Neither STATE_DIR nor the output is
   touched unless the run succeeds: everything, the stats record included, is
   computed first, then the output and the state are renamed into place and the
   record appended. STATE_DIR can be lost (it lives in a CI cache): the next run
   refetches everything and produces the same data.

   Outcomes per package: - 200 with a sidebar: new module paths; 304: unchanged;
   - 404 on every candidate version, or a sidebar without modules: no docs; -
   anything else (5xx, 429, redirects, timeouts, truncated, empty or garbled
   bodies): an error, and the package keeps its previous state.

   The run aborts, changing nothing but the stats, if OPAM_REPOSITORY lists no
   package, if [max_failures_in_a_row] packages fail in a row (checked as it
   goes, so that a failing backend is not sent every request), if more than
   [max_errors] percent of the attempted requests fail, or if more than
   [max_losses] percent of the packages that had docs now have none or are gone
   from OPAM_REPOSITORY: these mean the backend or the clone, not the packages,
   changed. The packages that had docs are those of the state, or, if the state
   has none (lost, reset or damaged), those of the [baseline] index, the
   published one: a run from scratch must not publish a much smaller index. A
   genuine mass removal from opam-repository keeps aborting: a run from an empty
   STATE_DIR without a baseline (the workflow's `reset`) has nothing to lose and
   accepts it.

   Load on the backend: see Http. ~3.6k requests, ~8 min daily; ~5.3k, ~15 min
   after a backend rebuild. Packages without docs are asked again when their
   candidate versions change, and otherwise once every [retry_days], a different
   share of them each day (State.attempts).

   Per package, paths deeper than [max_depth] and beyond the first [max_paths]
   (shallowest first) are dropped: a few packages define tens of thousands of
   modules or more (awso, the AWS SDK, about 131k: one per service, then one per
   API type), and lookups are for the top. *)

type config = {
  doc_url : string;
  rate : float;  (** requests per second *)
  max_time : float;  (** seconds per request *)
  max_errors : int;  (** percent of attempted requests *)
  max_losses : int;  (** percent of packages that had docs *)
  max_failures_in_a_row : int;
  baseline : string option;
      (** the published index: the packages that had docs if the state has none
      *)
  retry_days : int;
  day : int;  (** days since the epoch; decides the re-probes *)
  limit : int;  (** 0: all packages; for testing only *)
  max_depth : int;
  max_paths : int;
}

let default_doc_url = "https://dill.caelum.ci.dev/profiles/full/docs/"

let default =
  {
    doc_url = default_doc_url;
    rate = 8.;
    max_time = 20.;
    max_errors = 10;
    max_losses = 10;
    max_failures_in_a_row = 20;
    baseline = None;
    retry_days = 7;
    day = int_of_float (Unix.time ()) / 86400;
    limit = 0;
    max_depth = 3;
    max_paths = 500;
  }

let is_dir p = try Sys.is_directory p with Sys_error _ -> false

(* Candidate versions per package, newest first (at most 4), sorted by name. *)
let listing ~limit repo =
  let dir = Filename.concat repo "packages" in
  let names =
    if is_dir dir then
      Sys.readdir dir |> Array.to_list
      |> List.filter (fun n -> is_dir (Filename.concat dir n))
      |> List.sort String.compare
    else []
  in
  let names =
    if limit > 0 then List.filteri (fun i _ -> i < limit) names else names
  in
  List.filter_map
    (fun name ->
      let prefix = name ^ "." in
      let versions =
        Sys.readdir (Filename.concat dir name)
        |> Array.to_list
        |> List.filter_map (fun d ->
            if String.starts_with ~prefix d then
              Some
                (String.sub d (String.length prefix)
                   (String.length d - String.length prefix))
            else None)
        |> List.sort (fun a b ->
            OpamPackage.Version.compare
              (OpamPackage.Version.of_string b)
              (OpamPackage.Version.of_string a))
        |> List.filteri (fun i _ -> i < 4)
      in
      if versions = [] then None else Some (name, versions))
    names

type outcome =
  | Skipped
  | Fetched of State.docs * int option  (** and the Last-Modified time *)
  | Unchanged of string  (** the version revalidated *)
  | Missing
  | Failed of string * string  (** the version, the error *)

let sidebar_uri config name version =
  Uri.of_string
    (Printf.sprintf "%sp/%s/%s/doc/sidebar.json" config.doc_url name version)

(* Tries the attempts in order until one answers something else than 404. *)
let probe config http name previous attempts =
  let open Lwt.Syntax in
  let etag =
    match previous with Some { State.docs = Some d; _ } -> d.etag | _ -> None
  in
  let rec go bytes = function
    | [] -> Lwt.return (Missing, bytes)
    | { State.version; conditional } :: rest -> (
        let etag = if conditional then etag else None in
        let* r = Http.get http ?etag (sidebar_uri config name version) in
        match r with
        | Error e -> Lwt.return (Failed (version, e), bytes)
        | Ok r -> (
            let bytes = bytes + r.bytes in
            match r.status with
            | 200 -> (
                match
                  Sidebar.of_string ~max_depth:config.max_depth
                    ~max_paths:config.max_paths r.body
                with
                | Error e -> Lwt.return (Failed (version, e), bytes)
                | Ok [] -> Lwt.return (Missing, bytes)
                | Ok modules ->
                    let lm =
                      Option.bind r.last_modified Stats.parse_http_date
                    in
                    Lwt.return
                      (Fetched ({ version; modules; etag = r.etag }, lm), bytes)
                )
            | 304 when conditional -> Lwt.return (Unchanged version, bytes)
            | 404 -> go bytes rest
            | s ->
                Lwt.return (Failed (version, Printf.sprintf "HTTP %d" s), bytes)
            ))
  in
  go 0 attempts

let read_file path = In_channel.with_open_bin path In_channel.input_all

let write_atomic path contents =
  let tmp = path ^ ".tmp" in
  Out_channel.with_open_bin tmp (fun oc -> output_string oc contents);
  Sys.rename tmp path

let rec remove_tree p =
  if is_dir p then (
    Array.iter (fun n -> remove_tree (Filename.concat p n)) (Sys.readdir p);
    Sys.rmdir p)
  else if Sys.file_exists p then Sys.remove p

let load_state dir =
  let path = Filename.concat dir "state.jsonl" in
  if not (Sys.file_exists path) then State.empty
  else
    match State.of_string (read_file path) with
    | Ok s -> s
    | Error e ->
        Printf.eprintf "Ignoring the scrape state %s: %s\n%!" path e;
        State.empty

(* The new state entry of a package, from its outcome. *)
let next_entry previous candidates outcome =
  let latest = List.hd candidates in
  match outcome with
  | Skipped | Failed _ -> previous
  | Fetched (docs, _) -> Some { State.latest; candidates; docs = Some docs }
  | Unchanged version -> (
      match previous with
      | Some { State.docs = Some d; _ } ->
          Some { State.latest; candidates; docs = Some { d with version } }
      | _ -> None (* an ETag without its data: fetch it afresh next time *))
  | Missing -> Some { State.latest; candidates; docs = None }

let line (e : State.entry) =
  Option.map (fun (d : State.docs) -> (d.version, d.modules)) e.docs

(* Packages whose docs were added, removed or changed. *)
let changed (old_state : State.t) (new_state : State.t) =
  State.M.merge
    (fun _ a b ->
      let a = Option.bind a line and b = Option.bind b line in
      if a = b then None else Some ())
    old_state new_state
  |> State.M.bindings |> List.map fst

let report ~packages ~with_modules ~count ~skipped ~errors ~changed ~requests
    ~bytes =
  String.concat "\n"
    [
      Printf.sprintf "Packages: %d, %d with module paths." packages with_modules;
      "";
      "| this run | packages |";
      "| --- | --- |";
      Printf.sprintf "| fetched (200) | %d |" (count `Fetched);
      Printf.sprintf "| unchanged (304) | %d |" (count `Unchanged);
      Printf.sprintf "| no docs | %d |" (count `Missing);
      Printf.sprintf "| not asked (no docs, same candidates) | %d |" skipped;
      Printf.sprintf "| errors, previous state kept | %d |" errors;
      "";
      Printf.sprintf "Packages changed: %d." changed;
      Printf.sprintf "Requests: %d, %d bytes (gzip)." requests bytes;
      "";
    ]

let iso8601_now () =
  let t = Unix.gmtime (Unix.time ()) in
  Printf.sprintf "%04d-%02d-%02dT%02d:%02d:%02dZ" (t.tm_year + 1900)
    (t.tm_mon + 1) t.tm_mday t.tm_hour t.tm_min t.tm_sec

(* Runs a scrape. [Ok report] (Markdown) on success; [Error reason] if it
   aborted. Either way, appends one Stats record to [stats] if given. *)
let run ?(config = default) ?stats ~repo ~state_dir ~output () =
  let started = int_of_float (Unix.time ()) in
  let old_state = load_state state_dir in
  let packages = listing ~limit:config.limit repo in
  (* The packages that had docs: see the header. *)
  let baseline_error, had_docs =
    let of_state =
      State.M.filter_map
        (fun _ (e : State.entry) -> Option.map ignore e.docs)
        old_state
    in
    match config.baseline with
    | Some path when State.M.is_empty of_state && Sys.file_exists path -> (
        match
          Result.bind (Ocamlorg_doc_modules.Reader.map_file path) (fun t ->
              Result.map
                (fun () -> Ocamlorg_doc_modules.Reader.packages t)
                (Ocamlorg_doc_modules.Reader.verify t))
        with
        | Error e ->
            ( Some (Printf.sprintf "cannot read the baseline %s: %s" path e),
              of_state )
        | Ok packages ->
            ( None,
              List.fold_left
                (fun m (name, _) -> State.M.add name () m)
                State.M.empty packages ))
    | _ -> (None, of_state)
  in
  let http = Http.create ~rate:config.rate ~max_time:config.max_time in
  (* Failed packages in a row; once [max_failures_in_a_row], the remaining
     packages are not asked (Skipped) and the run aborts. *)
  let in_a_row = ref 0 in
  let gave_up () = !in_a_row >= config.max_failures_in_a_row in
  let outcomes, bytes =
    if packages = [] || baseline_error <> None then ([], 0)
    else
      Lwt_main.run
        (let open Lwt.Syntax in
         let total = List.length packages in
         let* outcomes, bytes, _ =
           Lwt_list.fold_left_s
             (fun (acc, bytes, i) (name, candidates) ->
               if i mod 500 = 0 then
                 Printf.eprintf "%d/%d packages, %d requests\n%!" i total
                   (Http.requests http);
               let previous = State.M.find_opt name old_state in
               match
                 State.attempts ~day:config.day ~every:config.retry_days name
                   previous candidates
               with
               | _ when gave_up () ->
                   Lwt.return ((name, candidates, Skipped) :: acc, bytes, i + 1)
               | None ->
                   Lwt.return ((name, candidates, Skipped) :: acc, bytes, i + 1)
               | Some attempts ->
                   let* o, b = probe config http name previous attempts in
                   (match o with
                   | Failed _ -> incr in_a_row
                   | _ -> in_a_row := 0);
                   Lwt.return ((name, candidates, o) :: acc, bytes + b, i + 1))
             ([], 0, 0) packages
         in
         Http.close http;
         Lwt.return (List.rev outcomes, bytes))
  in
  let count kind =
    List.length
      (List.filter
         (fun (_, _, o) ->
           match (kind, o) with
           | `Fetched, Fetched _
           | `Unchanged, Unchanged _
           | `Missing, Missing
           | `Skipped, Skipped ->
               true
           | `Failed, Failed _ -> true
           | _ -> false)
         outcomes)
  in
  let errors = count `Failed and skipped = count `Skipped in
  let requests = Http.requests http in
  let record status reason changed_packages last_modified =
    {
      Stats.started;
      finished = int_of_float (Unix.time ());
      status;
      reason;
      requests;
      bytes;
      fetched = count `Fetched;
      unchanged = count `Unchanged;
      missing = count `Missing;
      skipped;
      errors;
      changed_packages;
      last_modified;
    }
  in
  let append_stats r =
    Option.iter
      (fun path ->
        Out_channel.with_open_gen
          [ Open_append; Open_creat; Open_wronly; Open_binary ] 0o644 path
          (fun oc -> output_string oc (Stats.to_line r)))
      stats
  in
  let abort reason offending =
    prerr_endline ("Aborting: " ^ reason ^ "; state and data unchanged.");
    List.iteri
      (fun i (name, _, o) ->
        if i < 20 then
          match o with
          | Failed (v, e) -> Printf.eprintf "%s %s: %s\n" name v e
          | _ -> Printf.eprintf "%s: no docs\n" name)
      (List.filter offending outcomes);
    append_stats (record `Aborted (Some reason) [] []);
    Error reason
  in
  (* Losses: packages that had docs and now have none, or are not listed any
     more (unless the listing is cut short by [limit]). *)
  let by_name =
    List.fold_left
      (fun m (name, _, o) -> State.M.add name o m)
      State.M.empty outcomes
  in
  let lost =
    State.M.fold
      (fun name _ n ->
        match State.M.find_opt name by_name with
        | Some Missing -> n + 1
        | Some _ -> n
        | None -> if config.limit = 0 then n + 1 else n)
      had_docs 0
  in
  let n_had_docs = State.M.cardinal had_docs in
  if packages = [] then
    abort (Printf.sprintf "no package in %s/packages" repo) (fun _ -> false)
  else if Option.is_some baseline_error then
    abort (Option.get baseline_error) (fun _ -> false)
  else if gave_up () then
    abort
      (Printf.sprintf "%d packages failed in a row, after %d requests"
         config.max_failures_in_a_row requests) (function
      | _, _, Failed _ -> true
      | _ -> false)
  else if errors * 100 > requests * config.max_errors then
    abort (Printf.sprintf "%d of %d attempted requests failed" errors requests)
      (function
      | _, _, Failed _ -> true
      | _ -> false)
  else if lost * 100 > n_had_docs * config.max_losses then
    abort
      (Printf.sprintf
         "%d of the %d packages with docs have none any more or are gone" lost
         n_had_docs) (function
      | name, _, Missing -> State.M.mem name had_docs
      | _ -> false)
  else
    let new_state =
      List.fold_left
        (fun s (name, candidates, o) ->
          match next_entry (State.M.find_opt name old_state) candidates o with
          | Some e -> State.M.add name e s
          | None -> s)
        State.empty outcomes
    in
    let changed_packages = changed old_state new_state in
    let last_modified =
      List.filter_map
        (function _, _, Fetched (_, lm) -> lm | _ -> None)
        outcomes
      |> List.sort Int.compare
    in
    let with_docs =
      State.M.fold
        (fun name (e : State.entry) acc ->
          match e.docs with
          | Some d ->
              {
                Ocamlorg_doc_modules.name;
                version = d.version;
                modules = d.modules;
              }
              :: acc
          | None -> acc)
        new_state []
    in
    let report =
      report ~packages:(List.length packages)
        ~with_modules:(List.length with_docs) ~count ~skipped ~errors
        ~changed:(List.length changed_packages)
        ~requests ~bytes
    in
    let data =
      Doc_modules_jsonl.to_string ~generated_at:(iso8601_now ()) with_docs
    in
    let r = record `Scraped None changed_packages last_modified in
    (* Commit: the output, then the state, each replaced by a rename, then the
       stats record. *)
    write_atomic output data;
    let fresh = state_dir ^ ".new" and old = state_dir ^ ".old" in
    remove_tree fresh;
    remove_tree old;
    Sys.mkdir fresh 0o755;
    write_atomic
      (Filename.concat fresh "state.jsonl")
      (State.to_string new_state);
    write_atomic (Filename.concat fresh "report.md") report;
    if Sys.file_exists state_dir then Sys.rename state_dir old;
    Sys.rename fresh state_dir;
    remove_tree old;
    append_stats r;
    Ok report
