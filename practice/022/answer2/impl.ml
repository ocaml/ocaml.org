(* Tail recursive Implementation *)
let range a b =
  let rec aux acc high low =
    if high >= low then
      aux (high :: acc) (high - 1) low
    else acc
  in
  if a < b then aux [] b a else List.rev (aux [] a b)
