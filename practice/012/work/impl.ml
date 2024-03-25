type 'a rle =
  | One of 'a
  | Many of int * 'a

let decode _ = failwith "Not yet implemented"
