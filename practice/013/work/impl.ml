type 'a rle =
  | One of 'a
  | Many of int * 'a

let encode _ = failwith "Not yet implemented"
