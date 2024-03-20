type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let rec is_mirror t1 t2 =
  match t1, t2 with
  | Empty, Empty -> true
  | Node(_, l1, r1), Node(_, l2, r2) ->
    is_mirror l1 r2 && is_mirror r1 l2
  | _ -> false

let is_symmetric = function
  | Empty -> true
  | Node(_, l, r) -> is_mirror l r

let rec insert tree x =
  match tree with
  | Empty -> Node (x, Empty, Empty)
  | Node (y, l, r) ->
    if x = y then tree
    else if x < y then Node (y, insert l x, r)
    else Node (y, l, insert r x)

let construct l = List.fold_left insert Empty l
