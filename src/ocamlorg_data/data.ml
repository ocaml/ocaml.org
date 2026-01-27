(* Data module using binary blob embedding
 *
 * The blob is embedded in the binary via .incbin assembly directive and
 * deserialized lazily on first access using bin_prot.
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
let all_data : Data_packer.Types.All_data.t Lazy.t =
  lazy
    ((* Verify blob is valid *)
     if not (get_blob_check ()) then
       failwith "Data blob is not properly initialized";

     (* Get the blob as a bigstring for bin_prot *)
     let buf : Bigstringaf.t = get_blob_raw () in
     let pos_ref = ref 0 in

     (* Deserialize using bin_prot *)
     Data_packer.Types.All_data.bin_read_t buf ~pos_ref)

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

  let find_by_name s =
    let pattern = String.lowercase_ascii s in
    let contains s1 s2 =
      try
        let len = String.length s2 in
        for i = 0 to String.length s1 - len do
          if String.sub s1 i len = s2 then raise Exit
        done;
        false
      with Exit -> true
    in
    all
    |> List.find_opt (fun { name; _ } ->
           contains pattern (String.lowercase_ascii name))
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

  let search_documents q =
    let score_document (doc : search_document) =
      let regexp =
        Str.global_replace (Str.regexp "[ \t]+") "\\|" (String.trim q)
        |> Str.regexp_case_fold
      in
      let search_in_field field weight =
        Float.log (float_of_int (List.length (Str.split regexp field)))
        *. weight
      in
      search_in_field doc.title 1.2
      +. search_in_field
           (doc.section
           |> Option.map (fun (s : search_document_section) -> s.title)
           |> Option.value ~default:"")
           2.0
      +. search_in_field doc.content 1.0
    in
    List.filter_map
      (fun doc ->
        let score = score_document doc in
        if score > 0.0 then Some (doc, score) else None)
      all_search_documents
    |> List.sort (fun (_, score1) (_, score2) -> Float.compare score2 score1)
    |> List.map fst
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

(* V2 assets - comes from separately generated v2.ml *)
module V2 = V2
