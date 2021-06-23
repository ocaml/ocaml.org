open Ast
module Sub = Parser.Sub

module Pre = struct
  type container =
    | Rblockquote of t
    | Rlist of
        list_type
        * list_spacing
        * bool
        * int
        * attributes Raw.block list list
        * t
    | Rparagraph of string list
    | Rfenced_code of
        int
        * int
        * Parser.code_block_kind
        * (string * string)
        * string list
        * attributes
    | Rindented_code of string list
    | Rhtml of Parser.html_kind * string list
    | Rdef_list of string * string list
    | Rempty

  and t = { blocks : attributes Raw.block list; next : container }

  let concat l = String.concat "\n" (List.rev l) ^ "\n"

  let trim_left s =
    let rec loop i =
      if i >= String.length s then i
      else match s.[i] with ' ' | '\t' -> loop (succ i) | _ -> i
    in
    let i = loop 0 in
    if i > 0 then String.sub s i (String.length s - i) else s

  let rec close link_defs { blocks; next } =
    let finish = finish link_defs in
    match next with
    | Rblockquote state -> Raw.Blockquote ([], finish state) :: blocks
    | Rlist (ty, sp, _, _, closed_items, state) ->
        List ([], ty, sp, List.rev (finish state :: closed_items)) :: blocks
    | Rparagraph l ->
        let s = concat (List.map trim_left l) in
        let defs, off =
          Parser.link_reference_definitions (Parser.P.of_string s)
        in
        let s = String.sub s off (String.length s - off) |> String.trim in
        link_defs := defs @ !link_defs;
        if s = "" then blocks else Paragraph ([], s) :: blocks
    | Rfenced_code (_, _, _kind, (label, _other), [], attr) ->
        Code_block (attr, label, "") :: blocks
    | Rfenced_code (_, _, _kind, (label, _other), l, attr) ->
        Code_block (attr, label, concat l) :: blocks
    | Rdef_list (term, defs) ->
        let l, blocks =
          match blocks with
          | Definition_list (_, l) :: b -> (l, b)
          | b -> ([], b)
        in
        Definition_list ([], l @ [ { term; defs = List.rev defs } ]) :: blocks
    | Rindented_code l ->
        (* TODO: trim from the right *)
        let rec loop = function "" :: l -> loop l | _ as l -> l in
        Code_block ([], "", concat (loop l)) :: blocks
    | Rhtml (_, l) -> Html_block ([], concat l) :: blocks
    | Rempty -> blocks

  and finish link_defs state = List.rev (close link_defs state)

  let empty = { blocks = []; next = Rempty }

  let classify_line s = Parser.parse s

  let rec process link_defs { blocks; next } s =
    let process = process link_defs in
    let close = close link_defs in
    let finish = finish link_defs in
    match (next, classify_line s) with
    | Rempty, Parser.Lempty -> { blocks; next = Rempty }
    | Rempty, Lblockquote s -> { blocks; next = Rblockquote (process empty s) }
    | Rempty, Lthematic_break ->
        { blocks = Thematic_break [] :: blocks; next = Rempty }
    | Rempty, Lsetext_heading (2, n) when n >= 3 ->
        { blocks = Thematic_break [] :: blocks; next = Rempty }
    | Rempty, Latx_heading (level, text, attr) ->
        { blocks = Heading (attr, level, text) :: blocks; next = Rempty }
    | Rempty, Lfenced_code (ind, num, q, info, a) ->
        { blocks; next = Rfenced_code (ind, num, q, info, [], a) }
    | Rempty, Lhtml (_, kind) -> process { blocks; next = Rhtml (kind, []) } s
    | Rempty, Lindented_code s ->
        { blocks; next = Rindented_code [ Sub.to_string s ] }
    | Rempty, Llist_item (kind, indent, s) ->
        {
          blocks;
          next = Rlist (kind, Tight, false, indent, [], process empty s);
        }
    | Rempty, (Lsetext_heading _ | Lparagraph | Ldef_list _) ->
        { blocks; next = Rparagraph [ Sub.to_string s ] }
    | Rparagraph [ h ], Ldef_list def ->
        { blocks; next = Rdef_list (h, [ def ]) }
    | Rdef_list (term, defs), Ldef_list def ->
        { blocks; next = Rdef_list (term, def :: defs) }
    | Rparagraph _, Llist_item ((Ordered (1, _) | Bullet _), _, s1)
      when not (Parser.is_empty (Parser.P.of_string (Sub.to_string s1))) ->
        process { blocks = close { blocks; next }; next = Rempty } s
    | ( Rparagraph _,
        ( Lempty | Lblockquote _ | Lthematic_break | Latx_heading _
        | Lfenced_code _
        | Lhtml (true, _) ) ) ->
        process { blocks = close { blocks; next }; next = Rempty } s
    | Rparagraph (_ :: _ as lines), Lsetext_heading (level, _) ->
        let text = String.trim (String.concat "\n" (List.rev lines)) in
        { blocks = Heading ([], level, text) :: blocks; next = Rempty }
    | Rparagraph lines, _ ->
        { blocks; next = Rparagraph (Sub.to_string s :: lines) }
    | Rfenced_code (_, num, q, _, _, _), Lfenced_code (_, num', q1, ("", _), _)
      when num' >= num && q = q1 ->
        { blocks = close { blocks; next }; next = Rempty }
    | Rfenced_code (ind, num, q, info, lines, a), _ ->
        let s =
          let ind = min (Parser.indent s) ind in
          if ind > 0 then Sub.offset ind s else s
        in
        {
          blocks;
          next = Rfenced_code (ind, num, q, info, Sub.to_string s :: lines, a);
        }
    | Rdef_list (term, d :: defs), Lparagraph ->
        {
          blocks;
          next = Rdef_list (term, (d ^ "\n" ^ Sub.to_string s) :: defs);
        }
    | Rdef_list _, _ ->
        process { blocks = close { blocks; next }; next = Rempty } s
    | Rindented_code lines, Lindented_code s ->
        { blocks; next = Rindented_code (Sub.to_string s :: lines) }
    | Rindented_code lines, Lempty ->
        let n = min (Parser.indent s) 4 in
        let s = Sub.offset n s in
        { blocks; next = Rindented_code (Sub.to_string s :: lines) }
    | Rindented_code _, _ ->
        process { blocks = close { blocks; next }; next = Rempty } s
    | Rhtml ((Hcontains l as k), lines), _
      when List.exists (fun t -> Sub.contains t s) l ->
        {
          blocks = close { blocks; next = Rhtml (k, Sub.to_string s :: lines) };
          next = Rempty;
        }
    | Rhtml (Hblank, _), Lempty ->
        { blocks = close { blocks; next }; next = Rempty }
    | Rhtml (k, lines), _ ->
        { blocks; next = Rhtml (k, Sub.to_string s :: lines) }
    | Rblockquote state, Lblockquote s ->
        { blocks; next = Rblockquote (process state s) }
    | Rlist (kind, style, _, ind, items, state), Lempty ->
        {
          blocks;
          next = Rlist (kind, style, true, ind, items, process state s);
        }
    | Rlist (_, _, true, ind, _, { blocks = []; next = Rempty }), _
      when Parser.indent s >= ind ->
        process { blocks = close { blocks; next }; next = Rempty } s
    | Rlist (kind, style, prev_empty, ind, items, state), _
      when Parser.indent s >= ind ->
        let s = Sub.offset ind s in
        let state = process state s in
        let style =
          let rec new_block = function
            | Rblockquote { blocks = []; next }
            | Rlist (_, _, _, _, _, { blocks = []; next }) ->
                new_block next
            | Rparagraph [ _ ]
            | Rfenced_code (_, _, _, _, [], _)
            | Rindented_code [ _ ]
            | Rhtml (_, [ _ ]) ->
                true
            | _ -> false
          in
          if prev_empty && new_block state.next then Loose else style
        in
        { blocks; next = Rlist (kind, style, false, ind, items, state) }
    | ( Rlist (kind, style, prev_empty, _, items, state),
        Llist_item (kind', ind, s) )
      when same_block_list_kind kind kind' ->
        let style = if prev_empty then Loose else style in
        {
          blocks;
          next =
            Rlist
              (kind, style, false, ind, finish state :: items, process empty s);
        }
    | (Rlist _ | Rblockquote _), _ -> (
        let rec loop = function
          | Rlist (kind, style, prev_empty, ind, items, { blocks; next }) -> (
              match loop next with
              | Some next ->
                  Some
                    (Rlist
                       (kind, style, prev_empty, ind, items, { blocks; next }))
              | None -> None )
          | Rblockquote { blocks; next } -> (
              match loop next with
              | Some next -> Some (Rblockquote { blocks; next })
              | None -> None )
          | Rparagraph (_ :: _ as lines) -> (
              match classify_line s with
              | Parser.Lparagraph | Lindented_code _
              | Lsetext_heading (1, _)
              | Lhtml (false, _) ->
                  Some (Rparagraph (Sub.to_string s :: lines))
              | _ -> None )
          | _ -> None
        in
        match loop next with
        | Some next -> { blocks; next }
        | None -> process { blocks = close { blocks; next }; next = Rempty } s )

  let process link_defs state s = process link_defs state (Sub.of_string s)

  let of_channel ic =
    let link_defs = ref [] in
    let rec loop state =
      match input_line ic with
      | s -> loop (process link_defs state s)
      | exception End_of_file ->
          let blocks = finish link_defs state in
          (blocks, List.rev !link_defs)
    in
    loop empty

  let read_line s off =
    let buf = Buffer.create 128 in
    let rec loop cr_read off =
      if off >= String.length s then (Buffer.contents buf, None)
      else
        match s.[off] with
        | '\n' -> (Buffer.contents buf, Some (succ off))
        | '\r' ->
            if cr_read then Buffer.add_char buf '\r';
            loop true (succ off)
        | c ->
            if cr_read then Buffer.add_char buf '\r';
            Buffer.add_char buf c;
            loop false (succ off)
    in
    loop false off

  let of_string s =
    let link_defs = ref [] in
    let rec loop state = function
      | None ->
          let blocks = finish link_defs state in
          (blocks, List.rev !link_defs)
      | Some off ->
          let s, off = read_line s off in
          loop (process link_defs state s) off
    in
    loop empty (Some 0)
end
