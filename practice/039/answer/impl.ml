let is_prime n =
  let n = max n (-n) in
  let rec is_not_divisor d =
    d * d > n || (n mod d <> 0 && is_not_divisor (d + 1))
  in
    n > 1 && is_not_divisor 2

let rec all_primes a b =
  if a > b then [] else
    let rest = all_primes (a + 1) b in
    if is_prime a then a :: rest else rest
