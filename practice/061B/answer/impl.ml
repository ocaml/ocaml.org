let leaves t = 
    let rec leaves_aux t acc = match t with
      | Empty -> acc
      | Node (x, Empty, Empty) -> x :: acc
      | Node (x, l, r) -> leaves_aux l (leaves_aux r acc)
    in
    leaves_aux t []
    