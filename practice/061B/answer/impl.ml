type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let leaves t = 
    let rec internals_aux t acc = match t with
    | Empty -> acc
    | Node (_, Empty, Empty) -> acc
    | Node (x, l, r) -> internals_aux l (x :: internals_aux r acc)
  in
  internals_aux t []
