open Import

let not_found _req = Dream.html ~code:404 (Ocamlorg_frontend.not_found ())
let index _req = Dream.html (Ocamlorg_frontend.home ())

let learn _req =
  let papers =
    Ood.Paper.all |> List.filter (fun (paper : Ood.Paper.t) -> paper.featured)
  in
  let books =
    Ood.Book.all |> List.filter (fun (book : Ood.Book.t) -> book.featured)
  in
  let release = List.hd Ood.Release.all in
  Dream.html (Ocamlorg_frontend.learn ~papers ~books ~release)

let community _req =
  let workshops = Ood.Workshop.all |> List.take 2 in
  let news = Ood.News.all |> List.take 3 in
  Dream.html (Ocamlorg_frontend.community ~workshops ~news)

let success_stories _req =
  let stories = Ood.Success_story.all () in
  Dream.html (Ocamlorg_frontend.success_stories stories)

let success_story req =
  let slug = Dream.param req "id" in
  let story = Ood.Success_story.get_by_slug slug in
  match story with
  | Some story -> Dream.html (Ocamlorg_frontend.success_story story)
  | None -> not_found req

let industrial_users _req =
  let users =
    Ood.Industrial_user.all ()
    |> List.filter (fun (item : Ood.Industrial_user.t) -> item.featured)
  in
  Dream.html (Ocamlorg_frontend.industrial_users users)

let academic_users req =
  let search_user pattern t =
    let open Ood.Academic_institution in
    let pattern = String.lowercase_ascii pattern in
    let name_is_s { name; _ } = String.lowercase_ascii name = pattern in
    let name_contains_s { name; _ } =
      String.contains_s (String.lowercase_ascii name) pattern
    in
    let score user =
      if name_is_s user then -1
      else if name_contains_s user then 0
      else failwith "impossible user score"
    in
    t
    |> List.filter (fun p -> name_contains_s p)
    |> List.sort (fun user_1 user_2 -> compare (score user_1) (score user_2))
  in
  let users =
    match Dream.query "q" req with
    | None -> Ood.Academic_institution.all ()
    | Some search -> search_user search (Ood.Academic_institution.all ())
  in
  Dream.html (Ocamlorg_frontend.academic_users users)

let about _req = Dream.html (Ocamlorg_frontend.about ())

let books _req =
  let books =
    Ood.Book.all
    |> List.sort (fun b1 b2 ->
           (* Sort the books by reversed publication date. *)
           String.compare b2.Ood.Book.published b1.published)
  in
  Dream.html (Ocamlorg_frontend.books books)

let releases req =
  let search_release pattern t =
    let open Ood.Release in
    let pattern = String.lowercase_ascii pattern in
    let version_is_s { version; _ } =
      String.lowercase_ascii version = pattern
    in
    let version_contains_s { version; _ } =
      String.contains_s (String.lowercase_ascii version) pattern
    in
    let body_contains_s { body_md; _ } =
      String.contains_s (String.lowercase_ascii body_md) pattern
    in
    let score release =
      if version_is_s release then -1
      else if version_contains_s release then 0
      else if body_contains_s release then 2
      else failwith "impossible release score"
    in
    t
    |> List.filter (fun p -> version_contains_s p)
    |> List.sort (fun release_1 release_2 ->
           compare (score release_1) (score release_2))
  in
  let search = Dream.query "q" req in
  let releases =
    match search with
    | None -> Ood.Release.all
    | Some search -> search_release search Ood.Release.all
  in
  Dream.html (Ocamlorg_frontend.releases releases)

let release req =
  let version = Dream.param req "id" in
  match Ood.Release.get_by_version version with
  | Some release -> Dream.html (Ocamlorg_frontend.release release)
  | None -> not_found req

let events _req =
  let workshops = Ood.Workshop.all in
  let meetups = Ood.Meetup.all in
  Dream.html (Ocamlorg_frontend.events ~workshops ~meetups)

