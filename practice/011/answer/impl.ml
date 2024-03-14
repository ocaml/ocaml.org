type 'a rle =
   | One of 'a
   | Many of int * 'a
 
 let encode l =
   let create_tuple cnt elem =
     if cnt = 1 then One elem
     else Many (cnt, elem) in
   let rec aux count acc = function
     | [] -> []
     | [x] -> (create_tuple (count + 1) x) :: acc
     | hd :: (snd :: _ as tl) ->
         if hd = snd then aux (count + 1) acc tl
         else aux 0 ((create_tuple (count + 1) hd) :: acc) tl in
   List.rev (aux 0 [] l)
