open Ocamlorg.Import

let ( let* ) = Result.bind
let ( <@> ) = Result.apply

let extract_metadata_body path s =
  let err =
    `Msg
      (Printf.sprintf "expected metadata at the top of the file %s. Got %s" path
         s)
  in
  let cut =
    let sep = "---\n" in
    let win_sep = "---\r\n" in
    let cut on s = Option.to_result ~none:err (String.cut ~on s) in
    Result.sequential_or (cut sep) (cut win_sep)
  in
  let* pre, post = cut s in
  let* () = if pre = "" then Ok () else Error err in
  let* yaml, body = cut post in
  let* yaml = Yaml.of_string yaml in
  Ok (yaml, body)

let read_from_dir dir =
  Data.file_list
  |> List.filter_map (fun x ->
         if String.starts_with ~prefix:dir x then
           Data.read x |> Option.map (fun y -> (x, y))
         else if Glob.matches_glob ~glob:dir x then
           Data.read x |> Option.map (fun y -> (x, y))
         else None)

let map_files f dir =
  let f (path, data) =
    let* metadata = extract_metadata_body path data in
    f (path, metadata)
  in
  read_from_dir dir
  |> List.fold_left (fun u x -> Ok List.cons <@> f x <@> u) (Ok [])
  |> Result.map List.rev
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let yaml_file file =
  let file_opt = Data.read file in
  let* file = Option.to_result ~none:(`Msg "file not found") file_opt in
  Yaml.of_string file

let yaml_sequence_file ?key of_yaml file =
  let key_default = Filename.(file |> basename |> remove_extension) in
  let key = Option.value ~default:key_default key in
  (let* yaml = yaml_file file in
   let* opt = Yaml.Util.find key yaml in
   let* found = Option.to_result ~none:(`Msg (key ^ ", key not found")) opt in
   let* list =
     (function `A u -> Ok u | _ -> Error (`Msg "expecting a sequence")) found
   in
   List.fold_left (fun u x -> Ok List.cons <@> of_yaml x <@> u) (Ok []) list)
  |> Result.map_error (function `Msg err -> `Msg (file ^ ": " ^ err))
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let of_yaml of_string error = function
  | `String s -> of_string s
  | _ -> Error (`Msg error)

module Toc = struct
  type t = { title : string; href : string; children : t list }
  [@@deriving show { with_path = false }]

  (* Copied from ocaml/omd, html.ml *)
  let to_plain_text t =
    let buf = Buffer.create 1024 in
    let rec go : _ Omd.inline -> unit = function
      | Concat (_, l) -> List.iter go l
      | Text (_, t) | Code (_, t) -> Buffer.add_string buf t
      | Emph (_, i)
      | Strong (_, i)
      | Link (_, { label = i; _ })
      | Image (_, { label = i; _ }) ->
          go i
      | Hard_break _ | Soft_break _ -> Buffer.add_char buf ' '
      | Html _ -> ()
    in
    go t;
    Buffer.contents buf

  let doc_with_ids doc =
    let open Omd in
    List.map
      (function
        | Heading (attr, level, inline) ->
            let id, attr = List.partition (fun (key, _) -> key = "id") attr in
            let id =
              match id with
              | [] -> slugify (to_plain_text inline)
              | (_, slug) :: _ -> slug (* Discard extra ids *)
            in
            let link : _ Omd.link =
              { label = Text (attr, ""); destination = "#" ^ id; title = None }
            in
            Heading
              ( ("id", id) :: attr,
                level,
                Concat ([], [ Link ([ ("class", "anchor") ], link); inline ]) )
        | el -> el)
      doc

  (* emit a structured toc from the Omd.doc *)
  let find_id attributes =
    List.find_map
      (function k, v when String.equal "id" k -> Some v | _ -> None)
      attributes

  let href_of attributes =
    match find_id attributes with None -> "#" | Some id -> "#" ^ id

  let rec create_toc ~max_level level
      (headings : ('attr * int * 'a Omd.inline) list) : t list =
    match headings with
    | [] -> []
    | (_, l, _) :: rest when l > max_level -> create_toc ~max_level level rest
    | (attrs, l, title) :: rest when l = level ->
        let child_headings, remaining_headings =
          collect_children ~max_level (l + 1) rest []
        in
        let children = create_toc ~max_level (l + 1) child_headings in
        { title = to_plain_text title; href = href_of attrs; children }
        :: create_toc ~max_level level remaining_headings
    | (_, l, _) :: _ when l > level ->
        create_toc ~max_level (level + 1) headings
    | _ :: rest -> create_toc ~max_level level rest

  and collect_children ~max_level level
      (headings : ('attr * int * 'a Omd.inline) list) acc =
    match headings with
    | [] -> (acc, [])
    | (_, l, _) :: rest when l > max_level ->
        collect_children ~max_level level rest acc
    | (_, l, _) :: _ when l < level -> (acc, headings)
    | heading :: rest ->
        collect_children level ~max_level rest (acc @ [ heading ])

  let toc ?(start_level = 1) ?(max_level = 2) doc =
    if max_level <= start_level then
      invalid_arg "toc: ~max_level must be >= ~start_level";
    let headers = Omd.headers ~remove_links:true doc in
    create_toc ~max_level start_level headers
end
