type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let max_nodes h =
  if h >= 32 then
    raise (Invalid_argument "max_nodes")
  else
    1 lsl h - 1

let rec min_nodes_loop m0 m1 h =
  if h <= 1 then m1
  else min_nodes_loop m1 (m1 + m0 + 1) (h - 1)

let min_nodes h =
  if h <= 0 then 0 else min_nodes_loop 0 1 h

let rec ceil_log2_loop log plus1 n =
  if n = 1 then if plus1 then log + 1 else log
  else ceil_log2_loop (log + 1) (plus1 || n land 1 <> 0) (n / 2)

let min_height n = ceil_log2_loop 0 false (n + 1)

let rec max_height_search h m_h m_h1 n =
  if m_h <= n then max_height_search (h + 1) m_h1 (m_h1 + m_h + 1) n else h - 1

let max_height n = max_height_search 0 0 1 n

let rec fold_range ~f ~init n0 n1 =
  if n0 > n1 then init else fold_range ~f ~init:(f init n0) (n0 + 1) n1

let add_swap_left_right trees =
  List.fold_left (fun a n -> match n with
                             | Node (v, t1, t2) -> Node (v, t2, t1) :: a
                             | Empty -> a) trees trees

let rec hbal_tree_nodes_height h n =
  assert(min_nodes h <= n && n <= max_nodes h);
  if h = 0 then [Empty]
  else
    let acc = add_hbal_tree_node [] (h - 1) (h - 2) n in
    let acc = add_swap_left_right acc in
    add_hbal_tree_node acc (h - 1) (h - 1) n

and add_hbal_tree_node l h1 h2 n =
  let min_n1 = max (min_nodes h1) (n - 1 - max_nodes h2) in
  let max_n1 = min (max_nodes h1) (n - 1 - min_nodes h2) in
  fold_range min_n1 max_n1 ~init:l ~f:(fun l n1 ->
      let t1 = hbal_tree_nodes_height h1 n1 in
      let t2 = hbal_tree_nodes_height h2 (n - 1 - n1) in
      List.fold_left (fun l t1 ->
          List.fold_left (fun l t2 -> Node ('x', t1, t2) :: l) l t2) l t1
    )

let hbal_tree_nodes n =
  fold_range (min_height n) (max_height n) ~init:[] ~f:(fun l h ->
      List.rev_append (hbal_tree_nodes_height h n) l)
