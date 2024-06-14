---
packages: []
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



