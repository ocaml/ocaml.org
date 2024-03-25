let factors n =
  let rec aux d n =
    if n = 1 then [] else
      if n mod d = 0 then
        match aux d (n / d) with
        | (h, n) :: t when h = d -> (h, n + 1) :: t
        | l -> (d, 1) :: l
      else aux (d + 1) n
  in
    aux 2 n
