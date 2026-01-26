(* Search utilities - copied from ood-gen/lib/search.ml *)

open Import

type section = { title : string; id : string }
[@@deriving show { with_path = false }]

let id_to_href id =
  match id with
  | None -> "#"
  | Some (`Auto id) -> "#" ^ id
  | Some (`Id id) -> "#" ^ id

let rec flatten_block (block : Cmarkit.Block.t) : Cmarkit.Block.t list =
  match block with
  | Cmarkit.Block.Blocks (blocks, _) ->
      blocks |> List.map flatten_block |> List.flatten
  | x -> [ x ]

let rec collect_blocks_until_heading (block : Cmarkit.Block.t list) acc =
  match block with
  | [] -> (acc, [])
  | Cmarkit.Block.Heading (_, _) :: _ -> (acc, block)
  | Cmarkit.Block.Blocks (blocks, _) :: _ ->
      blocks |> collect_blocks_until_heading []
  | h :: t -> collect_blocks_until_heading t (h :: acc)

let collect_section (blocks : Cmarkit.Block.t list) :
    ( (section option * Cmarkit.Block.t list) * Cmarkit.Block.t list,
      [> `Msg of string ] )
    result =
  match blocks with
  | Cmarkit.Block.Heading (h, _) :: t ->
      let collected_blocks, remaining_blocks =
        collect_blocks_until_heading t []
      in
      Ok
        ( ( Some
              {
                title =
                  Cmarkit.Block.Heading.inline h
                  |> Cmarkit.Inline.to_plain_text ~break_on_soft:false
                  |> List.flatten |> String.concat "\n";
                id = id_to_href (Cmarkit.Block.Heading.id h);
              },
            collected_blocks ),
          remaining_blocks )
  | _ :: t ->
      let collected_blocks, remaining_blocks =
        collect_blocks_until_heading t []
      in
      Ok ((None, collected_blocks), remaining_blocks)
  | [] -> Error (`Msg "empty list in the document")

let rec block_to_string (block : Cmarkit.Block.t) : string =
  match block with
  | Cmarkit.Block.Blank_line _ -> ""
  | Cmarkit.Block.Block_quote (p, _) ->
      Cmarkit.Block.Block_quote.block p |> block_to_string
  | Cmarkit.Block.Code_block _ -> ""
  | Cmarkit.Block.Heading (h, _) ->
      Cmarkit.Block.Heading.inline h
      |> Cmarkit.Inline.to_plain_text ~break_on_soft:false
      |> List.flatten |> String.concat "\n"
  | Cmarkit.Block.Html_block (block_lines, _) ->
      let rec block_lines_to_string (block_lines : Cmarkit.Block_line.t list) : string =
        match block_lines with
        | [] -> ""
        | h :: t ->
            Cmarkit.Block_line.to_string h ^ "\n" ^ block_lines_to_string t
      in
      block_lines_to_string block_lines
  | Cmarkit.Block.List (l, _) ->
      let items =
        Cmarkit.Block.List'.items l |> List.map (fun (item, _) -> item)
      in
      items
      |> List.map Cmarkit.Block.List_item.block
      |> List.map block_to_string |> String.concat "\n"
  | Cmarkit.Block.Link_reference_definition (l, _) ->
      Cmarkit.Link_definition.label l
      |> Option.map Cmarkit.Label.text
      |> Option.value ~default:[]
      |> List.map Cmarkit.Block_line.tight_to_string
      |> String.concat " "
  | Cmarkit.Block.Paragraph (p, _) ->
      Cmarkit.Block.Paragraph.inline p
      |> Cmarkit.Inline.to_plain_text ~break_on_soft:false
      |> List.flatten |> String.concat "\n"
  | Cmarkit.Block.Blocks (blocks, _) ->
      blocks |> List.map block_to_string |> String.concat "\n"
  | Cmarkit.Block.Thematic_break _ -> ""
  | _ -> ""

let rec collect_all_sections (section_blocks : Cmarkit.Block.t list) =
  match collect_section section_blocks with
  | Ok (section, remaining_blocks) ->
      if remaining_blocks <> [] then
        section :: collect_all_sections remaining_blocks
      else [ section ]
  | Error (`Msg msg) -> failwith msg
