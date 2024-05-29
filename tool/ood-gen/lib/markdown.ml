open Ocamlorg.Import

module Toc = struct
  type t = { title : string; href : string; children : t list }
  [@@deriving of_yaml, show]

  let id_to_href id =
    match id with
    | None -> "#"
    | Some (`Auto id) -> "#" ^ id
    | Some (`Id id) -> "#" ^ id

  let rec create_toc ~max_level level
      (headings : Cmarkit.Block.Heading.t Cmarkit.node list) : t list =
    match headings with
    | [] -> []
    | (h, _) :: rest when Cmarkit.Block.Heading.level h > max_level ->
        create_toc ~max_level level rest
    | (h, _) :: rest when Cmarkit.Block.Heading.level h = level ->
        let l = Cmarkit.Block.Heading.level h in
        let child_headings, remaining_headings =
          collect_children ~max_level (l + 1) rest []
        in
        let children = create_toc ~max_level (l + 1) child_headings in
        let title =
          Cmarkit.Inline.to_plain_text ~break_on_soft:false
            (Cmarkit.Block.Heading.inline h)
        in
        {
          title = String.concat "\n" (List.map (String.concat "") title);
          href = id_to_href (Cmarkit.Block.Heading.id h);
          children;
        }
        :: create_toc ~max_level level remaining_headings
    | (h, _) :: _ when Cmarkit.Block.Heading.level h > level ->
        create_toc ~max_level (level + 1) headings
    | _ :: rest -> create_toc ~max_level level rest

  and collect_children ~max_level level
      (headings : Cmarkit.Block.Heading.t Cmarkit.node list) acc =
    match headings with
    | [] -> (acc, [])
    | (h, _) :: rest when Cmarkit.Block.Heading.level h > max_level ->
        collect_children ~max_level level rest acc
    | (h, _) :: _ when Cmarkit.Block.Heading.level h < level -> (acc, headings)
    | heading :: rest ->
        collect_children level ~max_level rest (acc @ [ heading ])

  let headers (doc : Cmarkit.Doc.t) : Cmarkit.Block.Heading.t Cmarkit.node list
      =
    let rec headers_from_block (block : Cmarkit.Block.t) =
      match block with
      | Cmarkit.Block.Heading h -> [ h ]
      | Cmarkit.Block.Blocks (blocks, _) ->
          List.map headers_from_block blocks |> List.concat
      | _ -> []
    in

    Cmarkit.Doc.block doc |> headers_from_block

  let generate ?(start_level = 1) ?(max_level = 2) doc =
    if max_level <= start_level then
      invalid_arg "t: ~max_level must be >= ~start_level";
    create_toc ~max_level start_level (headers doc)
end

module Content = struct
  let of_string content =
    Cmarkit.Doc.of_string ~strict:true ~heading_auto_ids:true content

  let render ?(syntax_highlighting = false) doc =
    if syntax_highlighting then
      Hilite.Md.transform doc |> Cmarkit_html.of_doc ~safe:false
    else doc |> Cmarkit_html.of_doc ~safe:false
end
