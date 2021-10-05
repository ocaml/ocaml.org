open Std
module Name = OpamPackage.Name
module Name_map = Map.Make (Name)
module Version = OpamPackage.Version
module Version_map = Map.Make (Version)

module Info = struct
  type url =
    { uri : string
    ; checksum : string list
    }

  type t =
    { synopsis : string
    ; description : string
    ; authors : Opam_user.t list
    ; maintainers : Opam_user.t list
    ; license : string
    ; homepage : string list
    ; tags : string list
    ; dependencies : (OpamPackage.Name.t * string option) list
    ; rev_deps : (OpamPackage.Name.t * string option) list
    ; depopts : (OpamPackage.Name.t * string option) list
    ; conflicts : (OpamPackage.Name.t * string option) list
    ; url : url option
    }

  let relop_to_string = OpamPrinter.FullPos.relop_kind

  let filter_to_string = OpamFilter.to_string

  let string_of_formula = function
    | OpamFormula.Empty ->
      None
    | formula ->
      Some
        (OpamFormula.string_of_formula
           (function
             | OpamTypes.Filter f ->
               filter_to_string f
             | Constraint (relop, f) ->
               relop_to_string relop ^ " " ^ filter_to_string f)
           formula)

  let parse_formula =
    OpamFormula.fold_left
      (fun lst (name, cstr) -> (name, string_of_formula cstr) :: lst)
      []

  let depends packages opams f =
    let open OpamTypes in
    OpamPackage.Name.Map.fold
      (fun name vmap acc ->
        let v =
          OpamPackage.Version.Map.fold
            (fun version opam acc ->
              let env v =
                match OpamVariable.Full.to_string v with
                | "name" ->
                  Some (S (OpamPackage.Name.to_string name))
                | "version" ->
                  Some (S (OpamPackage.Version.to_string version))
                | _ ->
                  None
              in
              let deps =
                OpamFormula.packages packages
                @@ OpamFilter.filter_formula ~default:true env (f opam)
              in
              OpamPackage.Map.add (OpamPackage.create name version) deps acc)
            vmap
            OpamPackage.Map.empty
        in
        OpamPackage.Map.union (fun a _ -> a) acc v)
      opams
      OpamPackage.Map.empty

  let _get_conflict_set pkgs map =
    let f opam = OpamFile.OPAM.conflicts opam in
    depends pkgs map f

  let get_dependency_set pkgs map =
    let f opam = OpamFile.OPAM.depends opam in
    depends pkgs map f

  let _get_depopts_set pkgs map =
    let f opam = OpamFile.OPAM.depopts opam in
    depends pkgs map f

  let get_conflicts (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.conflicts opam in
    parse_formula data

  let get_dependencies (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.depends opam in
    parse_formula data

  let get_depopts (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.depopts opam in
    parse_formula data

  let rev_depends deps =
    OpamPackage.Map.fold
      (fun pkg ->
        OpamPackage.Set.fold (fun pkg1 ->
            OpamPackage.Map.update
              pkg1
              (OpamPackage.Set.add pkg)
              OpamPackage.Set.empty))
      deps
      OpamPackage.Map.empty

  let mk_revdeps pkg pkgs rdepends =
    let open OpamTypes in
    OpamPackage.Name.Map.fold
      (fun name versions acc ->
        let vf =
          OpamFormula.formula_of_version_set
            (OpamPackage.versions_of_name pkgs name)
            versions
        in
        let _latest =
          OpamPackage.create name (OpamPackage.Version.Set.max_elt versions)
        in
        let flags = OpamStd.String.Set.empty in
        let formula =
          OpamFormula.ands
          @@ List.rev_append
               (List.rev_map
                  (fun flag ->
                    Atom
                      (Filter (FIdent ([], OpamVariable.of_string flag, None))))
                  (OpamStd.String.Set.elements flags))
               [ OpamFormula.map
                   (fun (op, v) ->
                     Atom
                       (Constraint
                          (op, FString (OpamPackage.Version.to_string v))))
                   vf
               ]
        in
        (name, string_of_formula formula) :: acc)
      (OpamPackage.to_map
      @@ OpamStd.Option.default OpamPackage.Set.empty
      @@ OpamPackage.Map.find_opt pkg rdepends)
      []
    |> List.rev

  let of_opamfiles
      (opams : OpamFile.OPAM.t OpamPackage.Version.Map.t OpamPackage.Name.Map.t)
    =
    let open OpamFile.OPAM in
    let packages =
      let names = OpamPackage.Name.Map.keys opams in
      let f acc name =
        let versions =
          OpamPackage.Version.Map.keys (OpamPackage.Name.Map.find name opams)
        in
        let pkgs =
          List.fold_left
            (fun acc v -> OpamPackage.Set.add (OpamPackage.create name v) acc)
            OpamPackage.Set.empty
            versions
        in
        OpamPackage.Set.union pkgs acc
      in
      List.fold_left f OpamPackage.Set.empty names
    in
    let dependencies = get_dependency_set packages opams in
    let rev_deps = rev_depends dependencies in
    OpamPackage.Name.Map.fold
      (fun name vmap acc ->
        let vs =
          OpamPackage.Version.Map.fold
            (fun version opam acc ->
              let package = OpamPackage.create name version in
              let opam_file =
                OpamPackage.Name.Map.find name opams
                |> OpamPackage.Version.Map.find version
              in
              let t =
                { synopsis =
                    synopsis opam |> Option.value ~default:"No synopsis"
                ; authors =
                    author opam
                    |> List.map (fun name ->
                           Option.value
                             (Opam_user.find_by_name name)
                             ~default:(Opam_user.make ~name ()))
                ; maintainers =
                    maintainer opam
                    |> List.map (fun name ->
                           Option.value
                             (Opam_user.find_by_name name)
                             ~default:(Opam_user.make ~name ()))
                ; license = license opam |> String.concat "; "
                ; description =
                    descr opam
                    |> Option.map OpamFile.Descr.body
                    |> Option.value ~default:""
                ; homepage = homepage opam
                ; tags = tags opam
                ; rev_deps = mk_revdeps package packages rev_deps
                ; conflicts = get_conflicts opam_file
                ; dependencies = get_dependencies opam_file
                ; depopts = get_depopts opam_file
                ; url =
                    url opam
                    |> Option.map (fun url ->
                           { uri = OpamUrl.to_string (OpamFile.URL.url url)
                           ; checksum =
                               OpamFile.URL.checksum url
                               |> List.map OpamHash.to_string
                           })
                }
              in
              OpamPackage.Version.Map.add version t acc)
            vmap
            OpamPackage.Version.Map.empty
        in
        OpamPackage.Name.Map.add name vs acc)
      opams
      OpamPackage.Name.Map.empty
end

type t =
  { name : Name.t
  ; version : Version.t
  ; info : Info.t
  }

let name t = t.name

let version t = t.version

let info t = t.info

let create ~name ~version info = { name; version; info }

type state =
  { mutable packages : Info.t OpamPackage.Version.Map.t OpamPackage.Name.Map.t }

let get_state { packages } = packages

let state_of_package_list (pkgs : t list) =
  let map = OpamPackage.Name.Map.empty in
  let add_version (pkg : t) map =
    let new_map =
      match OpamPackage.Name.Map.find_opt pkg.name map with
      | None ->
        OpamPackage.Version.Map.(add pkg.version pkg.info empty)
      | Some version_map ->
        OpamPackage.Version.Map.add pkg.version pkg.info version_map
    in
    OpamPackage.Name.Map.add pkg.name new_map map
  in
  { packages = List.fold_left (fun map v -> add_version v map) map pkgs }

let read_versions package_name =
  let versions = Opam_repository.list_package_versions package_name in
  List.fold_left
    (fun acc package_version ->
      match OpamPackage.of_string_opt package_version with
      | Some pkg ->
        let opam = Opam_repository.opam_file package_name package_version in
        OpamPackage.Version.Map.add pkg.version opam acc
      | None ->
        Logs.err (fun m -> m "Invalid pacakge version %S" package_name);
        acc)
    OpamPackage.Version.Map.empty
    versions

let read_packages () =
  List.fold_left
    (fun acc package_name ->
      match OpamPackage.Name.of_string package_name with
      | exception ex ->
        Logs.err (fun m ->
            m "Invalid package name %S: %s" package_name (Printexc.to_string ex));
        acc
      | _name ->
        let versions = read_versions package_name in
        OpamPackage.Name.Map.add (Name.of_string package_name) versions acc)
    OpamPackage.Name.Map.empty
    (Opam_repository.list_packages ())

let update t =
  Logs.info (fun f -> f "Calculating packages...");
  let packages = read_packages () in
  let packages = Info.of_opamfiles packages in
  t.packages <- packages;
  Logs.info (fun m ->
      m "Loaded %d packages" (OpamPackage.Name.Map.cardinal packages))

let poll_for_opam_packages ~polling v =
  let open Lwt.Syntax in
  let* () = Opam_repository.clone () in
  let last_commit = ref None in
  let rec updater () =
    let* () =
      Lwt.catch
        (fun () ->
          let* () = Opam_repository.pull () in
          let+ commit = Opam_repository.last_commit () in
          if Some commit <> !last_commit then (
            Logs.info (fun m -> m "Updating opam package list");
            let () = update v in
            last_commit := Some commit))
        (fun exn ->
          Logs.err (fun m ->
              m
                "Failed to update the opam package list: %s"
                (Printexc.to_string exn));
          Lwt.return ())
    in
    let* () = Lwt_unix.sleep (float_of_int polling) in
    updater ()
  in
  updater ()

let s = { packages = OpamPackage.Name.Map.empty }

let init ?(disable_polling = false) () =
  if Sys.file_exists (Fpath.to_string Config.opam_repository_path) then
    update s;
  if disable_polling then
    ()
  else
    Lwt.async (fun () -> poll_for_opam_packages ~polling:Config.opam_polling s);
  s

let all_packages_latest t =
  t.packages
  |> OpamPackage.Name.Map.map OpamPackage.Version.Map.max_binding
  |> OpamPackage.Name.Map.bindings
  |> List.map (fun (name, (version, info)) -> { name; version; info })

let get_packages_with_name t name =
  t.packages
  |> OpamPackage.Name.Map.find_opt name
  |> Option.map OpamPackage.Version.Map.bindings
  |> Option.map (List.map (fun (version, info) -> { name; version; info }))

let get_package_versions t name =
  t.packages
  |> OpamPackage.Name.Map.find_opt name
  |> Option.map OpamPackage.Version.Map.bindings
  |> Option.map (List.map fst)

let get_package_latest t name =
  t.packages
  |> OpamPackage.Name.Map.find_opt name
  |> Option.map (fun versions ->
         let version, info = OpamPackage.Version.Map.max_binding versions in
         { version; info; name })

let get_package t name version =
  t.packages |> OpamPackage.Name.Map.find_opt name |> fun x ->
  Option.bind x (OpamPackage.Version.Map.find_opt version)
  |> Option.map (fun info -> { version; info; name })

let topelevel_url name version = "/toplevels/" ^ name ^ "-" ^ version ^ ".js"

let toplevel t =
  let name = Name.to_string t.name in
  let version = Version.to_string t.version in
  let path =
    Fpath.(to_string (Config.topelevels_path / (name ^ "-" ^ version ^ ".js")))
  in
  if Sys.file_exists path then
    Some (topelevel_url name version)
  else
    None

module Documentation = struct
  type toc =
    { title : string
    ; href : string
    ; children : toc list
    }

  type item =
    | Module of string
    | ModuleType of string
    | FunctorArgument of int * string

  type t =
    { toc : toc list
    ; module_path : item list
    ; content : string
    }

  let rec toc_of_json = function
    | `Assoc
        [ ("title", `String title)
        ; ("href", `String href)
        ; ("children", `List children)
        ] ->
      { title; href; children = List.map toc_of_json children }
    | _ ->
      raise (Invalid_argument "malformed toc file")

  let toc_from_string s =
    match Yojson.Safe.from_string s with
    | `List xs ->
      List.map toc_of_json xs
    | _ ->
      raise (Invalid_argument "the toplevel json is not a list")

  let module_path_from_path s =
    let parse_item i =
      match String.split_on_char '-' i with
      | [ "index.html" ] | [ "" ] ->
        None
      | [ module_name ] ->
        Some (Module module_name)
      | [ "module"; "type"; module_name ] ->
        Some (ModuleType module_name)
      | [ "argument"; arg_number; arg_name ] ->
        (try Some (FunctorArgument (int_of_string arg_number, arg_name)) with
        | Failure _ ->
          None)
      | _ ->
        None
    in
    String.split_on_char '/' s |> List.filter_map parse_item
end

module Module_map = Module_map

let package_path ~kind name version =
  match kind with
  | `Package ->
    Config.documentation_url ^ "p/" ^ name ^ "/" ^ version ^ "/"
  | `Universe s ->
    Config.documentation_url ^ "u/" ^ s ^ "/" ^ name ^ "/" ^ version ^ "/"

let documentation_path ~kind name version =
  match kind with
  | `Package ->
    Config.documentation_url ^ "p/" ^ name ^ "/" ^ version ^ "/doc" ^ "/"
  | `Universe s ->
    Config.documentation_url
    ^ "u/"
    ^ s
    ^ "/"
    ^ name
    ^ "/"
    ^ version
    ^ "/doc"
    ^ "/"

let http_get url =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "GET %s" url);
  let headers =
    Cohttp.Header.of_list
      [ ( "Accept"
        , "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" )
      ]
  in
  let* response, body =
    Cohttp_lwt_unix.Client.get ~headers (Uri.of_string url)
  in
  match Cohttp.Code.(code_of_status response.status |> is_success) with
  | true ->
    let+ body = Cohttp_lwt.Body.to_string body in
    Ok body
  | false ->
    Lwt.return (Error (`Msg "Failed to fetch the documentation page"))

