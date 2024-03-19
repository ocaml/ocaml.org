type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let leaves t = 
    let rec leaves_aux t acc = match t with
      | Empty -> acc
      | Node (x, Empty, Empty) -> x :: acc
      | Node (x, l, r) -> leaves_aux l (leaves_aux r (x :: acc))
    in
    leaves_aux t []
