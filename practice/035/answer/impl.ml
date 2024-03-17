(* Recall that d divides n iff [n mod d = 0] *)
let factors n =
  let rec aux d n =
    if n = 1 then [] else
      if n mod d = 0 then d :: aux d (n / d) else aux (d + 1) n
  in
    aux 2 n
