open Ocamlorg_web_template

let index site_dir = Dream.static site_dir

let not_found _req =
  Layout_page.render
    ~title:"Page not found · OCaml"
    ~description:Config.meta_description
    Page_not_found.render
  |> Dream.html ~status:`Not_Found

type package_kind =
  | Package
  | Universe

let packages _req =
  Layout_page.render
    ~title:"OCaml Packages · Browse community packages"
    ~description:
      "Discover thousands of community packages and their browse their \
       documentation."
    Page_packages.render
  |> Dream.html

let package_search req =
  match Dream.query "q" req with
  | Some search ->
    let packages = Ocamlorg.Package.search_package search in
    Layout_page.render
      ~title:"OCaml Packages · Search community packages"
      ~description:
        "Find the package you need to build your application in the thousands \
         of available opam packages."
      (Page_package_search.render packages)
    |> Dream.html
  | None ->
    Dream.redirect req "/packages"

let package req =
  let package = Dream.param "name" req in
  let find_default_version name =
    Ocamlorg.Package.get_package_latest name
    |> Option.map (fun pkg -> Ocamlorg.Package.version pkg)
  in
  let name = Ocamlorg.Package.Name.of_string package in
  let version = find_default_version name in
  match version with
  | Some version ->
    let target =
      "/p/" ^ package ^ "/" ^ Ocamlorg.Package.Version.to_string version
    in
    Dream.redirect req target
  | None ->
    not_found req

let package_versioned kind req =
  let name = Ocamlorg.Package.Name.of_string @@ Dream.param "name" req in
  let version =
    Ocamlorg.Package.Version.of_string @@ Dream.param "version" req
  in
  let package = Ocamlorg.Package.get_package name version in
  match package with
  | None ->
    not_found req
  | Some package ->
    let open Lwt.Syntax in
    let kind =
      match kind with
      | Package ->
        `Package
      | Universe ->
        `Universe (Dream.param "hash" req)
    in
    let description =
      (Ocamlorg.Package.info package).Ocamlorg.Package.Info.description
    in
    let* readme =
      let+ readme_opt = Ocamlorg.Package.readme_file ~kind package in
      Option.value
        readme_opt
        ~default:(description |> Omd.of_string |> Omd.to_html)
    in
    let license = Ocamlorg.Package.license_file ~kind package in
    let* status = Ocamlorg.Package.status ~kind package in
    let content = Page_package.render ~readme ~license package in
    let versions =
      Ocamlorg.Package.get_package_versions name |> Option.value ~default:[]
    in
    Layout_package.render
      ~title:
        (Printf.sprintf
           "%s %s · OCaml Packages"
           (Ocamlorg.Package.Name.to_string name)
           (Ocamlorg.Package.Version.to_string version))
      ~description:
        (Printf.sprintf
           "%s %s: %s"
           (Ocamlorg.Package.Name.to_string name)
           (Ocamlorg.Package.Version.to_string version)
           description)
      ~package
      ~versions
      ~tab:Overview
      ~status
      content
    |> Dream.html

let package_doc kind req =
  let name = Ocamlorg.Package.Name.of_string @@ Dream.param "name" req in
  let version =
    Ocamlorg.Package.Version.of_string @@ Dream.param "version" req
  in
  let _kind =
    match kind with
    | Package ->
      Page_package.Blessed
    | Universe ->
      Page_package.Universe (Dream.param "hash" req)
  in
  let package = Ocamlorg.Package.get_package name version in
  match package with
  | None ->
    not_found req
  | Some package ->
    let open Lwt.Syntax in
    let kind =
      match kind with
      | Package ->
        `Package
      | Universe ->
        `Universe (Dream.param "hash" req)
    in
    let path = Dream.path req |> String.concat "/" in
    let* docs = Ocamlorg.Package.documentation_page ~kind package path in
    let* status = Ocamlorg.Package.status ~kind package in
    (match docs with
    | None ->
      not_found req
    | Some doc ->
      let description =
        (Ocamlorg.Package.info package).Ocamlorg.Package.Info.description
      in
      let versions =
        Ocamlorg.Package.get_package_versions name |> Option.value ~default:[]
      in
      let extra_nav = Component_package_doc_header.render doc.module_path in
      let canonical_module =
        doc.module_path
        |> List.map (function
               | Ocamlorg.Package.Documentation.Module s ->
                 s
               | Ocamlorg.Package.Documentation.ModuleType s ->
                 s
               | Ocamlorg.Package.Documentation.FunctorArgument (_, s) ->
                 s)
        |> String.concat "."
      in
      let title =
        match path with
        | "index.html" ->
          Printf.sprintf
            "Documentation · %s %s · OCaml Packages"
            (Ocamlorg.Package.Name.to_string name)
            (Ocamlorg.Package.Version.to_string version)
        | _ ->
          Printf.sprintf
            "%s · %s %s · OCaml Packages"
            canonical_module
            (Ocamlorg.Package.Name.to_string name)
            (Ocamlorg.Package.Version.to_string version)
      in
      Layout_package.render
        ~title
        ~description:
          (Printf.sprintf
             "%s %s: %s"
             (Ocamlorg.Package.Name.to_string name)
             (Ocamlorg.Package.Version.to_string version)
             description)
        ~versions
        ~tab:Documentation
        ~status
        ~package
        ~extra_nav
        (Page_package_doc.render doc)
      |> Dream.html)

let preview _req =
  Layout_page.render
    ~title:"Preview"
    ~description:Config.meta_description
    Preview_index.render
  |> Dream.html

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let preview_tutorials _req =
  Layout_page.render
    ~title:"OCaml Tutorials · Learn OCaml by topic"
    ~description:
      "Start learning the OCaml language by topic with out official tutorial."
    Preview_tutorials.render
  |> Dream.html

let preview_tutorial req =
  let slug = Dream.param "id" req in
  match
    List.find_opt
      (fun x -> slugify x.Ood.Tutorial.title = slug)
      Ood.Tutorial.all
  with
  | Some tutorial ->
    Layout_page.render
      ~title:(Printf.sprintf "%s · OCaml Tutorials" tutorial.Ood.Tutorial.title)
      ~description:tutorial.Ood.Tutorial.description
      (Preview_tutorial.render
         (fun x -> slugify x.Ood.Tutorial.title)
         Ood.Tutorial.all
         tutorial)
    |> Dream.html
  | None ->
    Dream.not_found req
