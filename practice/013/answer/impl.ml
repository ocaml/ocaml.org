type 'a rle =
  | One of 'a
  | Many of int * 'a

let encode list =
  let rle count x = if count = 0 then One x else Many (count + 1, x) in
  let rec aux count acc = function
    | [] -> [] (* Can only be reached if original list is empty *)
    | [x] -> rle count x :: acc
    | a :: (b :: _ as t) -> if a = b then aux (count + 1) acc t
                            else aux 0 (rle count a :: acc) t
  in
    List.rev (aux 0 [] list)
