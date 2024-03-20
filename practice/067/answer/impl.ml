type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let rec string_of_tree = function
  | Empty -> ""
  | Node(data, l, r) ->
     let data = String.make 1 data in
     match l, r with
     | Empty, Empty -> data
     | _, _ -> data ^ "(" ^ (string_of_tree l) ^ "," ^ (string_of_tree r) ^ ")"

let tree_of_string s =
  let rec make ofs s =
    if ofs >= String.length s || s.[ofs] = ',' || s.[ofs] = ')' then
      (Empty, ofs)
    else
      let v = s.[ofs] in
      if ofs + 1 < String.length s && s.[ofs + 1] = '(' then
        let l, ofs = make (ofs + 2) s in (* skip "v(" *)
        let r, ofs = make (ofs + 1) s in (* skip "," *)
        (Node (v, l, r), ofs + 1) (* skip ")" *)
      else (Node (v, Empty, Empty), ofs + 1)
  in
  fst (make 0 s)
