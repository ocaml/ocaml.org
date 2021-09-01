module StringMap = Map.Make (String)

type kind =
  | Module
  | Page
  | LeafPage
  | ModuleType
  | Argument
  | Class
  | ClassType
  | File

let prefix_of_kind = function
  | ModuleType ->
    "module-type-"
  | Argument ->
    "argument-"
  | Class ->
    "class-"
  | ClassType ->
    "class-type-"
  | _ ->
    ""

module Module = struct
  type t =
    { name : string
    ; kind : kind
    ; mutable submodules : t StringMap.t
    ; parent : t option
    }

  let name t = t.name

  let kind t = t.kind

  let submodules t = t.submodules

  let parent t = t.parent

  let path v =
    let rec aux acc v =
      let item = prefix_of_kind v.kind ^ v.name in
      match v.parent with
      | None ->
        item :: acc
      | Some parent ->
        aux (item :: acc) parent
    in
    aux [ "index.html" ] v |> String.concat "/"
end

type library =
  { name : string
  ; dependencies : string list
  ; modules : Module.t StringMap.t
  }

type t = { libraries : library StringMap.t }

open Yojson.Safe.Util

let kind_of_yojson v =
  match to_string v with
  | "page" ->
    Page
  | "module" ->
    Module
  | "leaf-page" ->
    LeafPage
  | "module-type" ->
    ModuleType
  | "argument" ->
    Argument
  | "class" ->
    Class
  | "class-type" ->
    ClassType
  | "file" ->
    File
  | _ ->
    raise (Type_error ("Variant not supported", v))

let rec module_of_yojson ?parent v : Module.t =
  let name = member "name" v |> to_string in
  let kind = member "kind" v |> kind_of_yojson in
  let module' = { Module.name; kind; parent; submodules = StringMap.empty } in
  let submodules =
    member "submodules" v
    |> to_list
    |> List.to_seq
    |> Seq.map (fun v ->
           let submodule = module_of_yojson ~parent:module' v in
           submodule.name, submodule)
    |> StringMap.of_seq
  in
  module'.submodules <- submodules;
  module'

let library_of_yojson v =
  let name = member "name" v |> to_string in
  let modules =
    member "modules" v
    |> to_list
    |> List.to_seq
    |> Seq.map (fun v ->
           let module' = module_of_yojson v in
           module'.name, module')
    |> StringMap.of_seq
  in
  let dependencies =
    match member "dependencies" v with
    | `Null ->
      []
    | `List l ->
      List.rev_map to_string l
    | v ->
      raise (Type_error ("Failed to parse dependencies field", v))
  in
  { name; modules; dependencies }

let of_yojson json =
  member "libraries" json
  |> to_list
  |> List.to_seq
  |> Seq.map (fun v ->
         let lib = library_of_yojson v in
         lib.name, lib)
  |> StringMap.of_seq
  |> fun libraries -> { libraries }
