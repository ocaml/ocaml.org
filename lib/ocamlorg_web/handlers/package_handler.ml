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
    Dream.not_found req

let package_versioned kind req =
  let name = Ocamlorg.Package.Name.of_string @@ Dream.param "name" req in
  let version =
    Ocamlorg.Package.Version.of_string @@ Dream.param "version" req
  in
  let kind =
    match kind with
    | Package ->
      Package_template.Blessed
    | Universe ->
      Package_template.Universe (Dream.param "hash" req)
  in
  let package = Ocamlorg.Package.get_package name version in
  match package with
  | None ->
    Dream.not_found req
  | Some package ->
    let content = Package_template.render ~kind package in
    let versions =
      Ocamlorg.Package.get_package_versions name |> Option.value ~default:[]
    in
    Package_layout_template.render
      ~title:"Packages"
      ~package
      ~versions
      ~tab:Overview
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
      Package_template.Blessed
    | Universe ->
      Package_template.Universe (Dream.param "hash" req)
  in
  let package = Ocamlorg.Package.get_package name version in
  match package with
  | None ->
    Dream.not_found req
  | Some package ->
    let docs = Ocamlorg.Package.documentation package in
    let content = Hashtbl.find_opt docs (Dream.path req |> String.concat "/") in
    (match content with
    | None ->
      (* TODO: Replace with NOT FOUND *)
      let content =
        Hashtbl.to_seq docs
        |> List.of_seq
        |> List.map (fun (url, _) -> url)
        |> String.concat "<br />"
      in
      let content =
        Printf.sprintf
          "Path: %s<br />%s"
          (Dream.path req |> String.concat "/")
          content
      in
      let versions =
        Ocamlorg.Package.get_package_versions name |> Option.value ~default:[]
      in
      (* Dream.not_found req *)
      Package_layout_template.render
        ~title:"Packages"
        ~package
        ~versions
        ~tab:Documentation
        content
      |> Dream.html
    | Some content ->
      let versions =
        Ocamlorg.Package.get_package_versions name |> Option.value ~default:[]
      in
      Package_layout_template.render
        ~title:"Packages"
        ~package
        ~versions
        ~tab:Documentation
        content
      |> Dream.html)
