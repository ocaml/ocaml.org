open Ocamlorg
open Ocamlorg.Import

let not_found _req = Dream.html ~code:404 (Ocamlorg_frontend.not_found ())
let index _req = Dream.html (Ocamlorg_frontend.home ())

let learn _req =
  let papers = Ood.Paper.featured in
  let books = Ood.Book.featured in
  let tutorials = Ood.Tutorial.all in
  let release = List.hd Ood.Release.all in
  Dream.html (Ocamlorg_frontend.learn ~papers ~books ~release ~tutorials)

let platform _req =
  let tools = Ood.Tool.all in
  let tutorials = Ood.Tutorial.all in
  Dream.html (Ocamlorg_frontend.platform ~tutorials tools)

let community _req =
  let workshops = Ood.Workshop.all in
  let meetups = Ood.Meetup.all in
  Dream.html (Ocamlorg_frontend.community ~workshops ~meetups)

let success_story req =
  let slug = Dream.param req "id" in
  let story = Ood.Success_story.get_by_slug slug in
  match story with
  | Some story -> Dream.html (Ocamlorg_frontend.success_story story)
  | None -> not_found req

let industrial_users _req =
  let users = Ood.Industrial_user.featured in
  let success_stories = Ood.Success_story.all in
  Dream.html (Ocamlorg_frontend.industrial_users ~users ~success_stories)

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
    match Dream.query req "q" with
    | None -> Ood.Academic_institution.all
    | Some search -> search_user search Ood.Academic_institution.all
  in
  Dream.html (Ocamlorg_frontend.academic_users users)

let about _req = Dream.html (Ocamlorg_frontend.about ())
let books _req = Dream.html (Ocamlorg_frontend.books Ood.Book.all)

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
  let search = Dream.query req "q" in
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
    Dream.query req "p" |> Option.map int_of_string |> Option.value ~default:1
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

let jobs req =
  let location = Dream.query req "c" in
  let jobs =
    match location with
    | None | Some "All" -> Ood.Job.all
    | Some location ->
        List.filter
          (fun job -> List.exists (( = ) location) job.Ood.Job.locations)
          Ood.Job.all
  in
  let locations =
    Ood.Job.all
    |> List.concat_map (fun job ->
           List.filter (( <> ) "Remote") job.Ood.Job.locations)
    |> List.sort_uniq String.compare
  in
  Dream.html (Ocamlorg_frontend.jobs ?location ~locations jobs)

let page canonical (_req : Dream.request) =
  let page = Ood.Page.get canonical in
  Dream.html
    (Ocamlorg_frontend.page ~title:page.title ~description:page.description
       ~meta_title:page.meta_title ~meta_description:page.meta_description
       ~content:page.body_html ~canonical)

let carbon_footprint = page Url.carbon_footprint
let privacy_policy = page Url.privacy_policy
let governance = page Url.governance
let code_of_conduct = page Url.code_of_conduct
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
  let search = Dream.query req "q" in
  let papers =
    match search with
    | None -> Ood.Paper.all
    | Some search -> search_paper search Ood.Paper.all
  in
  let recommended_papers = Ood.Paper.featured in
  Dream.html (Ocamlorg_frontend.papers ?search ~recommended_papers papers)

let tutorial req =
  let slug = Dream.param req "id" in
  match
    List.find_opt (fun x -> x.Ood.Tutorial.slug = slug) Ood.Tutorial.all
  with
  | Some tutorial ->
      let tutorials = Ood.Tutorial.all in
      Ocamlorg_frontend.tutorial ~tutorials
        ~canonical:(Url.tutorial tutorial.slug)
        tutorial
      |> Dream.html
  | None -> not_found req

let best_practices _req =
  let tutorials = Ood.Tutorial.all in
  Dream.html (Ocamlorg_frontend.best_practices ~tutorials Ood.Workflow.all)

let problems _req = Dream.html (Ocamlorg_frontend.problems Ood.Problem.all)

type package_kind = Package | Universe

