---
packages: 
- name: "csv"
  tested_version: "2.4"
  used_libraries:
  - "csv"
---

(** This is a basic example of reading data from a CSV formatted string into a
    list of record results. It includes some simple error handling of malformed
    data *)

(* let* allows for nicer syntax when working with result *)
let ( let* ) = Result.bind

(* Basic types which will be read from the CSV *)
type colour = Red | Yellow | Blue
type fruit = { index : int; name : string; colour : colour }

(* Utility function to print a colour as a string *)
let colour_to_string = function
  | Red -> "Red"
  | Yellow -> "Yellow"
  | Blue -> "Blue"

(* Parsing functions which take a string and return a result *)

(* Match a string to a colour directly. Any other string is an
   `Unknown_colour *)
let parse_colour = function
  | "Red" -> Ok Red
  | "Yellow" -> Ok Yellow
  | "Blue" -> Ok Blue
  | _ -> Error `Unknown_colour

(* Parse the index i as an optional value and convert the option to a result *)
let parse_index i =
  i |> int_of_string_opt |> Option.to_result ~none:`Invalid_index

(* Any string except "" is an acceptable fruit name *)
let parse_name = function "" -> Error `Missing_name | f -> Ok f

(** Combine let* with the above parse functions for an easy to read parse_row
    function. An error returned at any of the let* binds will propagate upwards,
    discontinuing the execution of parse_row. *)
let parse_row row =
  let* index = Csv.Row.find row "index" |> parse_index in
  let* name = Csv.Row.find row "name" |> parse_name in
  let* colour = Csv.Row.find row "colour" |> parse_colour in

  Ok { index; name; colour }

(* map parse_row to a CSV to parse all the rows in the file *)
let parse_fruits_csv contents =
  contents
  |> Csv.of_string ~has_header:true
  |> Csv.Rows.input_all |> List.map parse_row


let contents =
  {|"index","name","colour",
  "1","apple","Red",
  "2","lemon","Yellow",
  "3","berry","Blue",|}

(* Example of using the above types and functions to parse a csv *)
let () =
  parse_fruits_csv contents
  |> List.iter (function
       | Ok fruit ->
           print_endline
             (Int.to_string fruit.index ^ " " ^ fruit.name ^ " "
             ^ colour_to_string fruit.colour)
       | Error `Invalid_index -> print_endline "Invalid_index"
       | Error `Unknown_colour -> print_endline "Unknown_colour"
       | Error `Missing_name -> print_endline "Missing_name")