let documentation_page ~kind t path =
  let open Lwt.Syntax in
  let root =
    documentation_path
      ~kind
      (Name.to_string t.name)
      (Version.to_string t.version)
  in
  let module_path = Documentation.module_path_from_path path in
  let path = root ^ path in
  let* content = http_get path in
  match content with
  | Ok content ->
    let+ toc =
      let toc_path = Filename.remove_extension path ^ ".toc.json" in
      let+ toc_content = http_get toc_path in
      match toc_content with
      | Ok toc_content ->
        (try Documentation.toc_from_string toc_content with
        | Invalid_argument err ->
          Logs.err (fun m -> m "Invalid toc: %s" err);
          [])
      | Error _ ->
        []
    in
    Logs.info (fun m -> m "Found documentation page for %s" path);
    Some Documentation.{ content; toc; module_path }
  | Error _ ->
    Lwt.return None

let readme_file ~kind t =
  let open Lwt.Syntax in
  let+ doc = documentation_page ~kind t "README.md.html" in
  match doc with None -> None | Some { content; _ } -> Some content

let license_file ~kind t =
  let open Lwt.Syntax in
  let+ doc = documentation_page ~kind t "LICENSE.md.html" in
  match doc with None -> None | Some { content; _ } -> Some content

let status ~kind t =
  let open Lwt.Syntax in
  let root =
    package_path ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let path = root ^ "status.json" in
  let+ content = http_get path in
  match content with
  | Ok "\"Built\"" ->
    `Success
  | Ok "\"Failed\"" ->
    `Failure
  | _ ->
    `Unknown

let module_map ~kind t =
  let open Lwt.Syntax in
  let root =
    package_path ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let path = root ^ "package.json" in
  let+ content = http_get path in
  match content with
  | Ok v ->
    let json = Yojson.Safe.from_string v in
    Module_map.of_yojson json
  | Error _ ->
    { Module_map.libraries = Module_map.String_map.empty }

let search_package t pattern =
  let pattern = String.lowercase_ascii pattern in
  let name_is_s { name; _ } =
    String.lowercase_ascii @@ Name.to_string name = pattern
  in
  let name_contains_s { name; _ } =
    String.contains_s (String.lowercase_ascii @@ Name.to_string name) pattern
  in
  let synopsis_contains_s { info; _ } =
    String.contains_s (String.lowercase_ascii info.synopsis) pattern
  in
  let description_contains_s { info; _ } =
    String.contains_s (String.lowercase_ascii info.description) pattern
  in
  let has_tag_s { info; _ } =
    List.exists
      (fun tag -> String.contains_s (String.lowercase_ascii tag) pattern)
      info.tags
  in
  let score package =
    if name_is_s package then
      -1
    else if name_contains_s package then
      0
    else if has_tag_s package then
      1
    else if synopsis_contains_s package then
      2
    else if description_contains_s package then
      3
    else
      failwith "impossible package score"
  in
  all_packages_latest t
  |> List.filter (fun p ->
         name_contains_s p
         || synopsis_contains_s p
         || description_contains_s p
         || has_tag_s p)
  |> List.sort (fun package1 package2 ->
         compare (score package1) (score package2))
