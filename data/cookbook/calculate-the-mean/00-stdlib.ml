---
packages: []
discussion: |
  - **Description:** One of most commonly used measure of central tendency is the [Mean](https://statistics.laerd.com/statistical-guides/measures-central-tendency-mean-mode-median.php)
  - **Calculation:** Using the Ocaml Standard Library
  - **Data Assumption:** This code assumes the data is of type float. While we can calculate the mean for any numeric value, it makes sense to use floats in Ocaml since all
  integers i.e 1 can be represented as floats 1. but not all floats can be represented by integer data types i.e. 1.5 does not equal 1 or 2
---


(* sample data for testing *)
let data = [ 2.; 3.; 4.; 5.; 3. ]

(* `mean` accepts a list of floats `data` and returns the mean or average of that data.

  The total number of elements `total_elemnts` in the list is found using the `List.length` method from the standard libary.

  `List.length` returns an integer, so we use the `float_of_int` function
   to convert the `length` to a float so it can be used in the next calculation.

   `summed_elements` is the sum of all elements in the list `data`. 
   It is calculated using the built-in `fold_left` method with the float addition operator `+.`
*)
let mean data =
  match data with
  | [] -> invalid_arg "list must not be empty"
  | _ ->
    let total_elements = float_of_int (List.length data) in
    let summed_elements = List.fold_left ( +. ) 0. data in
    summed_elements /. total_elements
;;

(* Example usage. Note the final value is rounded to the second decimal place in the print statment. *)
Printf.printf "The mean value is %.2f" (mean data)
