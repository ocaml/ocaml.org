type 'a rle =
  | One of 'a
  | Many of int * 'a

let encode l =
  let create_tuple cnt elem = 
    if cnt = 0 then One elem 
    else Many (cnt + 1, elem) in
  let rec aux count acc = function
    | [] -> [] (* Can only be reached if original list is empty *)
    | [x] -> create_tuple count x :: acc
    | hd :: (snd :: _ as tl) -> 
        if hd = snd then aux (count + 1) acc tl
        else aux 0 (create_tuple count hd :: acc) tl in
    List.rev (aux 0 [] l)
