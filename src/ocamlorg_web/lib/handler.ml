open Ocamlorg
open Ocamlorg.Import

let http_or_404 ?(not_found = Ocamlorg_frontend.not_found) opt f =
  Option.fold ~none:(Dream.html ~code:404 (not_found ())) ~some:f opt

(* short-circuiting 404 error operator *)
let ( let</>? ) opt = http_or_404 opt

let index _req =
  Dream.html
    (Ocamlorg_frontend.home ~latest_release:Data.Release.latest
       ~lts_release:Data.Release.lts)

let install _req = Dream.html (Ocamlorg_frontend.install ())

let learn _req =
  let papers = Data.Paper.featured in
  let books = Data.Book.featured in
  let latest_version = Data.Release.latest.version in
  Dream.html (Ocamlorg_frontend.learn ~papers ~books ~latest_version)

let learn_get_started req =
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = GetStarted)
  in
  Dream.redirect req (Url.tutorial (List.hd tutorials).slug)

let learn_language req =
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = Language)
  in
  Dream.redirect req (Url.tutorial (List.hd tutorials).slug)

let learn_guides req =
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = Guides)
  in
  Dream.redirect req (Url.tutorial (List.hd tutorials).slug)

let platform _req =
  let tools = Data.Tool.all in
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = Platform)
  in
  Dream.html (Ocamlorg_frontend.platform ~tutorials tools)

let community _req =
  let workshops = Data.Workshop.all in
  let meetups = Data.Meetup.all in
  Dream.html (Ocamlorg_frontend.community ~workshops ~meetups)

let changelog req =
  let current_tag = Dream.query req "t" in
  let tags =
    Data.Changelog.all
    |> List.concat_map (fun (change : Data.Changelog.t) -> change.tags)
    |> List.sort_uniq String.compare
    |> List.sort_uniq String.compare
  in
  let changes =
    match current_tag with
    | None | Some "" -> Data.Changelog.all
    | Some tag ->
        List.filter
          (fun change -> List.exists (( = ) tag) change.Data.Changelog.tags)
          Data.Changelog.all
  in
  Dream.html (Ocamlorg_frontend.changelog ?current_tag ~tags changes)

let changelog_entry req =
  let slug = Dream.param req "id" in
  let</>? change = Data.Changelog.get_by_slug slug in
  Dream.html (Ocamlorg_frontend.changelog_entry change)

let success_story req =
  let slug = Dream.param req "id" in
  let</>? success_story = Data.Success_story.get_by_slug slug in
  Dream.html (Ocamlorg_frontend.success_story success_story)

let industrial_users _req =
  let users = Data.Industrial_user.featured in
  let success_stories = Data.Success_story.all in
  Dream.html (Ocamlorg_frontend.industrial_users ~users ~success_stories)

let academic_users req =
  let search_user pattern t =
    let open Data.Academic_institution in
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
    | None -> Data.Academic_institution.all
    | Some search -> search_user search Data.Academic_institution.all
  in
  Dream.html (Ocamlorg_frontend.academic_users users)

let about _req = Dream.html (Ocamlorg_frontend.about ())
let books _req = Dream.html (Ocamlorg_frontend.books Data.Book.all)

let releases req =
  let search_release pattern t =
    let open Data.Release in
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
    | None -> Data.Release.all
    | Some search -> search_release search Data.Release.all
  in
  Dream.html (Ocamlorg_frontend.releases releases)

let release req =
  let version = Dream.param req "id" in
  let</>? version = Data.Release.get_by_version version in
  Dream.html (Ocamlorg_frontend.release version)

