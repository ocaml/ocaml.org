open Import

module Kind = struct
  type t =
    | Module
    | Page
    | LeafPage
    | ModuleType
    | Parameter of int
    | Class
    | ClassType
    | File

  let prefix = function
    | ModuleType -> "module-type-"
    | Parameter i -> "argument-" ^ Int.to_string i ^ "-"
    | Class -> "class-"
    | ClassType -> "class-type-"
    | _ -> ""

  let of_kind = function
    | `Module -> Module
    | `Page -> Page
    | `LeafPage -> LeafPage
    | `ModuleType -> ModuleType
    | `Parameter i -> Parameter i
    | `Class -> Class
    | `ClassType -> ClassType
    | `File -> File
end

module Module = struct
  type t = {
    name : string;
    kind : Kind.t;
    mutable submodules : t String.Map.t;
    parent : t option;
  }

  let name t = t.name
  let kind t = t.kind
  let submodules t = t.submodules
  let parent t = t.parent

  let path v =
    let rec aux acc v =
      let item = Kind.prefix v.kind ^ v.name in
      match v.parent with
      | None -> item :: acc
      | Some parent -> aux (item :: acc) parent
    in
    aux [ "index.html" ] v |> String.concat "/"
end

type library = {
  name : string;
  dependencies : string list;
  modules : Module.t String.Map.t;
}

type t = { libraries : library String.Map.t }

let rec of_module ?parent (v : Voodoo_serialize.Package_info.Module.t) :
    Module.t =
  let name = v.name in
  let kind = Kind.of_kind v.kind in
  let module' = { Module.name; kind; parent; submodules = String.Map.empty } in
  let submodules =
    v.submodules |> List.to_seq
    |> Seq.map (fun v ->
           let submodule = of_module ~parent:module' v in
           (submodule.name, submodule))
    |> String.Map.of_seq
  in
  module'.submodules <- submodules;
  module'

let of_library
    (l :
      Voodoo_serialize.Package_info.Module.t
      Voodoo_serialize.Package_info.Library.t) : library =
  let modules : Module.t String.Map.t =
    List.map of_module l.modules
    |> List.to_seq
    |> Seq.map (fun (m : Module.t) -> (m.name, m))
    |> String.Map.of_seq
  in
  { name = l.name; dependencies = l.dependencies; modules }

let of_yojson (v : Yojson.Safe.t) : t =
  let package_info :
      Voodoo_serialize.Package_info.Module.t Voodoo_serialize.Package_info.t =
    Voodoo_serialize.Package_info.of_yojson
      Voodoo_serialize.Package_info.Module.of_yojson v
  in
  let libraries = List.map of_library package_info.libraries in
  let libraries =
    libraries |> List.to_seq
    |> Seq.map (fun lib -> (lib.name, lib))
    |> String.Map.of_seq
  in
  { libraries }
