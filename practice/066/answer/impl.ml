type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let layout_binary_tree_3 =
    let rec translate_x d = function
      | Empty -> Empty
      | Node ((v, x, y), l, r) ->
         Node ((v, x + d, y), translate_x d l, translate_x d r) in
    (* Distance between a left subtree given by its right profile [lr]
       and a right subtree given by its left profile [rl]. *)
    let rec dist lr rl = match lr, rl with
      | lrx :: ltl, rlx :: rtl -> max (lrx - rlx) (dist ltl rtl)
      | [], _ | _, [] -> 0 in
    let rec merge_profiles p1 p2 = match p1, p2 with
      | x1 :: tl1, _ :: tl2 -> x1 :: merge_profiles tl1 tl2
      | [], _ -> p2
      | _, [] -> p1 in
    let rec layout depth = function
      | Empty -> ([], Empty, [])
      | Node (v, l, r) ->
         let (ll, l', lr) = layout (depth + 1) l in
         let (rl, r', rr) = layout (depth + 1) r in
         let d = 1 + dist lr rl / 2 in
         let ll = List.map (fun x -> x - d) ll
         and lr = List.map (fun x -> x - d) lr
         and rl = List.map ((+) d) rl
         and rr = List.map ((+) d) rr in
         (0 :: merge_profiles ll rl,
          Node((v, 0, depth), translate_x (-d) l', translate_x d r'),
          0 :: merge_profiles rr lr) in
    fun t -> let (l, t', _) = layout 1 t in
             let x_min = List.fold_left min 0 l in
             translate_x (1 - x_min) t'
             