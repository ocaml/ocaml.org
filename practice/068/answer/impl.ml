type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let rec preorder = function
    | Empty -> []
    | Node (v, l, r) -> v :: (preorder l @ preorder r)
    let rec inorder = function
    | Empty -> []
    | Node (v, l, r) -> inorder l @ (v :: inorder r)
    let rec split_pre_in p i x accp acci = match (p, i) with
    | [], [] -> (List.rev accp, List.rev acci), ([], [])
    | h1 :: t1, h2 :: t2 ->
       if x = h2 then
         (List.tl (List.rev (h1 :: accp)), t1),
         (List.rev (List.tl (h2 :: acci)), t2)
       else
         split_pre_in t1 t2 x (h1 :: accp) (h2 :: acci)
    | _ -> assert false
    let rec pre_in_tree p i = match (p, i) with
    | [], [] -> Empty
    | (h1 :: _), (_ :: _) ->
       let (lp, rp), (li, ri) = split_pre_in p i h1 [] [] in
       Node (h1, pre_in_tree lp li, pre_in_tree rp ri)
    | _ -> invalid_arg "pre_in_tree"
