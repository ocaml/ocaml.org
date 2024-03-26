type 'a binary_tree =
    | Empty
    | Node of 'a * 'a binary_tree * 'a binary_tree
    
let max_nodes h = 1 lsl h - 1

let hbal_tree_nodes _ = failwith "Not yet implemented"

let min_nodes _ = failwith "Not yet implemented"

