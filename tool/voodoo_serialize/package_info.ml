module Kind = struct
  type t =
    [ `Module
    | `Page
    | `LeafPage
    | `ModuleType
    | `Parameter of int
    | `Class
    | `ClassType
    | `File ]

  let to_string = function
    | `Page -> "page"
    | `Module -> "module"
    | `LeafPage -> "leaf-page"
    | `ModuleType -> "module-type"
    | `Parameter arg_num -> Printf.sprintf "argument-%d" arg_num
    | `Class -> "class"
    | `ClassType -> "class-type"
    | `File -> "file"

  let of_string = function
    | "page" -> `Page
    | "module" -> `Module
    | "leaf-page" -> `LeafPage
    | "module-type" -> `ModuleType
    | "class" -> `Class
    | "class-type" -> `ClassType
    | "file" -> `File
    | s when String.length s > 9 && String.sub s 0 9 = "argument-" ->
        let i = String.sub s 9 (String.length s - 9) in
        `Parameter (int_of_string i)
    | s ->
        raise (Invalid_argument (Format.sprintf "Variant not supported: %s" s))

  let equal x y = to_string x = to_string y
  let pp fs x = Format.fprintf fs "%s" (to_string x)
  let of_yojson json = json |> Yojson.Safe.Util.to_string |> of_string
  let to_yojson x = `String (to_string x)
end

module Module = struct
  type t = { name : string; submodules : t list; kind : Kind.t }

  let rec equal x y =
    x.name = y.name && Kind.equal x.kind y.kind
    && Util.list_equal equal x.submodules y.submodules

  let rec pp fs x =
    Format.fprintf fs "(name:%S) (submodules:%a) (kind:%a)" x.name
      (Format.pp_print_list pp) x.submodules Kind.pp x.kind

  let rec of_yojson json =
    let open Yojson.Safe.Util in
    let name = json |> member "name" |> to_string in
    let submodules =
      json |> member "submodules" |> to_list |> List.map of_yojson
    in
    (* [Invalid_argument] is not caught on purpose. *)
    let kind = json |> member "kind" |> Kind.of_yojson in
    { name; submodules; kind }

  let rec to_yojson { name; kind; submodules } =
    let name = ("name", `String name) in
    let submodules = ("submodules", `List (List.map to_yojson submodules)) in
    let kind = ("kind", Kind.to_yojson kind) in
    `Assoc [ name; submodules; kind ]
end

module Library = struct
  type 'a t = { name : string; modules : 'a list; dependencies : string list }

  let equal f x y =
    x.name = y.name
    && Util.list_equal f x.modules y.modules
    && Util.list_equal ( = ) x.dependencies y.dependencies

  let pp f fs x =
    Format.fprintf fs "(name:%S) (modules:%a) (dependencies:%a)" x.name
      (Format.pp_print_list f) x.modules
      (Format.pp_print_list Format.pp_print_string)
      x.dependencies

  let of_yojson f json =
    let open Yojson.Safe.Util in
    let name = json |> member "name" |> to_string in
    let modules = json |> member "modules" |> to_list |> List.map f in
    let dependencies =
      try json |> member "dependencies" |> to_list |> List.map to_string
      with Type_error _ -> []
    in
    { name; modules; dependencies }

  let to_yojson f { name; modules; dependencies } =
    let list_string v = `List (List.map (fun m -> `String m) v) in
    let name = ("name", `String name) in
    let modules = ("modules", `List (List.map f modules)) in
    let dependencies = [ ("dependencies", list_string dependencies) ] in
    `Assoc (name :: modules :: dependencies)
end

type 'a t = { libraries : 'a Library.t list }

let equal f x y = Util.list_equal (Library.equal f) x.libraries y.libraries

let pp f fs x =
  Format.fprintf fs "(libraries:%a)"
    (Format.pp_print_list (Library.pp f))
    x.libraries

let of_yojson f json =
  let open Yojson.Safe.Util in
  let libraries =
    json |> member "libraries" |> to_list |> List.map (Library.of_yojson f)
  in
  { libraries }

let to_yojson f { libraries } =
  `Assoc [ ("libraries", `List (List.map (Library.to_yojson f) libraries)) ]