let package_of_info ~name ~version ~versions info =
  let rev_deps =
    List.map
      (fun (name, _, _versions) -> Ocamlorg_package.Name.to_string name)
      info.Ocamlorg_package.Info.rev_deps
  in
  Ocamlorg_frontend.
    {
      name = Ocamlorg_package.Name.to_string name;
      version = Ocamlorg_package.Version.to_string version;
      versions;
      description = info.Ocamlorg_package.Info.synopsis;
      tags = info.tags;
      rev_deps;
      authors = info.authors;
      maintainers = info.maintainers;
      license = info.license;
      publication = info.publication;
    }

(** Query all the versions of a package. *)
let package_versions state name =
  Ocamlorg_package.get_package_versions state name
  |> Option.value ~default:[]
  |> List.sort (Fun.flip Ocamlorg_package.Version.compare)
  |> List.map Ocamlorg_package.Version.to_string

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
  match Dream.query req "q" with
  | Some search ->
      let packages =
        Ocamlorg_package.search_package ~sort_by_popularity:true t search
      in
      let total = List.length packages in
      let results = List.map (package_meta t) packages in
      let search = Dream.from_percent_encoded search in
      Dream.html (Ocamlorg_frontend.packages_search ~total ~search results)
  | None -> Dream.redirect req Url.packages

let packages_autocomplete_fragment t req =
  match Dream.query req "q" with
  | Some search when search <> "" ->
      let packages =
        Ocamlorg_package.search_package ~sort_by_popularity:true t search
      in
      let results = List.map (package_meta t) packages in
      let top_5 = results |> List.take 5 in
      let search = Dream.from_percent_encoded search in
      Dream.html
        (Ocamlorg_frontend.packages_autocomplete_fragment ~search ~total:(List.length results) top_5)
  | _ -> Dream.html ""

let package _t req =
  let package = Dream.param req "name" in
  let target = Url.package_with_version package in
  Dream.redirect req target

(** Redirect any URL with suffix /p/PACKAGE/docs to the latest documentation for
    PACKAGE. *)
let package_docs _t req =
  let package = Dream.param req "name" in
  let target = Url.package_doc package in
  Dream.redirect req target

let to_package t name version =
  if version = "latest" then Ocamlorg_package.get_package_latest t name
  else
    let version = Ocamlorg_package.Version.of_string version in
    Ocamlorg_package.get_package t name version

let installer req = Dream.redirect req Url.github_installer

let package_versioned t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version_from_url = Dream.param req "version" in
  let package = to_package t name version_from_url in
  match package with
  | None -> not_found req
  | Some package ->
      let open Lwt.Syntax in
      let is_latest_url = version_from_url = "latest" in
      let kind =
        match kind with
        | Package -> `Package
        | Universe -> `Universe (Dream.param req "hash")
      in
      let description =
        (Ocamlorg_package.info package).Ocamlorg_package.Info.description
      in
      let* readme, readme_title =
        let+ readme_opt = Ocamlorg_package.readme_file ~kind package in
        match readme_opt with
        | Some doc -> (doc, "README")
        | None -> (description |> Omd.of_string |> Omd.to_html, "Description")
      in
      let* changes_filename = Ocamlorg_package.changes_filename ~kind package in
      let* license_filename = Ocamlorg_package.license_filename ~kind package in
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
      let conflicts =
        package_info.Ocamlorg_package.Info.conflicts
        |> List.map (fun (name, x) -> (Ocamlorg_package.Name.to_string name, x))
      in
      let homepages = package_info.Ocamlorg_package.Info.homepage in
      let source =
        Option.map
          (fun url ->
            (url.Ocamlorg_package.Info.uri, url.Ocamlorg_package.Info.checksum))
          package_info.Ocamlorg_package.Info.url
      in
      let* package_documentation_status =
        Ocamlorg_package.documentation_status ~kind package
      in
      let documentation_status =
        match package_documentation_status with
        | Ocamlorg_package.Success -> Ocamlorg_frontend.Package_overview.Success
        | Failure -> Failure
        | Unknown -> Unknown
      in
      Dream.html
        (Ocamlorg_frontend.package_overview ~documentation_status ~readme
           ~readme_title ~dependencies ~rev_dependencies ~conflicts ~homepages
           ~source ~changes_filename ~license_filename ~is_latest_url
           package_meta)

