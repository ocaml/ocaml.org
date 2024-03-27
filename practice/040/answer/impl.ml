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