let workshop req =
  let watch_ocamlorg_embed =
    let presentations =
      List.concat_map
        (fun (w : Ood.Workshop.t) -> w.presentations)
        Ood.Workshop.all
    in
    let rec get_last = function
      | [] -> ""
      | [ x ] -> x
      | _ :: xs -> get_last xs
    in
    let watch =
      List.map
        (fun (w : Ood.Watch.t) ->
          String.split_on_char '/' w.embed_path |> get_last |> fun v -> (v, w))
        Ood.Watch.all
    in
    let tbl = Hashtbl.create 100 in
    let add_video (p : Ood.Workshop.presentation) =
      match p.video with
      | Some video ->
          let uuid = String.split_on_char '/' video |> get_last in
          let find (v, w) = if String.equal uuid v then Some w else None in
          let w = List.find_map find watch in
          Option.iter (fun w -> Hashtbl.add tbl p.title w) w
      | None -> ()
    in
    List.iter add_video presentations;
    tbl
  in
  let slug = Dream.param req "id" in
  match
    List.find_opt (fun x -> x.Ood.Workshop.slug = slug) Ood.Workshop.all
  with
  | Some workshop ->
      Dream.html
        (Ocamlorg_frontend.workshop ~videos:watch_ocamlorg_embed workshop)
  | None -> not_found req

let paginate ~req ~n items =
  let items_per_page = n in
  let page =
    Dream.query "p" req |> Option.map int_of_string |> Option.value ~default:1
  in
  let number_of_pages =
    int_of_float
      (Float.ceil
         (float_of_int (List.length items) /. float_of_int items_per_page))
  in
  let current_items =
    let skip = items_per_page * (page - 1) in
    items |> List.skip skip |> List.take items_per_page
  in
  (page, number_of_pages, current_items)

let blog req =
  let page, number_of_pages, current_items =
    paginate ~req ~n:10
      (List.filter (fun (x : Ood.Rss.t) -> not x.featured) Ood.Rss.all)
  in
  let featured = Ood.Rss.featured |> List.take 3 in
  let news = Ood.News.all |> List.take 20 in
  Dream.html
    (Ocamlorg_frontend.blog ~featured ~rss:current_items ~rss_page:page
       ~rss_pages_number:number_of_pages ~news)

let news req =
  let page, number_of_pages, current_items = paginate ~req ~n:10 Ood.News.all in
  Dream.html
    (Ocamlorg_frontend.news ~page ~pages_number:number_of_pages current_items)

let news_post req =
  let slug = Dream.param req "id" in
  let news_post = Ood.News.get_by_slug slug in
  match news_post with
  | Some news_post -> Dream.html (Ocamlorg_frontend.news_post news_post)
  | None -> not_found req

let opportunities req =
  let search_job pattern t =
    let open Ood.Job in
    let pattern = String.lowercase_ascii pattern in
    let title_is_s { title; _ } = String.lowercase_ascii title = pattern in
    let title_contains_s { title; _ } =
      String.contains_s (String.lowercase_ascii title) pattern
    in
    let score job =
      if title_is_s job then -1
      else if title_contains_s job then 0
      else failwith "impossible job score"
    in
    t
    |> List.filter (fun p -> title_contains_s p)
    |> List.sort (fun job_1 job_2 -> compare (score job_1) (score job_2))
  in
  let search = Dream.query "q" req in
  let jobs =
    match search with
    | None -> Ood.Job.all_not_fullfilled
    | Some search -> search_job search Ood.Job.all_not_fullfilled
  in
  let country = Dream.query "c" req in
  let jobs =
    match country with
    | None | Some "All" -> jobs
    | Some country ->
        List.filter (fun job -> job.Ood.Job.country = country) jobs
  in
  Dream.html (Ocamlorg_frontend.opportunities ?search ?country jobs)

let opportunity req =
  let id = Dream.param req "id" in
  match Option.bind (int_of_string_opt id) Ood.Job.get_by_id with
  | Some job -> Dream.html (Ocamlorg_frontend.opportunity job)
  | None -> not_found req

let carbon_footprint _req = Dream.html (Ocamlorg_frontend.carbon_footprint ())

let playground _req = Dream.html (Ocamlorg_frontend.playground ())

