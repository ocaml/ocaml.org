let rec duplicate = function
  | [] -> []
  | h :: t -> h :: h :: duplicate t