let workshop req =
  let watch_ocamlorg_embed =
    let presentations =
      List.concat_map
        (fun (w : Data.Workshop.t) -> w.presentations)
        Data.Workshop.all
    in
    let rec get_last = function
      | [] -> ""
      | [ x ] -> x
      | _ :: xs -> get_last xs
    in
    let watch =
      List.map
        (fun (w : Data.Watch.t) ->
          String.split_on_char '/' w.embed_path |> get_last |> fun v -> (v, w))
        Data.Watch.all
    in
    let tbl = Hashtbl.create 100 in
    let add_video (p : Data.Workshop.presentation) =
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
  let</>? workshop =
    List.find_opt (fun x -> x.Data.Workshop.slug = slug) Data.Workshop.all
  in
  Dream.html (Ocamlorg_frontend.workshop ~videos:watch_ocamlorg_embed workshop)

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
    items |> List.drop skip |> List.take items_per_page
  in
  (page, number_of_pages, current_items)

let blog req =
  let page, number_of_pages, current_items =
    paginate ~req ~n:10
      (List.filter
         (fun (x : Data.Planet.Post.t) -> not x.featured)
         Data.Planet.Post.all)
  in
  let featured = Data.Planet.featured_posts |> List.take 3 in
  let news = Data.News.all |> List.take 20 in
  Dream.html
    (Ocamlorg_frontend.blog ~featured ~planet:current_items ~planet_page:page
       ~planet_pages_number:number_of_pages ~news)

let local_blog req =
  let source = Dream.param req "source" in
  let</>? local_blog = Data.Planet.LocalBlog.get_by_id source in
  Dream.html
    (Ocamlorg_frontend.local_blog ~source:local_blog.source
       ~posts:local_blog.posts)

let blog_post req =
  let source = Dream.param req "source" in
  let slug = Dream.param req "slug" in
  let</>? local_blog = Data.Planet.LocalBlog.get_by_id source in
  match slug with
  | "feed.xml" ->
      Dream.respond
        ~headers:[ ("Content-Type", "application/xml; charset=utf-8") ]
        local_blog.rss_feed
  | _ ->
      let</>? post =
        local_blog.posts
        |> List.find_opt (fun (p : Data.Planet.Post.t) ->
               String.equal p.slug slug)
      in
      Dream.html (Ocamlorg_frontend.blog_post post)

let news req =
  let page, number_of_pages, current_items =
    paginate ~req ~n:10 Data.News.all
  in
  Dream.html
    (Ocamlorg_frontend.news ~page ~pages_number:number_of_pages current_items)

let news_post req =
  let slug = Dream.param req "id" in
  let</>? news = Data.News.get_by_slug slug in
  Dream.html (Ocamlorg_frontend.news_post news)

let jobs req =
  let location = Dream.query req "c" in
  let jobs =
    match location with
    | None | Some "All" -> Data.Job.all
    | Some location ->
        List.filter
          (fun job -> List.exists (( = ) location) job.Data.Job.locations)
          Data.Job.all
  in
  let locations =
    Data.Job.all
    |> List.concat_map (fun job ->
           List.filter (( <> ) "Remote") job.Data.Job.locations)
    |> List.sort_uniq String.compare
  in
  Dream.html (Ocamlorg_frontend.jobs ?location ~locations jobs)

let page canonical (_req : Dream.request) =
  let page = Data.Page.get canonical in
  Dream.html
    (Ocamlorg_frontend.page ~title:page.title ~description:page.description
       ~meta_title:page.meta_title ~meta_description:page.meta_description
       ~content:page.body_html ~canonical)

let carbon_footprint = page Url.carbon_footprint
let privacy_policy = page Url.privacy_policy
let governance = page Url.governance
let code_of_conduct = page Url.code_of_conduct

let playground _req =
  let default = Data.Code_example.get "default.ml" in
  let default_code = default.body in
  Dream.html (Ocamlorg_frontend.playground ~default_code)

let papers req =
  let search_paper pattern t =
    let open Data.Paper in
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
    | None -> Data.Paper.all
    | Some search -> search_paper search Data.Paper.all
  in
  let recommended_papers = Data.Paper.featured in
  Dream.html (Ocamlorg_frontend.papers ?search ~recommended_papers papers)