let papers req =
  let search_paper pattern t =
    let open Ood.Paper in
    let pattern = String.lowercase_ascii pattern in
    let title_is_s { title; _ } = String.lowercase_ascii title = pattern in
    let title_contains_s { title; _ } =
      String.contains_s (String.lowercase_ascii title) pattern
    in
    let abstract_contains_s { abstract; _ } =
      String.contains_s (String.lowercase_ascii abstract) pattern
    in
    let has_tag_s { tags; _ } =
      List.exists
        (fun tag -> String.contains_s (String.lowercase_ascii tag) pattern)
        tags
    in
    let score paper =
      if title_is_s paper then -1
      else if title_contains_s paper then 0
      else if has_tag_s paper then 1
      else if abstract_contains_s paper then 2
      else failwith "impossible paper score"
    in
    t
    |> List.filter (fun p -> title_contains_s p)
    |> List.sort (fun paper_1 paper_2 ->
           compare (score paper_1) (score paper_2))
  in
  let search = Dream.query "q" req in
  let papers =
    match search with
    | None -> Ood.Paper.all
    | Some search -> search_paper search Ood.Paper.all
  in
  let recommended_papers =
    Ood.Paper.all |> List.filter (fun (paper : Ood.Paper.t) -> paper.featured)
  in
  Dream.html (Ocamlorg_frontend.papers ?search ~recommended_papers papers)

let tutorial req =
  let slugify value =
    value
    |> Str.global_replace (Str.regexp " ") "-"
    |> String.lowercase_ascii
    |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""
  in
  let slug = Dream.param req "id" in
  match
    List.find_opt
      (fun x -> slugify x.Ood.Tutorial.title = slug)
      Ood.Tutorial.all
  with
  | Some tutorial -> Ocamlorg_frontend.tutorial tutorial |> Dream.html
  | None -> not_found req

let best_practices _req =
  Dream.html (Ocamlorg_frontend.best_practices Ood.Workflow.all)

let problems _req = Dream.html (Ocamlorg_frontend.problems Ood.Problem.all)

type package_kind = Package | Universe

let package_of_info ~name ~version ~versions info =
  Ocamlorg_frontend.
    {
      name = Ocamlorg_package.Name.to_string name;
      version = Ocamlorg_package.Version.to_string version;
      versions;
      description = info.Ocamlorg_package.Info.synopsis;
      tags = info.tags;
      authors = info.authors;
      maintainers = info.maintainers;
      license = info.license;
    }

(** Query all the versions of a package. *)
let package_versions state name =
  Ocamlorg_package.get_package_versions state name
  |> Option.value ~default:[]
  |> List.sort Ocamlorg_package.Version.compare
  |> List.map Ocamlorg_package.Version.to_string
  |> List.rev

let package_meta state (package : Ocamlorg_package.t) :
    Ocamlorg_frontend.package =
  let name = Ocamlorg_package.name package
  and version = Ocamlorg_package.version package
  and info = Ocamlorg_package.info package in
  let versions = package_versions state name in
  package_of_info ~name ~version ~versions info

let packages state _req =
  let package { Ocamlorg_package.Packages_stats.name; version; info } =
    let versions = package_versions state name in
    package_of_info ~name ~version ~versions info
  in
  let package_pair (pkg, snd) = (package pkg, snd) in
  let stats =
    match Ocamlorg_package.packages_stats state with
    | Some
        ({
           Ocamlorg_package.Packages_stats.nb_packages;
           nb_update_week;
           nb_packages_month;
           _;
         } as t) ->
        Some
          {
            Ocamlorg_frontend.nb_packages;
            nb_update_week;
            nb_packages_month;
            newest_packages = List.map package_pair t.newest_packages;
            recently_updated = List.map package t.recently_updated;
            most_revdeps = List.map package_pair t.most_revdeps;
          }
    | None -> None
  and featured_packages =
    (* TODO: Should be cached ? *)
    match Ocamlorg_package.featured_packages state with
    | Some pkgs -> List.map (package_meta state) pkgs
    | None -> []
  in
  Dream.html (Ocamlorg_frontend.packages stats featured_packages)

let packages_search t req =
  match Dream.query "q" req with
  | Some search ->
      let packages = Ocamlorg_package.search_package t search in
      let total = List.length packages in
      let results = List.map (package_meta t) packages in
      let search = Dream.from_percent_encoded search in
      Dream.html (Ocamlorg_frontend.packages_search ~total ~search results)
  | None -> Dream.redirect req "/packages"

