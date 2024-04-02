let is_prime n =
  let n = abs n in
  let rec is_not_divisor d =
    d * d > n || (n mod d <> 0 && is_not_divisor (d + 1)) in
  n <> 1 && is_not_divisor 2

let goldbach n =
  let rec aux d =
    if is_prime d && is_prime (n - d) then (d, n - d)
    else aux (d + 1)
  in aux 2

  let rec goldbach_list a b =
    if a > b then [] else
      if a mod 2 = 1 then goldbach_list (a + 1) b
      else (a, goldbach a) :: goldbach_list (a + 2) b
