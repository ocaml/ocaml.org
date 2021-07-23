open Ocamlorg

let versionned_package =
  Graphql_lwt.Schema.(
    obj "versionned_package" ~fields:(fun _info ->
        [ field
            "name"
            ~typ:(non_null string)
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              Package.name package |> Package.Name.to_string)
        ; field
            "version"
            ~typ:(non_null string)
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              Package.version package |> Package.Version.to_string)
        ; field
            "synopsis"
            ~typ:(non_null string)
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              let info = Package.info package in
              info.Package.Info.synopsis)
        ; field
            "description"
            ~typ:(non_null string)
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              let info = Package.info package in
              info.Package.Info.description)
        ; field
            "authors"
            ~typ:(non_null (list (non_null string)))
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              let info = Package.info package in
              info.Package.Info.authors)
        ; field
            "license"
            ~typ:(non_null string)
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              let info = Package.info package in
              info.Package.Info.license)
        ; field
            "homepage"
            ~typ:(non_null (list (non_null string)))
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              let info = Package.info package in
              info.Package.Info.homepage)
        ; field
            "tags"
            ~typ:(non_null (list (non_null string)))
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              let info = Package.info package in
              info.Package.Info.tags)
        ; field
            "maintainers"
            ~typ:(non_null (list (non_null string)))
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              let info = Package.info package in
              info.Package.Info.maintainers)
        ]))

let package =
  Graphql_lwt.Schema.(
    obj "package" ~fields:(fun _info ->
        [ field
            "name"
            ~typ:(non_null string)
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              Package.name package |> Package.Name.to_string)
        ; field
            "versions"
            ~typ:(non_null (list (non_null versionned_package)))
            ~args:Arg.[]
            ~resolve:(fun _info package ->
              match Package.get_packages_with_name (Package.name package) with
              | Some v ->
                v
              | None ->
                [])
        ]))

let schema : Dream.request Graphql_lwt.Schema.schema =
  Graphql_lwt.Schema.(
    schema
      [ field
          "packages"
          ~typ:(non_null (list (non_null package)))
          ~args:Arg.[ arg "name" ~typ:string ]
          ~resolve:(fun _info () name ->
            let packages = Package.all_packages_latest () in
            match name with
            | None ->
              packages
            | Some name ->
              List.filter
                (fun x -> Package.name x |> Package.Name.to_string = name)
                packages)
      ])

let default_query = "{\\n  packages {\\n    name\\n    version\\n  }\\n}\\n"