let package t req =
  let package = Dream.param req "name" in
  let find_default_version name =
    Ocamlorg_package.get_package_latest t name
    |> Option.map (fun pkg -> Ocamlorg_package.version pkg)
  in
  let name = Ocamlorg_package.Name.of_string package in
  let version = find_default_version name in
  match version with
  | Some version ->
      let target =
        "/p/" ^ package ^ "/" ^ Ocamlorg_package.Version.to_string version
      in
      Dream.redirect req target
  | None -> not_found req

let package_versioned t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version =
    Ocamlorg_package.Version.of_string @@ Dream.param req "version"
  in
  let package = Ocamlorg_package.get_package t name version in
  match package with
  | None -> not_found req
  | Some package ->
      let open Lwt.Syntax in
      let kind =
        match kind with
        | Package -> `Package
        | Universe -> `Universe (Dream.param req "hash")
      in
      let description =
        (Ocamlorg_package.info package).Ocamlorg_package.Info.description
      in
      let* readme =
        let+ readme_opt = Ocamlorg_package.readme_file ~kind package in
        Option.value readme_opt
          ~default:(description |> Omd.of_string |> Omd.to_html)
      in
      let _license = Ocamlorg_package.license_file ~kind package in
      let package_meta = package_meta t package in
      let package_info = Ocamlorg_package.info package in
      let rev_dependencies =
        package_info.Ocamlorg_package.Info.rev_deps
        |> List.map (fun (name, x, version) ->
               ( Ocamlorg_package.Name.to_string name,
                 x,
                 Ocamlorg_package.Version.to_string version ))
      in
      let dependencies =
        package_info.Ocamlorg_package.Info.dependencies
        |> List.map (fun (name, x) -> (Ocamlorg_package.Name.to_string name, x))
      in
      let homepages = package_info.Ocamlorg_package.Info.homepage in
      let source =
        Option.map
          (fun url ->
            (url.Ocamlorg_package.Info.uri, url.Ocamlorg_package.Info.checksum))
          package_info.Ocamlorg_package.Info.url
      in
      let* documentation_status =
        Ocamlorg_package.documentation_status ~kind package
      in
      let* toplevel_status = Ocamlorg_package.toplevel_status ~kind package in
      Dream.html
        (Ocamlorg_frontend.package_overview ~documentation_status
           ~toplevel_status ~readme ~dependencies ~rev_dependencies ~homepages
           ~source package_meta)

