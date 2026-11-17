(* Data module using binary blob embedding
 *
 * The blob is embedded in the binary via .incbin assembly directive and
 * deserialized with Marshal once, when this module is loaded.
 *)

(* ============================================================
 * Blob Access
 * ============================================================ *)

(* External C functions to access the embedded blob *)
external _get_blob_size : unit -> int = "caml_ocamlorg_data_blob_size"
external get_blob_check : unit -> bool = "caml_ocamlorg_data_blob_check"

external get_blob_raw :
  unit ->
  (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  = "caml_ocamlorg_data_blob"

(* Deserialization, forced below when the module is loaded *)
let all_data : Data_intf.All_data.t Lazy.t =
  lazy
    ((* Verify blob is valid *)
     if not (get_blob_check ()) then
       failwith "Data blob is not properly initialized";

     (* PROTOTYPE: copy the embedded blob into bytes and deserialize with
        Marshal. Type-safe by construction here: the same build's packer wrote
        it with Data_packer.Types.All_data.t, which is structurally identical to
        Data_intf.All_data.t, and data.bin is regenerated on every build. *)
     let ba = get_blob_raw () in
     let len = Bigarray.Array1.dim ba in
     let b = Bytes.create len in
     for i = 0 to len - 1 do
       Bytes.unsafe_set b i (Bigarray.Array1.unsafe_get ba i)
     done;
     (Marshal.from_bytes b 0 : Data_intf.All_data.t))

(* Force deserialization once at module load time *)
let data = Lazy.force all_data

(* ============================================================
 * Individual Module Implementations
 * ============================================================ *)

module Academic_institution = struct
  include Data_intf.Academic_institution

  let all = data.academic_institutions

  let featured =
    all
    |> List.filter (fun institution ->
        match institution.featured with Some true -> true | _ -> false)

  let full_course_name course =
    match course.acronym with
    | None -> course.name
    | Some acronym -> acronym ^ " - " ^ course.name
end

module Academic_testimonial = struct
  include Data_intf.Academic_testimonial

  let all = data.academic_testimonials
end

module Book = struct
  include Data_intf.Book

  let all = data.books
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Backstage = struct
  include Data_intf.Backstage

  let all = data.backstage

  let get_by_slug slug =
    List.find_opt
      (fun x ->
        match x with
        | Release x -> String.equal slug x.slug
        | Post x -> String.equal slug x.slug)
      all
end

module Changelog = struct
  include Data_intf.Changelog

  let all = data.changelog

  let get_by_slug slug =
    List.find_opt
      (fun x ->
        match x with
        | Release x -> String.equal slug x.slug
        | Post x -> String.equal slug x.slug)
      all
end

module Code_example = struct
  type t = Data_intf.Code_examples.t = { title : string; body : string }

  let all = data.code_examples
  let get title = List.find (fun x -> String.equal x.title title) all
end

module Cookbook = struct
  include Data_intf.Cookbook

  let all = data.cookbook_recipes
  let tasks = data.cookbook_tasks
  let top_categories = data.cookbook_top_categories

  let rec get_task_path_titles categories = function
    | [] -> []
    | slug :: path ->
        let cat =
          List.find (fun (cat : category) -> cat.slug = slug) categories
        in
        cat.title :: get_task_path_titles cat.subcategories path

  let get_tasks_by_category ~category_slug =
    tasks
    |> List.filter (fun (x : task) ->
        List.(x.category_path |> rev |> hd) = category_slug)

  let get_by_task ~task_slug =
    all |> List.filter (fun (x : t) -> String.equal task_slug x.task.slug)

  let get_by_slug ~task_slug slug =
    List.find_opt
      (fun x -> String.equal slug x.slug && String.equal task_slug x.task.slug)
      all

  let main_package_of_recipe (recipe : t) =
    recipe.packages |> Fun.flip List.nth_opt 0
    |> Option.map (fun (p : package) -> p.name)
    |> Option.value ~default:"the Standard Library"

  let full_title_of_recipe (recipe : t) =
    recipe.task.title ^ " using " ^ main_package_of_recipe recipe
end

module Event = struct
  include Data_intf.Event

  let all = data.events

  module RecurringEvent = struct
    type t = recurring_event

    let all = data.recurring_events
  end
end

module Exercise = struct
  include Data_intf.Exercise

  let all = data.exercises

  let filter_tag ?tag =
    let f x =
      Option.fold ~none:(x.tags = []) ~some:(Fun.flip List.mem x.tags) tag
    in
    List.filter f

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Governance = struct
  include Data_intf.Governance

  let teams = data.governance_teams
  let working_groups = data.governance_working_groups

  let get_by_id id =
    List.find_opt (fun x -> String.equal id x.id) (teams @ working_groups)
end

module Industrial_user = struct
  include Data_intf.Industrial_user

  let all = data.industrial_users
  let featured = all |> List.filter (fun user -> user.featured)
end

module Is_ocaml_yet = struct
  include Data_intf.Is_ocaml_yet

  let all = data.is_ocaml_yet
end

module Job = struct
  include Data_intf.Job

  let all = data.jobs
end

module Testimonial = struct
  include Data_intf.Testimonial

  let all = data.testimonials
end

module News = struct
  include Data_intf.News

  let all = data.news
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Opam_user = struct
  include Data_intf.Opam_user

  let all = data.opam_users

  let make ~name ?email ?github_username ?avatar () =
    { name; email; github_username; avatar }

  (* Users with their case-folded names, computed once: package search calls
     [find_by_name] for every author of every package. *)
  let folded_names =
    lazy (List.map (fun u -> (Ocamlorg.Import.String.fold u.name, u)) all)

  let find_by_name s =
    let pattern = Ocamlorg.Import.String.fold s in
    let contains = Ocamlorg.Import.String.contains_s in
    Lazy.force folded_names
    |> List.find_map (fun (name, user) ->
        if contains pattern name then Some user else None)
end

module Outreachy = struct
  include Data_intf.Outreachy

  let all = data.outreachy
end

module Page = struct
  include Data_intf.Page

  let all = data.pages

  let get path =
    let slug = Filename.basename path in
    List.find (fun x -> String.equal slug x.slug) all
end

module Paper = struct
  include Data_intf.Paper

  let all = data.papers
  let featured = all |> List.filter (fun paper -> paper.featured)
end

module Planet = struct
  include Data_intf.Planet

  let all = data.planet

  (* Field accessors over the [BlogPost | Video] variant, so the handler and
     templates don't repeat the match. Videos have no keywords. *)
  let entry_title = function BlogPost p -> p.title | Video v -> v.title

  let entry_description = function
    | BlogPost p -> Option.value ~default:"" p.description
    | Video v -> v.description

  let entry_date = function BlogPost p -> p.date | Video v -> v.published

  let entry_source = function
    | BlogPost p -> p.source.name
    | Video v -> v.source_title

  let entry_authors = function
    | BlogPost p -> p.authors
    | Video v -> [ v.author_name ]

  let entry_keywords = function BlogPost p -> p.keywords | Video _ -> []

  let entry_year e =
    let d = entry_date e in
    if String.length d >= 4 then String.sub d 0 4 else d

  (* Count non-overlapping occurrences of [sub] (lower-case) in [s], ignoring
     ASCII case in [s]. Allocates nothing: search runs this for every term,
     field and entry, so neither [s] is lower-cased nor substrings are cut. *)
  let count_sub ~sub s =
    let ls = String.length s and lsub = String.length sub in
    let rec matches i j =
      j = lsub || (Char.lowercase_ascii s.[i + j] = sub.[j] && matches i (j + 1))
    in
    let rec loop i acc =
      if i + lsub > ls then acc
      else if matches i 0 then loop (i + lsub) (acc + 1)
      else loop (i + 1) acc
    in
    if lsub = 0 then 0 else loop 0 0

  (* The weighted fields of an entry, as indexes into [field_weights]: title >
     keywords > description > source = authors. *)
  let field_weights = [| 3.0; 2.5; 1.2; 0.6; 0.6 |]

  (* Matches of [term] in field [k] of [e]. A term never contains a space, so
     summing over the keywords (or authors) one by one counts the same as
     searching them joined with spaces. *)
  let field_count term e k =
    let count = count_sub ~sub:term in
    let sum l = List.fold_left (fun acc s -> acc + count s) 0 l in
    match k with
    | 0 -> count (entry_title e)
    | 1 -> sum (entry_keywords e)
    | 2 -> count (entry_description e)
    | 3 -> count (entry_source e)
    | _ -> sum (entry_authors e)

  let max_query_terms = 16

  (* Relevance ranking. Each query term is scored INDEPENDENTLY and weighted by
     its corpus IDF, so common words ("of", or "code" matching inside
     "bytecode") get ~zero weight and a rare distinctive term dominates a
     multi-word query. Per field, a term adds [log (1 + #matches) * field_weight
     * idf]; field weights encode title > keywords > description >
     author/source. Only call with a non-empty query. *)
  let search q =
    let terms =
      (* Split on runs of anything outside [a-z0-9_-]; the length filter also
         discards the empty fragments left by adjacent separators. *)
      String.lowercase_ascii q
      |> String.map (fun c ->
          if
            (c >= 'a' && c <= 'z')
            || (c >= '0' && c <= '9')
            || c = '_' || c = '-'
          then c
          else ' ')
      |> String.split_on_char ' '
      |> List.filter (fun t -> String.length t >= 2)
      (* Searching keeps [terms * fields] counts per entry, and the time grows
         with the number of terms too: bound both. *)
      |> List.filteri (fun i _ -> i < max_query_terms)
    in
    match terms with
    | [] -> []
    | terms ->
        let terms = Array.of_list terms in
        let nt = Array.length terms and nf = Array.length field_weights in
        (* Scan once: match counts per entry, indexed by [term * nf + field],
           shared by the document frequencies and the scores. *)
        let docs =
          List.map
            (fun e ->
              ( e,
                Array.init (nt * nf) (fun i ->
                    field_count terms.(i / nf) e (i mod nf)) ))
            all
        in
        let n = List.length docs in
        let df = Array.make nt 0 in
        List.iter
          (fun (_, counts) ->
            for t = 0 to nt - 1 do
              let rec matched f =
                f < nf && (counts.((t * nf) + f) > 0 || matched (f + 1))
              in
              if matched 0 then df.(t) <- df.(t) + 1
            done)
          docs;
        let idf =
          Array.map
            (fun df ->
              Float.log (float_of_int (1 + n) /. float_of_int (1 + df)))
            df
        in
        (* Same summation order as before (terms, then fields), so scores and
           the resulting order are unchanged. *)
        let score counts =
          let acc = ref 0.0 in
          for t = 0 to nt - 1 do
            for f = 0 to nf - 1 do
              let c = counts.((t * nf) + f) in
              if c > 0 then
                acc :=
                  !acc
                  +. Float.log (1. +. float_of_int c)
                     *. field_weights.(f) *. idf.(t)
            done
          done;
          !acc
        in
        docs
        |> List.filter_map (fun (e, counts) ->
            let s = score counts in
            if s > 0.0 then Some (e, s) else None)
        |> List.stable_sort (fun (_, s1) (_, s2) -> Float.compare s2 s1)
        |> List.map fst
end

module Release = struct
  include Data_intf.Release

  let all = data.releases

  let latest =
    match data.release_latest with
    | Some r -> r
    | None -> failwith "No latest release marked in data"

  let lts =
    match data.release_lts with
    | Some r -> r
    | None -> failwith "No LTS release marked in data"

  let get_by_version version =
    if version = "lts" then Some lts
    else if version = "latest" then Some latest
    else
      match
        List.filter (fun x -> String.starts_with ~prefix:version x.version) all
      with
      | [] -> None
      | [ release ] -> Some release
      | u :: v ->
          let version r =
            r.version |> String.split_on_char '.' |> List.map int_of_string
          in
          Some
            (List.fold_left
               (fun r1 r2 -> if version r1 > version r2 then r1 else r2)
               u v)
end

module Resource = struct
  include Data_intf.Resource

  let all = data.resources
  let featured = data.featured_resources
end

module Success_story = struct
  include Data_intf.Success_story

  let all = data.success_stories
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tool = struct
  include Data_intf.Tool

  let all = data.tools
end

module Tool_page = struct
  include Data_intf.Tool_page

  let all = data.tool_pages
end

module Tutorial = struct
  include Data_intf.Tutorial

  let all = data.tutorials
  let all_search_documents = data.tutorial_search_documents
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all

  let search_terms q =
    String.split_on_char ' ' q
    |> List.concat_map (String.split_on_char '\t')
    |> List.filter (fun s -> s <> "")

  let fold = Ocamlorg.Import.String.fold

  (* Each document with its title, section title and content case-folded,
     computed once rather than on every query. *)
  let folded_search_documents =
    lazy
      (List.map
         (fun (doc : search_document) ->
           ( doc,
             fold doc.title,
             doc.section
             |> Option.map (fun (s : search_document_section) -> fold s.title)
             |> Option.value ~default:"",
             fold doc.content ))
         all_search_documents)

  let search_documents_matching terms =
    let regexp = Re.(compile (alt (List.map (fun t -> str (fold t)) terms))) in
    let search_in_field field weight =
      Float.log1p (float_of_int (List.length (Re.all regexp field))) *. weight
    in
    List.filter_map
      (fun (doc, title, section, content) ->
        let score =
          search_in_field title 1.2
          +. search_in_field section 2.0
          +. search_in_field content 1.0
        in
        if score > 0.0 then Some (doc, score) else None)
      (Lazy.force folded_search_documents)
    |> List.sort (fun (_, score1) (_, score2) -> Float.compare score2 score1)
    |> List.map fst

  let search_documents q =
    match search_terms q with
    | [] -> all_search_documents
    | terms -> search_documents_matching terms
end

module Video = struct
  include Data_intf.Video

  let all = data.videos
end

module Conference = struct
  include Data_intf.Conference

  let all = data.conferences
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Attribution = struct
  include Data_intf.Attribution

  let all = data.attribution
  let get_by_path path = List.find_opt (fun x -> String.equal path x.path) all

  (* Records are keyed by repo-root path ("data/..."), whereas [Tutorial.t] and
     [Tool_page.t] carry a [fpath] relative to [data/]. Bridge the two. *)
  let get_by_fpath fpath = get_by_path ("data/" ^ fpath)
end

(* V2 assets - comes from separately generated v2.ml *)
module Opam_health = struct
  include Data_intf.Opam_health

  let run = data.opam_health.run
  let releases = data.opam_health.releases
  let base_url = "https://check.ci.ocaml.org"

  (* Releases grouped by package name, built on first lookup. *)
  let by_name =
    lazy
      (let tbl = Hashtbl.create 8192 in
       List.iter
         (fun r ->
           let prev = Option.value ~default:[] (Hashtbl.find_opt tbl r.name) in
           Hashtbl.replace tbl r.name (r :: prev))
         (List.rev releases);
       tbl)

  let versions name =
    Option.value ~default:[] (Hashtbl.find_opt (Lazy.force by_name) name)

  let find ~name ~version =
    List.find_opt (fun r -> String.equal r.version version) (versions name)

  let builds r = List.combine run.compilers r.statuses

  let date =
    match Ptime.of_float_s run.timestamp with
    | Some t ->
        let y, m, d = Ptime.to_date t in
        Printf.sprintf "%04d-%02d-%02d" y m d
    | None -> ""

  let age_in_days ~now = (now -. run.timestamp) /. 86400.

  let short_commit =
    if String.length run.commit >= 7 then String.sub run.commit 0 7
    else run.commit

  let commit_url =
    "https://github.com/ocaml/opam-repository/commit/" ^ run.commit

  let run_url = base_url ^ "/run/" ^ run.id

  let package_url name =
    base_url ^ "/?packages=" ^ name ^ "&show-latest-only=false"

  let log_url ~compiler ~status r =
    String.concat "/"
      [
        base_url;
        "log";
        run.id;
        compiler;
        status_to_string status;
        r.name ^ "." ^ r.version;
      ]

  (* check.ci's own legend. *)
  let status_description = function
    | Good -> "Package successfully built"
    | Partial -> "One of the dependencies failed to build"
    | Bad -> "Package failed to build"
    | Not_available -> "Package is not available in this environment"
    | Internal_failure -> "Internal failure"

  type summary =
    | All_good
    | Some_failures
    | Not_on_latest
    | All_failing
    | Not_available_anywhere

  (* [Not_available] is not a failure: the package simply does not install with
     that compiler (e.g. an upper bound on OCaml), so it is ignored unless no
     compiler is available at all. Still, a package that builds everywhere it
     installs but not on the newest compiler tested is lagging behind, so it is
     not [All_good]. [statuses] is aligned with [run.compilers], ascending. *)
  let summary statuses =
    let latest_good =
      match List.rev statuses with Good :: _ -> true | _ -> false
    in
    match List.filter (fun s -> s <> Not_available) statuses with
    | [] -> Not_available_anywhere
    | l when List.for_all (fun s -> s = Good) l ->
        if latest_good then All_good else Not_on_latest
    | l when List.for_all (fun s -> s <> Good) l -> All_failing
    | _ -> Some_failures

  let summary_to_string = function
    | All_good -> "all_good"
    | Some_failures -> "some_failures"
    | Not_on_latest -> "not_on_latest"
    | All_failing -> "all_failing"
    | Not_available_anywhere -> "not_available"
end

module V2 = V2
