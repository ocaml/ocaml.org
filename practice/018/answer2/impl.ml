let slice list start stop =
  let rec aux i = function
    | [] -> []
    | x :: xs when i >= start && i <= stop -> x :: (aux (i + 1) xs)
    | _ :: xs -> aux (i + 1) xs
  in aux 0 list
