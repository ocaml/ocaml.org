let rec fold_until f acc n = function
  | [] -> (acc, [])
  | h :: t as l -> if n = 0 then (acc, l)
                   else fold_until f (f acc h) (n - 1) t

let slice list i k =
  let _, list = fold_until (fun _ _ -> []) [] i list in
  let taken, _ = fold_until (fun acc h -> h :: acc) [] (k - i + 1) list in
  List.rev taken
(* An elegant way to do this would be to use List.filteri function:

let slice list i k = 
  List.filteri (fun index _ -> index >= i && index <= k) list
*)