---
packages: []
discussion: |
  - **Description:** The [Median](https://statistics.laerd.com/statistical-guides/measures-central-tendency-mean-mode-median.php) measure of central tendency
  is the middle value in an ordered set of data. It is useful for statistical analysis as it isn't easily influenced by extreme values (outliers)
  - **Data Assumption:** This code assumes the data is of type float. While we can calculate the median for any numeric value, it makes sense to use floats in Ocaml since all
  integers i.e 1 can be represented as floats 1. but not all floats can be represented by integer data types i.e. 1.5 does not equal 1 or 2
  - **Note:** When there is an even number of elements in the data, the median will be the average of the two middle values.
---

(* `median` returns the middle value of the elements of `data`.
    An empty list will return `invalid_arg "empty list"`.

    To find the median, the data needs to be sorted. `List.sort` comes with the Ocaml standard library 
    and is used to create the `sorted_data` object.

    We then check if we have an even or odd number of elements in `data`. This determines how we find the middle value.     
*)
let median data =
  let n = List.length data in
  if data = []
  then invalid_arg "empty list"
  else (
    let sorted_data = List.sort compare data in
    if n mod 2 = 0
    then (
      let mid1 = List.nth sorted_data ((n / 2) - 1) in
      let mid2 = List.nth sorted_data (n / 2) in
      (mid1 +. mid2) /. 2.0)
    else List.nth sorted_data (n / 2))

(* Example usage *)
let data = [ 1.0; 2.0; 3.0; 4.0; 5.0; 6.0; 1.0 ]

Printf.printf "The median value is %f" (median data)
