(* Data module using binary blob embedding
 *
 * The blob is embedded in the binary via .incbin assembly directive and
 * deserialized lazily on first access using Marshal (PROTOTYPE).
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

(* Lazy deserialization - happens once on first access *)
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

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all

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

    let get_by_slug slug =
      List.find_opt (fun (x : t) -> String.equal slug x.slug) all
  end

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
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
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
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
    let contains s1 s2 =
      try
        let len = String.length s2 in
        for i = 0 to String.length s1 - len do
          if String.sub s1 i len = s2 then raise Exit
        done;
        false
      with Exit -> true
    in
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
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
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

  (* Count non-overlapping occurrences of [sub] in [s] (both lower-cased). *)
  let count_sub ~sub s =
    let ls = String.length s and lsub = String.length sub in
    if lsub = 0 then 0
    else
      let rec loop i acc =
        if i + lsub > ls then acc
        else if String.sub s i lsub = sub then loop (i + lsub) (acc + 1)
        else loop (i + 1) acc
      in
      loop 0 0

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
    in
    match terms with
    | [] -> []
    | terms ->
        (* Lower-cased weighted fields per entry. *)
        let docs =
          List.map
            (fun e ->
              ( e,
                [
                  (String.lowercase_ascii (entry_title e), 3.0);
                  ( String.lowercase_ascii (String.concat " " (entry_keywords e)),
                    2.5 );
                  (String.lowercase_ascii (entry_description e), 1.2);
                  (String.lowercase_ascii (entry_source e), 0.6);
                  ( String.lowercase_ascii (String.concat " " (entry_authors e)),
                    0.6 );
                ] ))
            all
        in
        let n = List.length docs in
        let idf term =
          let df =
            List.fold_left
              (fun acc (_, fields) ->
                if List.exists (fun (f, _) -> count_sub ~sub:term f > 0) fields
                then acc + 1
                else acc)
              0 docs
          in
          Float.log (float_of_int (1 + n) /. float_of_int (1 + df))
        in
        let weighted_terms = List.map (fun t -> (t, idf t)) terms in
        let score fields =
          List.fold_left
            (fun acc (term, idf) ->
              List.fold_left
                (fun a (f, w) ->
                  let c = count_sub ~sub:term f in
                  if c = 0 then a
                  else a +. (Float.log (1. +. float_of_int c) *. w *. idf))
                acc fields)
            0.0 weighted_terms
        in
        docs
        |> List.filter_map (fun (e, fields) ->
               let s = score fields in
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
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tool_page = struct
  include Data_intf.Tool_page

  let all = data.tool_pages
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
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
      Float.log (float_of_int (List.length (Re.split regexp field))) *. weight
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
module V2 = V2
