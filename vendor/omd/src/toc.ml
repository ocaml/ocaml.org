open Ast
open Compat

let rec remove_links inline =
  match inline with
  | Concat (attr, inlines) -> Concat (attr, List.map remove_links inlines)
  | Emph (attr, inline) -> Emph (attr, remove_links inline)
  | Strong (attr, inline) -> Emph (attr, remove_links inline)
  | Link (_, link) -> link.label
  | Image (attr, link) ->
      Image (attr, { link with label = remove_links link.label })
  | Hard_break _ | Soft_break _ | Html _ | Code _ | Text _ -> inline

let headers =
  let remove_links_f = remove_links in
  fun ?(remove_links = false) doc ->
    let headers = ref [] in
    let rec loop blocks =
      List.iter
        (function
          | Heading (attr, level, inline) ->
              let inline =
                if remove_links then remove_links_f inline else inline
              in
              headers := (attr, level, inline) :: !headers
          | Blockquote (_, blocks) -> loop blocks
          | List (_, _, _, block_lists) -> List.iter loop block_lists
          | Paragraph _ | Thematic_break _ | Html_block _ | Definition_list _
          | Code_block _ ->
              ())
        blocks
    in
    loop doc;
    List.rev !headers

(* Given a list of headers — in the order of the document — go to the
   requested subsection.  We first seek for the [number]th header at
   [level].  *)
let rec find_start headers level number subsections =
  match headers with
  | (_, header_level, _) :: tl when header_level > level ->
      (* Skip, right [level]-header not yet reached. *)
      if number = 0 then
        (* Assume empty section at [level], do not consume token. *)
        match subsections with
        | [] -> headers (* no subsection to find *)
        | n :: subsections -> find_start headers (level + 1) n subsections
      else find_start tl level number subsections
  | (_, header_level, _) :: tl when header_level = level ->
      (* At proper [level].  Have we reached the [number] one? *)
      if number <= 1 then
        match subsections with
        | [] -> tl (* no subsection to find *)
        | n :: subsections -> find_start tl (level + 1) n subsections
      else find_start tl level (number - 1) subsections
  | _ ->
      (* Sought [level] has not been found in the current section *)
      []

let unordered_list items = List ([], Bullet '*', Tight, items)

let find_id attributes =
  List.find_map
    (function k, v when String.equal "id" k -> Some v | _ -> None)
    attributes

let link attributes label =
  let inline =
    match find_id attributes with
    | None -> label
    | Some id -> Link ([], { label; destination = "#" ^ id; title = None })
  in
  Paragraph ([], inline)

let rec make_toc (headers : ('attr * int * 'a inline) list) ~min_level
    ~max_level =
  match headers with
  | _ when min_level > max_level -> ([], headers)
  | [] -> ([], [])
  | (_, level, _) :: _ when level < min_level -> ([], headers)
  | (_, level, _) :: tl when level > max_level ->
      make_toc tl ~min_level ~max_level
  | (attr, level, t) :: tl when level = min_level ->
      let sub_toc, tl = make_toc tl ~min_level:(min_level + 1) ~max_level in
      let toc_entry =
        match sub_toc with
        | [] -> [ link attr t ]
        | _ -> [ link attr t; unordered_list sub_toc ]
      in
      let toc, tl = make_toc tl ~min_level ~max_level in
      (toc_entry :: toc, tl)
  | _ ->
      let sub_toc, tl =
        make_toc headers ~min_level:(min_level + 1) ~max_level
      in
      let toc, tl = make_toc tl ~min_level ~max_level in
      ([ unordered_list sub_toc ] :: toc, tl)

let toc ?(start = []) ?(depth = 2) doc =
  if depth < 1 then invalid_arg "Omd.toc: ~depth must be >= 1";
  let headers = headers ~remove_links:true doc in
  let headers =
    match start with
    | [] -> headers
    | number :: _ when number < 0 ->
        invalid_arg "Omd.toc: level 1 start must be >= 0"
    | number :: subsections -> find_start headers 1 number subsections
  in
  let len = List.length start in
  let toc, _ = make_toc headers ~min_level:(len + 1) ~max_level:(len + depth) in
  match toc with [] -> [] | _ -> [ unordered_list toc ]