let package_doc t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version_from_url = Dream.param req "version" in
  let package = to_package t name version_from_url in
  match package with
  | None -> not_found req
  | Some package -> (
      let open Lwt.Syntax in
      let is_latest_url = version_from_url = "latest" in
      let version = Ocamlorg_package.version package in
      let package_meta = package_meta t package in
      let kind =
        match kind with
        | Package -> `Package
        | Universe -> `Universe (Dream.param req "hash")
      in
      let path = (Dream.path [@ocaml.warning "-3"]) req |> String.concat "/" in
      let root =
        let version =
          if is_latest_url then None
          else Some (Ocamlorg_package.Version.to_string version)
        in
        let hash = match kind with `Package -> None | `Universe u -> Some u in
        Url.package_doc ?hash ~page:"" ?version
          (Ocamlorg_package.Name.to_string name)
      in
      let* docs = Ocamlorg_package.documentation_page ~kind package path in
      match docs with
      | None ->
          Dream.html
            (Ocamlorg_frontend.package_documentation_not_found ~is_latest_url
               ~path:(Ocamlorg_frontend.Package_breadcrumbs.Documentation Index)
               ~package:package_meta)
      | Some doc ->
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
              | Module_map.Page -> Ocamlorg_frontend.Navmap.Page
              | Module -> Module
              | Leaf_page -> Leaf_page
              | Module_type -> Module_type
              | Parameter _ -> Parameter
              | OLDParameter -> OLDParameter
              | Class -> Class
              | Class_type -> Class_type
              | File -> File
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
                     { title; href; kind = Library; children })
          in
          let toc = toc_of_toc doc.toc in
          let (maptoc : Ocamlorg_frontend.Navmap.toc list) =
            toc_of_map ~root doc.module_map
          in
          let (path : Ocamlorg_frontend.Package_breadcrumbs.path) =
            let breadcrumbs = doc.breadcrumbs in
            if breadcrumbs != [] then
              let first_path_item = List.hd breadcrumbs in
              let doc_breadcrumb_to_library_path_item
                  (p : Ocamlorg_package.Documentation.breadcrumb) =
                match p.kind with
                | Module -> Ocamlorg_frontend.Package_breadcrumbs.Module p.name
                | ModuleType -> ModuleType p.name
                | Parameter i -> Parameter (i, p.name)
                | Class -> Class p.name
                | ClassType -> ClassType p.name
                | Page | LeafPage | File ->
                    failwith
                      "library paths do not contain Page, LeafPage or File"
              in

              match first_path_item.kind with
              | Page | LeafPage | File ->
                  Ocamlorg_frontend.Package_breadcrumbs.Documentation
                    (Page first_path_item.name)
              | Module | ModuleType | Parameter _ | Class | ClassType ->
                  let library =
                    List.find_opt
                      (fun (toc : Ocamlorg_frontend.Navmap.toc) ->
                        List.exists
                          (fun (t : Ocamlorg_frontend.Navmap.toc) ->
                            t.title = first_path_item.name)
                          toc.children)
                      maptoc
                  in

                  Ocamlorg_frontend.Package_breadcrumbs.Documentation
                    (Library
                       ( (match library with
                         | Some l -> l.title
                         | None -> "unknown"),
                         List.map doc_breadcrumb_to_library_path_item
                           breadcrumbs ))
            else Ocamlorg_frontend.Package_breadcrumbs.Documentation Index
          in
          Dream.html
            (Ocamlorg_frontend.package_documentation ~path ~toc ~maptoc
               ~is_latest_url ~old_doc:doc.old ~content:doc.content package_meta)
      )