let package_doc t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version =
    Ocamlorg_package.Version.of_string @@ Dream.param req "version"
  in
  let package = Ocamlorg_package.get_package t name version in
  match package with
  | None -> not_found req
  | Some package -> (
      let open Lwt.Syntax in
      let kind =
        match kind with
        | Package -> `Package
        | Universe -> `Universe (Dream.param req "hash")
      in
      let path = (Dream.path [@ocaml.warning "-3"]) req |> String.concat "/" in
      let root =
        let make =
          match kind with
          | `Package -> Fmt.str "/p/%s/%s/doc/"
          | `Universe u -> Fmt.str "/u/%s/%s/%s/doc/" u
        in
        make
          (Ocamlorg_package.Name.to_string name)
          (Ocamlorg_package.Version.to_string version)
      in
      let* docs = Ocamlorg_package.documentation_page ~kind package path in
      match docs with
      | None -> not_found req
      | Some doc ->
          let _description =
            (Ocamlorg_package.info package).Ocamlorg_package.Info.description
          in
          let _versions =
            Ocamlorg_package.get_package_versions t name
            |> Option.value ~default:[]
          in
          let canonical_module =
            doc.module_path
            |> List.map (function
                 | Ocamlorg_package.Documentation.Module s -> s
                 | Ocamlorg_package.Documentation.ModuleType s -> s
                 | Ocamlorg_package.Documentation.FunctorArgument (_, s) -> s)
            |> String.concat "."
          in
          let title =
            match path with
            | "index.html" ->
                Printf.sprintf "Documentation · %s %s · OCaml Packages"
                  (Ocamlorg_package.Name.to_string name)
                  (Ocamlorg_package.Version.to_string version)
            | _ ->
                Printf.sprintf "%s · %s %s · OCaml Packages" canonical_module
                  (Ocamlorg_package.Name.to_string name)
                  (Ocamlorg_package.Version.to_string version)
          in
          let toc_of_toc (xs : Ocamlorg_package.Documentation.toc list) :
              Ocamlorg_frontend.Toc.t =
            let rec aux acc = function
              | [] -> List.rev acc
              | Ocamlorg_package.Documentation.{ title; href; children } :: rest
                ->
                  Ocamlorg_frontend.Toc.
                    { title; href; children = aux [] children }
                  :: aux acc rest
            in
            aux [] xs
          in
          let rec toc_of_module ~root
              (module' : Ocamlorg_package.Module_map.Module.t) :
              Ocamlorg_frontend.Navmap.toc =
            let open Ocamlorg_package in
            let module SM = Module_map.String_map in
            let title = Module_map.Module.name module' in
            let kind = Module_map.Module.kind module' in
            let href = Some (root ^ Module_map.Module.path module') in
            let children =
              module' |> Module_map.Module.submodules |> SM.bindings
              |> List.map (fun (_, module') -> toc_of_module ~root module')
            in
            let kind =
              match kind with
              | Module_map.Module -> Ocamlorg_frontend.Navmap.Module
              | Module_map.Page -> Ocamlorg_frontend.Navmap.Page
              | Module_map.Leaf_page -> Ocamlorg_frontend.Navmap.Leaf_page
              | Module_map.Module_type -> Ocamlorg_frontend.Navmap.Module_type
              | Module_map.Argument -> Ocamlorg_frontend.Navmap.Argument
              | Module_map.Class -> Ocamlorg_frontend.Navmap.Class
              | Module_map.Class_type -> Ocamlorg_frontend.Navmap.Class_type
              | Module_map.File -> Ocamlorg_frontend.Navmap.File
            in
            Ocamlorg_frontend.Navmap.{ title; href; kind; children }
          in
          let toc_of_map ~root (map : Ocamlorg_package.Module_map.t) :
              Ocamlorg_frontend.Navmap.t =
            let open Ocamlorg_package in
            let module SM = Module_map.String_map in
            let libraries = map.libraries in
            SM.bindings libraries
            |> List.map (fun (_, library) ->
                   let title = library.Module_map.name in
                   let href = None in
                   let children =
                     SM.bindings library.modules
                     |> List.map (fun (_, module') ->
                            toc_of_module ~root module')
                   in
                   Ocamlorg_frontend.Navmap.
                     { title; href; kind = Page; children })
          in
          let path =
            doc.module_path
            |> List.map (function
                 | Ocamlorg_package.Documentation.Module s -> s
                 | Ocamlorg_package.Documentation.ModuleType s -> s
                 | Ocamlorg_package.Documentation.FunctorArgument (_, s) -> s)
          in
          let toc = toc_of_toc doc.toc in
          let* map = Ocamlorg_package.module_map ~kind package in
          let maptoc = toc_of_map ~root map in
          let* documentation_status =
            Ocamlorg_package.documentation_status ~kind package
          in
          let* toplevel_status =
            Ocamlorg_package.toplevel_status ~kind package
          in
          let package_meta = package_meta t package in
          Dream.html
            (Ocamlorg_frontend.package_documentation ~documentation_status
               ~toplevel_status ~title ~path ~toc ~maptoc ~content:doc.content
               package_meta))

let package_toplevel t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version =
    Ocamlorg_package.Version.of_string @@ Dream.param req "version"
  in
  let package = Ocamlorg_package.get_package t name version in
  match package with
  | None -> not_found req
  | Some package -> (
      let toplevel = Ocamlorg_package.toplevel package in
      match toplevel with
      | None -> not_found req
      | Some toplevel_url ->
          let open Lwt.Syntax in
          let kind =
            match kind with
            | Package -> `Package
            | Universe -> `Universe (Dream.param req "hash")
          in
          let* documentation_status =
            Ocamlorg_package.documentation_status ~kind package
          in
          let* toplevel_status =
            Ocamlorg_package.toplevel_status ~kind package
          in
          let package_meta = package_meta t package in
          Dream.html
            (Ocamlorg_frontend.package_toplevel ~documentation_status
               ~toplevel_status ~toplevel_url package_meta))
