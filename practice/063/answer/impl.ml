type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let rec split_n lst acc n = match (n, lst) with
    | (0, _) -> (List.rev acc, lst)
    | (_, []) -> (List.rev acc, [])
    | (_, h :: t) -> split_n t (h :: acc) (n-1)

  let rec myflatten p c = 
    match (p, c) with
    | (p, []) -> List.map (fun x -> Node (x, Empty, Empty)) p
    | (x :: t, [y]) -> Node (x, y, Empty) :: myflatten t []
    | (ph :: pt, x :: y :: t) -> (Node (ph, x, y)) :: myflatten pt t
    | _ -> invalid_arg "myflatten"

  let complete_binary_tree = function
    | [] -> Empty
    | lst ->
       let rec aux l = function
         | [] -> []
         | lst -> let p, c = split_n lst [] (1 lsl l) in
                  myflatten p (aux (l + 1) c)
       in
         List.hd (aux 0 lst)
         