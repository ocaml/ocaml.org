(* Naive power function. *)
let rec pow n p = if p < 1 then 1 else n * pow n (p - 1)

(* [factors] is defined in the previous question. *)
let phi_improved n =
  let rec aux acc = function
    | [] -> acc
    | (p, m) :: t -> aux ((p - 1) * pow p (m - 1) * acc) t
  in
    aux 1 (factors n)