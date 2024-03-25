let rec insert_at x n = function
  | [] -> [x]  (* Insert at the end if the list is empty or n is beyond the list length *)
  | h :: t as l -> if n = 0 then x :: l else h :: insert_at x (n - 1) t
