let range a b =
  let rec aux a b =
    if a > b then [] else a :: aux (a + 1) b
  in
  if a > b then List.rev (aux b a) else aux a b
