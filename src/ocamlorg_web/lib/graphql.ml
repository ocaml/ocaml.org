module Package = Ocamlorg_package

type package_info = { name : string; constraints : string option }
type packages_success = { total_packages : int; packages : Package.t list }
type packages_result = (packages_success, [ `Msg of string ]) result
type package_success = { package : Package.t }
type package_result = (package_success, [ `Msg of string ]) result
type params_validity = Valid_params | Wrong_limit | Wrong_offset

let get_info info =
  List.map
    (fun (name, constraints) ->
      { name = Package.Name.to_string name; constraints })
    info

let is_in_range current_version from_version upto_version =
  match (from_version, upto_version) with
  | None, None -> true
  | Some from_version, None ->
      Package.Version.compare current_version from_version >= 0
  | None, Some upto_version ->
      Package.Version.compare upto_version current_version >= 0
  | Some from_version, Some upto_version ->
      Package.Version.compare current_version from_version >= 0
      && Package.Version.compare upto_version current_version >= 0

let is_valid_params limit offset total_packages =
  if limit < 1 then Wrong_limit
  else if offset < 0 || offset > total_packages - 1 then Wrong_offset
  else Valid_params

let packages_list ?contains offset limit all_packages t =
  match contains with
  | None ->
      List.filteri (fun i _ -> offset <= i && i < offset + limit) all_packages
  | Some letters ->
      List.filteri
        (fun i _ -> offset <= i && i < offset + limit)
        (Package.search_package t letters)

let all_packages_result ?contains offset limit t =
  let all_packages = Package.all_packages_latest t in
  let total_packages = List.length all_packages in
  let limit = match limit with None -> total_packages | Some limit -> limit in
  let result = is_valid_params limit offset total_packages in
  match result with
  | Wrong_offset ->
      Error
        ("offset must be greater than or equal to 0 AND less than or equal to "
        ^ string_of_int (total_packages - 1))
  | Wrong_limit -> Error "limit must be greater than or equal to 1"
  | _ ->
      let packages = packages_list ?contains offset limit all_packages t in
      Ok { total_packages; packages }

let package_result name version t =
  match version with
  | None -> (
      let package =
        Package.get_package_latest t (Package.Name.of_string name)
      in
      match package with
      | None -> Error ("No package matching " ^ name ^ " was found")
      | Some package -> Ok package)
  | Some version -> (
      let package =
        Package.get_package t
          (Package.Name.of_string name)
          (Package.Version.of_string version)
      in
      match package with
      | None ->
          Error ("No package matching " ^ name ^ ": " ^ version ^ " was found")
      | Some package -> Ok package)

let package_versions_result name from upto t =
  let all_packages = Package.all_packages_latest t in
  let total_packages = List.length all_packages in
  let packages =
    Package.get_packages_with_name t (Package.Name.of_string name)
  in
  match packages with
  | None -> Error ("No package matching " ^ name ^ " was found")
  | Some packages ->
      if from = None && upto = None then Ok { total_packages; packages }
      else
        let package_list =
          List.filter
            (fun package ->
              is_in_range (Package.version package)
                (Option.map Package.Version.of_string from)
                (Option.map Package.Version.of_string upto))
            packages
        in
        Ok { total_packages; packages = package_list }

let info =
  Graphql_lwt.Schema.(
    obj "info"
      ~fields:
        [
          field "name" ~doc:"Unique dependency name"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ i -> i.name);
          field "constraints" ~doc:"Dependency constraints"
            ~args:Arg.[]
            ~typ:string
            ~resolve:(fun _ (i : package_info) -> i.constraints);
        ])

let owners =
  Graphql_lwt.Schema.(
    obj "owners"
      ~fields:
        [
          field "name" ~doc:"Owner's name"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ user -> user.Ood.Opam_user.name);
          field "email" ~doc:"Owner's email"
            ~args:Arg.[]
            ~typ:string
            ~resolve:(fun _ user -> user.Ood.Opam_user.email);
          field "githubUsername" ~doc:"Owner's GitHub username"
            ~args:Arg.[]
            ~typ:string
            ~resolve:(fun _ user -> user.Ood.Opam_user.github_username);
          field "avatar" ~doc:"Owner's avatar image URL"
            ~args:Arg.[]
            ~typ:string
            ~resolve:(fun _ user -> user.Ood.Opam_user.avatar);
        ])

