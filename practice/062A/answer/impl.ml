let internals t = 
    let rec internals_aux t acc = match t with
      | Empty -> acc
      | Node (x, Empty, Empty) -> acc
      | Node (x, l, r) -> internals_aux l (x :: internals_aux r acc)
    in
    internals_aux t []
    