---
packages: []
discussion: |
  - **How to normalize a vector, v using the standard library. We create a helper function to sum a list, calculate the magnitude, then compute the unit vector.**
  - **Works with float data only since we rely on the Float.sqrt function. This is reasonable though since we expect a float most of the time for a square root.**
---

(**[sum] returns the sum of all elements in the list [lst] *)
let sum lst = List.fold_left ( +. ) 0. lst

(** returns the [magnitude] for a sum of squares [sqs]*)
let rec magnitude sqs = Float.sqrt (sum sqs)

(** [normalize] accepts a list [v] of float values and returns the unit vector as a list*)
let normalize v =
  let sqs = List.map (fun x -> x *. x) v in
  let m = magnitude sqs in
  List.map (fun x -> x /. m) v
;;


(* Example Usage *)
let vector = [4.;6.;-1.]
let vhat = normalize vector;;
List.iter (Printf.printf "%.2f ") vhat

(* Note the values are rounded to the 2nd decimal place for readability.
          In practice, you should not round until your final calculation.*)



