type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let layout_binary_tree_2 t =
    let rec height = function
      | Empty -> 0
      | Node (_, l, r) -> 1 + max (height l) (height r) in
    let tree_height = height t in
    let rec find_missing_left depth = function
      | Empty -> tree_height - depth
      | Node (_, l, _) -> find_missing_left (depth + 1) l in
    let translate_dst = 1 lsl (find_missing_left 0 t) - 1 in
                        (* remember than 1 lsl a = 2ᵃ *)
    let rec layout depth x_root = function
      | Empty -> Empty
      | Node (x, l, r) ->
         let spacing = 1 lsl (tree_height - depth - 1) in
         let l' = layout (depth + 1) (x_root - spacing) l
         and r' = layout (depth + 1) (x_root + spacing) r in
           Node((x, x_root, depth), l',r') in
    layout 1 ((1 lsl (tree_height - 1)) - translate_dst) t
    