let tutorial req =
  let slug = Dream.param req "id" in
  let</>? tutorial =
    List.find_opt (fun x -> x.Data.Tutorial.slug = slug) Data.Tutorial.all
  in
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = tutorial.section)
  in
  Dream.html
    (Ocamlorg_frontend.tutorial ~tutorials
       ~canonical:(Url.tutorial tutorial.slug)
       tutorial)

let problems req =
  let all_problems = Data.Problem.all in
  let difficulty_level = Dream.query req "difficulty_level" in
  let compare_difficulty = function
    | "beginner" -> ( = ) `Beginner
    | "intermediate" -> ( = ) `Intermediate
    | "advanced" -> ( = ) `Advanced
    | _ -> Fun.const true
  in
  let by_difficulty level (problem : Data.Problem.t) =
    match level with
    | Some difficulty -> compare_difficulty difficulty problem.difficulty
    | _ -> true
  in
  let filtered_problems =
    List.filter (by_difficulty difficulty_level) all_problems
  in
  Dream.html (Ocamlorg_frontend.problems ?difficulty_level filtered_problems)

let installer req = Dream.redirect req Url.github_installer
let outreachy _req = Dream.html (Ocamlorg_frontend.outreachy Data.Outreachy.all)

type package_kind = Package | Universe

module Package_helper = struct
  let package_info_to_frontend_package ~name ~version ?(on_latest_url = false)
      ~latest_version ~versions info =
    let rev_deps =
      List.map
        (fun (name, _, _versions) -> Ocamlorg_package.Name.to_string name)
        info.Ocamlorg_package.Info.rev_deps
    in
    let owner name =
      Option.value
        (Data.Opam_user.find_by_name name)
        ~default:(Data.Opam_user.make ~name ())
    in
    Ocamlorg_frontend.Package.
      {
        name = Ocamlorg_package.Name.to_string name;
        version =
          (if on_latest_url then Latest
           else Specific (Ocamlorg_package.Version.to_string version));
        versions;
        latest_version =
          Option.value ~default:"???"
            (Option.map Ocamlorg_package.Version.to_string latest_version);
        synopsis = info.Ocamlorg_package.Info.synopsis;
        description =
          info.Ocamlorg_package.Info.description |> Omd.of_string |> Omd.to_html;
        tags = info.tags;
        rev_deps;
        authors = List.map owner info.authors;
        maintainers = List.map owner info.maintainers;
        license = info.license;
        publication = info.publication;
        homepages = info.Ocamlorg_package.Info.homepage;
        source =
          Option.map
            (fun url ->
              (url.Ocamlorg_package.Info.uri, url.Ocamlorg_package.Info.checksum))
            info.Ocamlorg_package.Info.url;
      }

  (** Query all the versions of a package. *)
  let versions state name =
    Ocamlorg_package.get_versions state name
    |> Option.value ~default:[]
    |> List.sort (Fun.flip Ocamlorg_package.Version.compare)
    |> List.map Ocamlorg_package.Version.to_string

  let frontend_package ?on_latest_url state (package : Ocamlorg_package.t) :
      Ocamlorg_frontend.Package.package =
    let name = Ocamlorg_package.name package
    and version = Ocamlorg_package.version package
    and info = Ocamlorg_package.info package in
    let versions = versions state name in
    let latest_version =
      Option.map
        (fun (p : Ocamlorg_package.t) -> Ocamlorg_package.version p)
        (Ocamlorg_package.get_latest state name)
    in
    package_info_to_frontend_package ~name ~version ?on_latest_url
      ~latest_version ~versions info

  let of_name_version t name version =
    let package =
      if version = "latest" then Ocamlorg_package.get_latest t name
      else
        Ocamlorg_package.get t name (Ocamlorg_package.Version.of_string version)
    in
    package
    |> Option.map (fun package ->
           ( package,
             frontend_package t package ~on_latest_url:(version = "latest") ))

  let package_sidebar_data ~kind package =
    let open Lwt.Syntax in
    let* package_documentation_status =
      Ocamlorg_package.documentation_status ~kind package
    in
    let readme_filename =
      Option.fold ~none:None
        ~some:(fun (s : Ocamlorg_package.Documentation_status.t) ->
          s.otherdocs.readme)
        package_documentation_status
    in
    let changes_filename =
      Option.fold ~none:None
        ~some:(fun (s : Ocamlorg_package.Documentation_status.t) ->
          s.otherdocs.changes)
        package_documentation_status
    in
    let license_filename =
      Option.fold ~none:None
        ~some:(fun (s : Ocamlorg_package.Documentation_status.t) ->
          s.otherdocs.license)
        package_documentation_status
    in
    let documentation_status =
      match package_documentation_status with
      | Some { failed = false; _ } -> Ocamlorg_frontend.Package.Success
      | Some { failed = true; _ } -> Failure
      | None -> Unknown
    in
    Lwt.return
      Ocamlorg_frontend.Package_overview.
        {
          documentation_status;
          readme_filename;
          changes_filename;
          license_filename;
        }

  let frontend_toc (xs : Ocamlorg_package.Documentation.toc list) :
      Ocamlorg_frontend.Toc.t =
    let rec aux acc = function
      | [] -> List.rev acc
      | Ocamlorg_package.Documentation.{ title; href; children } :: rest ->
          Ocamlorg_frontend.Toc.{ title; href; children = aux [] children }
          :: aux acc rest
    in
    aux [] xs
end

let is_ocaml_yet t id req =
  let</>? meta =
    List.find_opt (fun x -> x.Data.Is_ocaml_yet.id = id) Data.Is_ocaml_yet.all
  in
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = Guides)
  in
  let packages =
    meta.categories
    |> List.concat_map (fun category -> category.Data.Is_ocaml_yet.packages)
    |> List.filter_map (fun (p : Data.Is_ocaml_yet.package) ->
           let name = Ocamlorg_package.Name.of_string p.name in
           match Ocamlorg_package.get_latest t name with
           | Some x -> Some x
           | None ->
               if p.extern = None then
                 Dream.error (fun log ->
                     log ~request:req "Package not found: %s"
                       (Ocamlorg_package.Name.to_string name));
               None)
    |> List.map (Package_helper.frontend_package t)
    |> List.map (fun pkg -> (pkg.Ocamlorg_frontend.Package.name, pkg))
    |> List.to_seq |> Hashtbl.of_seq
  in
  Dream.html (Ocamlorg_frontend.is_ocaml_yet ~tutorials ~packages meta)

let packages state _req =
  let package { Ocamlorg_package.Statistics.name; version; info } =
    let versions = Package_helper.versions state name in
    let latest_version =
      Option.map
        (fun (p : Ocamlorg_package.t) -> Ocamlorg_package.version p)
        (Ocamlorg_package.get_latest state name)
    in
    Package_helper.package_info_to_frontend_package ~name ~version
      ~latest_version ~versions info
  in
  let package_pair (pkg, snd) = (package pkg, snd) in
  let stats =
    Ocamlorg_package.stats state
    |> Option.map (fun (t : Ocamlorg_package.Statistics.t) ->
           Ocamlorg_frontend.Package.
             {
               nb_packages = t.nb_packages;
               nb_update_week = t.nb_update_week;
               nb_packages_month = t.nb_packages_month;
               newest_packages = List.map package_pair t.newest_packages;
               recently_updated = List.map package t.recently_updated;
               most_revdeps = List.map package_pair t.most_revdeps;
             })
  and featured =
    Data.Packages.all.featured
    |> List.filter_map
         Ocamlorg_package.(
           fun name ->
             get_latest state (Name.of_string name)
             |> Option.map (Package_helper.frontend_package state))
  in
  Dream.html (Ocamlorg_frontend.packages stats featured)

let is_author_match name pattern =
  let match_opt = function
    | Some s -> String.contains_s s pattern
    | None -> false
  in
  match Data.Opam_user.find_by_name name with
  | None -> String.contains_s name pattern
  | Some { name; email; github_username; _ } ->
      match_opt (Some name) || match_opt email || match_opt github_username

let packages_search t req =
  match Dream.query req "q" with
  | Some search ->
      let packages =
        Ocamlorg_package.search ~is_author_match ~sort_by_popularity:true t
          search
      in
      let total = List.length packages in
      let results = List.map (Package_helper.frontend_package t) packages in
      let search = Dream.from_percent_encoded search in
      Dream.html (Ocamlorg_frontend.packages_search ~total ~search results)
  | None -> Dream.redirect req Url.packages

let packages_autocomplete_fragment t req =
  match Dream.query req "q" with
  | Some search when search <> "" ->
      let packages =
        Ocamlorg_package.search ~is_author_match ~sort_by_popularity:true t
          search
      in
      let results = List.map (Package_helper.frontend_package t) packages in
      let top_5 = results |> List.take 5 in
      let search = Dream.from_percent_encoded search in
      Dream.html
        (Ocamlorg_frontend.packages_autocomplete_fragment ~search
           ~total:(List.length results) top_5)
  | _ -> Dream.html ""

let package_overview t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version_from_url = Dream.param req "version" in
  let</>? package, frontend_package =
    Package_helper.of_name_version t name version_from_url
  in
  let open Lwt.Syntax in
  let kind =
    match kind with
    | Package -> `Package
    | Universe -> `Universe (Dream.param req "hash")
  in
  let* sidebar_data = Package_helper.package_sidebar_data ~kind package in

  let* maybe_search_index = Ocamlorg_package.search_index ~kind package in
  let search_index_digest =
    Option.map
      (fun idx -> idx |> Digest.string |> Dream.to_base64url)
      maybe_search_index
  in

  let package_info = Ocamlorg_package.info package in
  let rev_dependencies =
    package_info.Ocamlorg_package.Info.rev_deps
    |> List.map (fun (name, x, version) ->
           Ocamlorg_frontend.Package_overview.
             {
               name = Ocamlorg_package.Name.to_string name;
               cstr = x;
               version = Some (Ocamlorg_package.Version.to_string version);
             })
  in
  let dependencies :
      Ocamlorg_frontend.Package_overview.dependency_or_conflict list =
    package_info.Ocamlorg_package.Info.dependencies
    |> List.map (fun (name, x) ->
           Ocamlorg_frontend.Package_overview.
             {
               name = Ocamlorg_package.Name.to_string name;
               cstr = x;
               version = None;
             })
  in
  let dev_dependencies, dependencies =
    dependencies
    |> List.partition
         (fun (item : Ocamlorg_frontend.Package_overview.dependency_or_conflict)
         ->
           let s = Option.value ~default:"" item.cstr in
           String.contains_s s "with-" || String.contains_s s "dev")
  in
  let conflicts =
    package_info.Ocamlorg_package.Info.conflicts
    |> List.map (fun (name, x) ->
           Ocamlorg_frontend.Package_overview.
             {
               name = Ocamlorg_package.Name.to_string name;
               cstr = x;
               version = None;
             })
  in
  let title_with_number title number =
    title ^ if number > 0 then " (" ^ string_of_int number ^ ")" else ""
  in
  let deps_and_conflicts :
      Ocamlorg_frontend.Package_overview.dependencies_and_conflicts list =
    [
      {
        title = title_with_number "Dependencies" (List.length dependencies);
        slug = "dependencies";
        items = dependencies;
        collapsible = false;
      };
      {
        title =
          title_with_number "Dev Dependencies" (List.length dev_dependencies);
        slug = "development-dependencies";
        items = dev_dependencies;
        collapsible = false;
      };
      {
        title = title_with_number "Used by" (List.length rev_dependencies);
        slug = "used-by";
        items = rev_dependencies;
        collapsible = true;
      };
      {
        title = title_with_number "Conflicts" (List.length conflicts);
        slug = "conflicts";
        items = conflicts;
        collapsible = false;
      };
    ]
  in
  let toc =
    Ocamlorg_frontend.Toc.
      { title = "Description"; href = "#description"; children = [] }
    :: (deps_and_conflicts
       |> List.map
            (fun
              (section :
                Ocamlorg_frontend.Package_overview.dependencies_and_conflicts)
            ->
              Ocamlorg_frontend.Toc.
                {
                  title = section.title;
                  href = "#" ^ section.slug;
                  children = [];
                }))
  in
  Dream.html
    (Ocamlorg_frontend.package_overview ~sidebar_data ~content:""
       ~search_index_digest ~content_title:None ~toc ~deps_and_conflicts
       frontend_package)

let package_documentation t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version_from_url = Dream.param req "version" in
  let</>? package, frontend_package =
    Package_helper.of_name_version t name version_from_url
  in
  let open Lwt.Syntax in
  let kind =
    match kind with
    | Package -> `Package
    | Universe -> `Universe (Dream.param req "hash")
  in
  let path = (Dream.path [@ocaml.warning "-3"]) req |> String.concat "/" in
  let hash = match kind with `Package -> None | `Universe u -> Some u in
  let root =
    Url.Package.documentation ?hash ~page:""
      ?version:(Ocamlorg_frontend.Package.url_version frontend_package)
      (Ocamlorg_package.Name.to_string name)
  in
  let* docs = Ocamlorg_package.documentation_page ~kind package path in
  match docs with
  | None ->
      let response_404_page =
        Dream.html ~code:404
          (Ocamlorg_frontend.package_documentation_not_found ~page:path
             ~search_index_digest:None
             ~path:(Ocamlorg_frontend.Package_breadcrumbs.Documentation Index)
             frontend_package)
      in
      if version_from_url = "latest" then
        let* latest_documented_version =
          Ocamlorg_package.latest_documented_version t name
        in
        match latest_documented_version with
        | None -> response_404_page
        | Some version ->
            Dream.redirect req ~code:302
              (Url.Package.documentation ?hash
                 ~version:(Ocamlorg_package.Version.to_string version)
                 ~page:path
                 (Ocamlorg_package.Name.to_string name))
      else response_404_page
  | Some doc ->
      let module Package_info = Ocamlorg_package.Package_info in
      let rec toc_of_module ~root
          (module' : Ocamlorg_package.Package_info.Module.t) :
          Ocamlorg_frontend.Navmap.toc =
        let title = Package_info.Module.name module' in
        let kind = Package_info.Module.kind module' in
        let href = Some (root ^ Package_info.Module.path module') in
        let children =
          module' |> Package_info.Module.submodules |> String.Map.bindings
          |> List.map (fun (_, module') -> toc_of_module ~root module')
        in
        let kind =
          match (kind : Package_info.Kind.t) with
          | Page -> Ocamlorg_frontend.Navmap.Page
          | Module -> Module
          | LeafPage -> Leaf_page
          | ModuleType -> Module_type
          | Parameter _ -> Parameter
          | Class -> Class
          | ClassType -> Class_type
          | File -> File
        in
        Ocamlorg_frontend.Navmap.{ title; href; kind; children }
      in
      let toc_of_map ~root (map : Ocamlorg_package.Package_info.t) :
          Ocamlorg_frontend.Navmap.t =
        let libraries = map.libraries in
        String.Map.bindings libraries
        |> List.map (fun (_, (library : Package_info.library)) ->
               let title = library.name in
               let href = None in
               let children =
                 String.Map.bindings library.modules
                 |> List.map (fun (_, module') -> toc_of_module ~root module')
               in
               Ocamlorg_frontend.Navmap.
                 { title; href; kind = Library; children })
      in
      let* module_map = Ocamlorg_package.module_map ~kind package in
      let* maybe_search_index = Ocamlorg_package.search_index ~kind package in
      let search_index_digest =
        Option.map
          (fun idx -> idx |> Digest.string |> Dream.to_base64url)
          maybe_search_index
      in
      let toc = Package_helper.frontend_toc doc.toc in
      let (maptoc : Ocamlorg_frontend.Navmap.toc list) =
        toc_of_map ~root module_map
      in
      let (breadcrumb_path : Ocamlorg_frontend.Package_breadcrumbs.path) =
        let breadcrumbs = doc.breadcrumbs in
        if breadcrumbs != [] then
          let first_path_item = List.hd breadcrumbs in
          let doc_breadcrumb_to_library_path_item
              (p : Ocamlorg_package.Documentation.breadcrumb) =
            match p.kind with
            | Module ->
                Ocamlorg_frontend.Package_breadcrumbs.Module
                  { name = p.name; href = p.href }
            | ModuleType -> ModuleType { name = p.name; href = p.href }
            | Parameter i ->
                Parameter { name = p.name; href = p.href; number = i }
            | Class -> Class { name = p.name; href = p.href }
            | ClassType -> ClassType { name = p.name; href = p.href }
            | Page | LeafPage | File ->
                failwith "library paths do not contain Page, LeafPage or File"
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
                   ( (match library with Some l -> l.title | None -> "unknown"),
                     List.map doc_breadcrumb_to_library_path_item breadcrumbs ))
        else Ocamlorg_frontend.Package_breadcrumbs.Documentation Index
      in
      Dream.html
        (Ocamlorg_frontend.package_documentation ~page:(Some path)
           ~search_index_digest ~path:breadcrumb_path ~toc ~maptoc
           ~content:doc.content frontend_package)

let package_file t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version_from_url = Dream.param req "version" in
  let</>? package, frontend_package =
    Package_helper.of_name_version t name version_from_url
  in
  let open Lwt.Syntax in
  let kind =
    match kind with
    | Package -> `Package
    | Universe -> `Universe (Dream.param req "hash")
  in
  let path = (Dream.path [@ocaml.warning "-3"]) req |> String.concat "/" in
  let* sidebar_data = Package_helper.package_sidebar_data ~kind package in
  let* maybe_search_index = Ocamlorg_package.search_index ~kind package in
  let search_index_digest =
    Option.map
      (fun idx -> idx |> Digest.string |> Dream.to_base64url)
      maybe_search_index
  in
  let* maybe_doc = Ocamlorg_package.file ~kind package path in
  let</>? doc = maybe_doc in
  let content = doc.content in
  let toc = Package_helper.frontend_toc doc.toc in
  Dream.html
    (Ocamlorg_frontend.package_overview ~sidebar_data ~content
       ~search_index_digest ~content_title:(Some path) ~toc
       ~deps_and_conflicts:[] frontend_package)

let package_search_index t kind req =
  let name = Ocamlorg_package.Name.of_string @@ Dream.param req "name" in
  let version_from_url = Dream.param req "version" in
  let</>? package, _ = Package_helper.of_name_version t name version_from_url in
  let open Lwt.Syntax in
  let kind =
    match kind with
    | Package -> `Package
    | Universe -> `Universe (Dream.param req "hash")
  in
  let* maybe_search_index = Ocamlorg_package.search_index ~kind package in
  let</>? search_index = maybe_search_index in
  Lwt.return
    (Dream.response
       ~headers:
         [
           ("Content-type", "application/javascript");
           ("Cache-Control", "max-age=31536000, immutable");
         ]
       search_index)

let sitemap _request =
  let open Lwt.Syntax in
  Dream.stream
    ~headers:[ ("Content-Type", "application/xml; charset=utf-8") ]
    (fun stream ->
      let* _ = Lwt_seq.iter_s (Dream.write stream) Sitemap.data in
      Dream.flush stream)
