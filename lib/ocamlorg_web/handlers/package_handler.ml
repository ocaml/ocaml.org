type kind =
  | Package
  | Universe

let index _req =
  Layout_template.render ~title:"Packages" Packages_template.render
  |> Dream.html

let search _req =
  let open Lwt.Syntax in
  let* packages =
    let+ packages = Ocamlorg.State.all_packages_latest () in
    OpamPackage.Name.Map.bindings packages
  in
  Layout_template.render
    ~title:"Packages"
    (Package_search_template.render packages)
  |> Dream.html

let package req =
  let open Lwt.Syntax in
  let package = Dream.param "name" req in
  let find_default_version name =
    let+ versions = Ocamlorg.State.get_package_opt name in
    Option.map
      (fun versions -> OpamPackage.Version.Map.max_binding versions |> fst)
      versions
  in
  let name =
    try OpamPackage.Name.of_string package with
    | Failure _ ->
      OpamPackage.Name.of_string "non-existent-package"
  in
  let* version = find_default_version name in
  match version with
  | Some version ->
    let target =
      "/p/" ^ package ^ "/" ^ OpamPackage.Version.to_string version
    in
    Dream.redirect req target
  | None ->
    Dream.not_found req

let package_versioned kind req =
  let open Lwt.Syntax in
  let package = Dream.param "name" req in
  let version = Dream.param "version" req in
  let name =
    try OpamPackage.Name.of_string package with
    | Failure _ ->
      OpamPackage.Name.of_string "non-existent-package"
  in
  let version =
    try OpamPackage.Version.of_string version with
    | Failure _ ->
      OpamPackage.Version.of_string "0"
  in
  let kind =
    match kind with
    | Package ->
      Package_template.Blessed
    | Universe ->
      Package_template.Universe (Dream.param "hash" req)
  in
  let* content = Package_template.render ~kind ~name ~version ~path:"" () in
  try Layout_template.render ~title:"Packages" content |> Dream.html with
  | Not_found ->
    Dream.not_found req
  | Failure _ ->
    Dream.not_found req

let package_docs_index _req = Dream.empty `OK

let package_docs _req = Dream.empty `OK
