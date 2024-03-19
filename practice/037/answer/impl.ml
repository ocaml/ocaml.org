let rec gcd a b = if b = 0 then a else gcd b (a mod b)
let coprime a b = gcd a b = 1

(* Naive Euler's totient function for comparison *)
let phi n =
  let rec count_coprime acc d = if d < n then count_coprime (if coprime n d then acc + 1 else acc) (d + 1) else acc in
  if n = 1 then 1 else count_coprime 0 1

let factors n =
  let rec aux d n =
    if n = 1 then [] else
      if n mod d = 0 then
        match aux d (n / d) with
        | (h, m) :: t when h = d -> (h, m + 1) :: t
        | l -> (d, 1) :: l
      else aux (d + 1) n
  in aux 2 n

(* Naive power function. *)
let rec pow n p = if p < 1 then 1 else n * pow n (p - 1)

let phi_improved n =
  let rec aux acc = function
    | [] -> acc
    | (p, m) :: t -> aux ((p - 1) * pow p (m - 1) * acc) t
  in aux 1 (factors n)
