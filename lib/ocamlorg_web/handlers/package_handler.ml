type kind =
  | Package
  | Universe

let index _req =
  Page_layout_template.render ~title:"Packages" Packages_template.render
  |> Dream.html

let search req =
  match Dream.query "q" req with
  | Some search ->
    let packages = Ocamlorg.Package.search_package search in
    Page_layout_template.render
      ~title:"Packages"
      (Package_search_template.render packages)
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
    Page_handler.not_found req

let package_versioned kind req =
  let name = Ocamlorg.Package.Name.of_string @@ Dream.param "name" req in
  let version =
    Ocamlorg.Package.Version.of_string @@ Dream.param "version" req
  in
  let package = Ocamlorg.Package.get_package name version in
  match package with
  | None ->
    Page_handler.not_found req
  | Some package ->
    let open Lwt.Syntax in
    let kind =
      match kind with
      | Package ->
        `Package
      | Universe ->
        `Universe (Dream.param "hash" req)
    in
    let* readme =
      let+ readme_opt = Ocamlorg.Package.readme_file ~kind package in
      Option.value
        readme_opt
        ~default:
          ((Ocamlorg.Package.info package).Ocamlorg.Package.Info.description
          |> Omd.of_string
          |> Omd.to_html)
    in
    let license = Ocamlorg.Package.license_file ~kind package in
    let* status = Ocamlorg.Package.status ~kind package in
    let content = Package_template.render ~readme ~license package in
    let versions =
      Ocamlorg.Package.get_package_versions name |> Option.value ~default:[]
    in
    let toplevel = Ocamlorg.Package.toplevel package in
    Package_layout_template.render
      ~title:"Packages"
      ~package
      ~versions
      ~tab:Overview
      ~status
      ?toplevel
      content
    |> Dream.html

let package_doc kind req =
  let name = Ocamlorg.Package.Name.of_string @@ Dream.param "name" req in
  let version =
    Ocamlorg.Package.Version.of_string @@ Dream.param "version" req
  in
  let package = Ocamlorg.Package.get_package name version in
  match package with
  | None ->
    Page_handler.not_found req
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
      Page_handler.not_found req
    | Some doc ->
      let versions =
        Ocamlorg.Package.get_package_versions name |> Option.value ~default:[]
      in
      let extra_nav = Package_doc_header_template.render doc.module_path in
      let toplevel = Ocamlorg.Package.toplevel package in
      Package_layout_template.render
        ~title:"Packages"
        ~package
        ~versions
        ~tab:Documentation
        ~status
        ~extra_nav
        ?toplevel
        (Package_doc_template.render doc)
      |> Dream.html)

let toplevel kind req =
  let name = Ocamlorg.Package.Name.of_string @@ Dream.param "name" req in
  let version =
    Ocamlorg.Package.Version.of_string @@ Dream.param "version" req
  in
  let package = Ocamlorg.Package.get_package name version in
  match package with
  | None ->
    Page_handler.not_found req
  | Some package ->
    let toplevel = Ocamlorg.Package.toplevel package in
    (match toplevel with
    | None ->
      Page_handler.not_found req
    | Some toplevel ->
      let kind =
        match kind with
        | Package ->
          `Package
        | Universe ->
          `Universe (Dream.param "hash" req)
      in
      let open Lwt.Syntax in
      let* status = Ocamlorg.Package.status ~kind package in
      let versions =
        Ocamlorg.Package.get_package_versions name |> Option.value ~default:[]
      in
      let content = Package_toplevel_template.render toplevel in
      Package_layout_template.render
        ~title:"Toplevel"
        ~package
        ~versions
        ~tab:Toplevel
        ~status
        ~toplevel
        content
      |> Dream.html)
