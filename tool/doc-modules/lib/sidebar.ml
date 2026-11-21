(* Module paths of an odoc sidebar.json.

   A path is the chain of module and module type names from the root of the
   sidebar tree; library headers and pages add no segment, and source trees are
   skipped. Only paths of valid OCaml module names are kept
   (Doc_modules_jsonl.is_module_name), at most [max_depth] deep and [max_paths]
   per package, shallowest first, then alphabetically. *)

let not_a_sidebar = Error "not a sidebar"

(* Every path of the tree, as lists of segments, in document order. *)
let rec paths prefix nodes acc =
  List.fold_left
    (fun acc node ->
      match acc with
      | Error _ -> acc
      | Ok acc -> (
          match node with
          | `Assoc fields -> (
              let kind, content =
                match List.assoc_opt "node" fields with
                | Some (`Assoc n) ->
                    (List.assoc_opt "kind" n, List.assoc_opt "content" n)
                | _ -> (None, None)
              in
              let children =
                match List.assoc_opt "children" fields with
                | Some (`List l) -> Ok l
                | None | Some `Null -> Ok []
                | Some _ -> not_a_sidebar
              in
              let here =
                match (kind, content) with
                | Some (`String ("module" | "module-type")), Some (`String c) ->
                    Ok (Some (prefix @ [ c ]))
                | Some (`String ("module" | "module-type")), _ -> not_a_sidebar
                | _ -> Ok None
              in
              match (here, children) with
              | Error e, _ | _, Error e -> Error e
              | Ok here, Ok children -> (
                  let acc =
                    match here with Some p -> p :: acc | None -> acc
                  in
                  let prefix = Option.value here ~default:prefix in
                  match kind with
                  | Some (`String "source") -> Ok acc
                  | _ -> paths prefix children (Ok acc)))
          | _ -> not_a_sidebar))
    acc nodes

let modules ~max_depth ~max_paths json =
  match json with
  | `List (_ :: _ as nodes) -> (
      match paths [] nodes (Ok []) with
      | Error e -> Error e
      | Ok all ->
          let kept =
            List.filter
              (fun p ->
                List.length p <= max_depth
                && List.for_all Doc_modules_jsonl.is_module_name p)
              all
            |> List.map (String.concat ".")
            |> List.sort_uniq String.compare
            |> List.stable_sort (fun a b ->
                Int.compare
                  (List.length (String.split_on_char '.' a))
                  (List.length (String.split_on_char '.' b)))
          in
          Ok (List.filteri (fun i _ -> i < max_paths) kept))
  | _ -> not_a_sidebar

(* [Error] for anything that is not a non-empty JSON array of sidebar nodes (an
   empty or garbled response); [Ok []] for a sidebar without modules. *)
let of_string ~max_depth ~max_paths s =
  match Yojson.Safe.from_string s with
  | exception Yojson.Json_error _ -> not_a_sidebar
  | json -> modules ~max_depth ~max_paths json
