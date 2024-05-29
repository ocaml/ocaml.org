type 'a node =
  | One of 'a 
  | Many of 'a node list

let flatten _ = failwith "Not yet implemented"
