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

  let get_conflicts (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.conflicts opam in
    parse_formula data

  let get_dependencies (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.depends opam in
    parse_formula data

  let get_depopts (opam : OpamFile.OPAM.t) =
    let data = OpamFile.OPAM.depopts opam in
    parse_formula data

  let of_opamfile (opam : OpamFile.OPAM.t) =
    let open OpamFile.OPAM in
    { synopsis = synopsis opam |> Option.value ~default:"No synopsis"
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
        descr opam |> Option.map OpamFile.Descr.body |> Option.value ~default:""
    ; homepage = homepage opam
    ; tags = tags opam
    ; conflicts = get_conflicts opam
    ; dependencies = get_dependencies opam
    ; depopts = get_depopts opam
    ; url =
        url opam
        |> Option.map (fun url ->
               { uri = OpamUrl.to_string (OpamFile.URL.url url)
               ; checksum =
                   OpamFile.URL.checksum url |> List.map OpamHash.to_string
               })
    }
end

type t =
  { name : Name.t
  ; version : Version.t
  ; info : Info.t lazy_t
  }

let name t = t.name

let version t = t.version

let info t = Lazy.force t.info

type state =
  { mutable packages :
      Info.t lazy_t OpamPackage.Version.Map.t OpamPackage.Name.Map.t
  }

let read_versions package_name =
  let versions = Opam_repository.list_package_versions package_name in
  List.fold_left
    (fun acc package_version ->
      match OpamPackage.of_string_opt package_version with
      | Some pkg ->
        let info =
          Lazy.from_fun (fun () ->
              Info.of_opamfile
              @@ Opam_repository.opam_file package_name package_version)
        in
        OpamPackage.Version.Map.add pkg.version info acc
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
  let packages = read_packages () in
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

let t =
  let v =
    (* Update at startup time if the directory exists so that the first page we
       query does not contain *)
    if Sys.file_exists (Fpath.to_string Config.opam_repository_path) then
      { packages = read_packages () }
    else
      { packages = OpamPackage.Name.Map.empty }
  in
  Lwt.async (fun () -> poll_for_opam_packages ~polling:Config.opam_polling v);
  v

let all_packages_latest () =
  t.packages
  |> OpamPackage.Name.Map.map OpamPackage.Version.Map.max_binding
  |> OpamPackage.Name.Map.bindings
  |> List.map (fun (name, (version, info)) -> { name; version; info })

let get_packages_with_name name =
  t.packages
  |> OpamPackage.Name.Map.find_opt name
  |> Option.map OpamPackage.Version.Map.bindings
  |> Option.map (List.map (fun (version, info) -> { name; version; info }))

let get_package_versions name =
  t.packages
  |> OpamPackage.Name.Map.find_opt name
  |> Option.map OpamPackage.Version.Map.bindings
  |> Option.map (List.map fst)

let get_package_latest name =
  t.packages
  |> OpamPackage.Name.Map.find_opt name
  |> Option.map (fun versions ->
         let version, info = OpamPackage.Version.Map.max_binding versions in
         { version; info; name })

let get_package name version =
  t.packages |> OpamPackage.Name.Map.find_opt name |> fun x ->
  Option.bind x (OpamPackage.Version.Map.find_opt version)
  |> Option.map (fun info -> { version; info; name })

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

let search_package pattern =
  let pattern = String.lowercase_ascii pattern in
  let contains s1 s2 =
    try
      let len = String.length s2 in
      for i = 0 to String.length s1 - len do
        if String.sub s1 i len = s2 then raise Exit
      done;
      false
    with
    | Exit ->
      true
  in
  all_packages_latest ()
  |> List.filter (fun { name; _ } ->
         if contains (String.lowercase_ascii @@ Name.to_string name) pattern
         then
           true
         else
           false)
