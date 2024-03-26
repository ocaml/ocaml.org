type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let rec tree_height = function
| Empty -> 0
| Node (_, left, right) -> 1 + max (tree_height left) (tree_height right)
    
let add_trees_with left right all =
  let add_right_tree all l =
    List.fold_left (fun a r -> Node ('x', l, r) :: a) all right in
  List.fold_left add_right_tree all left

let rec hbal_tree n =
  if n = 0 then [Empty]
  else if n = 1 then [Node ('x', Empty, Empty)]
  else
    let t1 = hbal_tree (n - 1) in
    let t2 = hbal_tree (n - 2) in
    let trees1 = add_trees_with t1 t1 [] in
    let trees2 = add_trees_with t1 t2 (add_trees_with t2 t1 []) in
    List.rev_append trees1 trees2

