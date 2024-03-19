type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let at_level t level =
    let rec at_level_aux t acc counter = match t with
      | Empty -> acc
      | Node (x, l, r) ->
        if counter=level then
          x :: acc
        else
          at_level_aux l (at_level_aux r acc (counter + 1)) (counter + 1)
    in
      at_level_aux t [] 1
      