let url =
  Graphql_lwt.Schema.(
    obj "url"
      ~fields:
        [
          field "uri" ~doc:"Package URI"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p -> p.Package.Info.uri);
          field "checksum" ~doc:"Package checksum"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null string)))
            ~resolve:(fun _ p -> p.Package.Info.checksum);
        ])

let package =
  Graphql_lwt.Schema.(
    obj "package"
      ~fields:
        [
          field "name" ~doc:"Unique package name"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p -> Package.Name.to_string (Package.name p));
          field "version" ~doc:"Package latest release version"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p -> Package.Version.to_string (Package.version p));
          field "synopsis" ~doc:"The synopsis of the package"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.synopsis);
          field "description" ~doc:"The description of the package"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.description);
          field "license" ~doc:"The license of the package"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.license);
          field "homepage" ~doc:"The homepage of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null string)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.homepage);
          field "tags" ~doc:"The tags of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null string)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.tags);
          field "authors" ~doc:"The authors of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null owners)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.authors);
          field "maintainers" ~doc:"The maintainers of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null owners)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.maintainers);
          field "dependencies" ~doc:"The dependencies of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null info)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              get_info info.Package.Info.dependencies);
          field "reverseDependencies" ~doc:"The dependencies of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null info)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.rev_deps
              |> List.map (fun (name, cstr, _version) -> (name, cstr))
              |> get_info);
          field "optionalDependencies"
            ~doc:"The optional dependencies of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null info)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              get_info info.Package.Info.depopts);
          field "conflicts" ~doc:"The conflicts of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null info)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              get_info info.Package.Info.conflicts);
          field "url" ~doc:"The url of the package"
            ~args:Arg.[]
            ~typ:url
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.url);
          field "publication"
            ~doc:"The timestamp of the publication date of the package"
            ~args:Arg.[]
            ~typ:(non_null float)
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.publication);
        ])

let packages_result =
  Graphql_lwt.Schema.(
    obj "allPackages"
      ~fields:
        [
          field "totalPackages" ~doc:"total number of packages"
            ~args:Arg.[]
            ~typ:(non_null int)
            ~resolve:(fun _ p -> p.total_packages);
          field "packages" ~doc:"list of all packages"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null package)))
            ~resolve:(fun _ p -> p.packages);
        ])

let schema t : Dream.request Graphql_lwt.Schema.schema =
  Graphql_lwt.Schema.(
    schema
      [
        io_field "allPackages" ~typ:(non_null packages_result)
          ~doc:
            "Filter packages by name passing search query. Packages can also \
             be paginated by setting the offset and limit as desired"
          ~args:
            Arg.
              [
                arg
                  ~doc:
                    "Filter packages by passing a search query which lists out \
                     all packages that contain the search query if any"
                  "contains" ~typ:string;
                arg'
                  ~doc:
                    "Specifies at what index packages can start, set to 0 by \
                     default which means start from the first package"
                  "offset" ~typ:int ~default:(`Int 0);
                arg
                  ~doc:
                    "Specifies the limit which means the number of packages \
                     you want to return if you do not want all packages \
                     returned at once. By default, all the packages are \
                     returned"
                  "limit" ~typ:int;
              ]
          ~resolve:(fun _ () contains offset limit ->
            Lwt.return (all_packages_result ?contains offset limit t));
        io_field "package" ~typ:(non_null package)
          ~doc:
            "Returns details of a specified package. It returns the latest \
             version if no version is specifed or returns a particular version \
             of the package if it is specified"
          ~args:
            Arg.
              [
                arg ~doc:"Get a single package by name" "name"
                  ~typ:(non_null string);
                arg ~doc:"Get a single package by version" "version" ~typ:string;
              ]
          ~resolve:(fun _ () name version ->
            Lwt.return (package_result name version t));
        io_field "packgeByVersions" ~typ:(non_null packages_result)
          ~doc:
            "Returns the list of package versions that falls within two \
             specified version ranges or all versions of the package name if \
             range(s) is not specified"
          ~args:
            Arg.
              [
                arg ~doc:"Returns the details of specified package name" "name"
                  ~typ:(non_null string);
                arg ~doc:"Specifies from which version of the package needed"
                  "from" ~typ:string;
                arg ~doc:"Specifies the last version of the package needed"
                  "upto" ~typ:string;
              ]
          ~resolve:(fun _ () name from upto ->
            Lwt.return (package_versions_result name from upto t));
      ])
