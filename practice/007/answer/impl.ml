type 'a node =
    | One of 'a 
    | Many of 'a node list

 let flatten list =
   let rec aux acc = function
     | [] -> acc
     | One x :: t -> aux (x :: acc) t
     | Many l :: t -> aux (aux acc l) t
   in
   List.rev (aux [] list)
