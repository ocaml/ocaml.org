(* From https://github.com/simonjbeaumont/ocaml-glob *)

(** Returns list of indices of occurances of substr in x *)
let find_substrings ?(start_point = 0) substr x =
  let len_s = String.length substr and len_x = String.length x in
  let rec aux acc i =
    if len_x - i < len_s then acc
    else if String.sub x i len_s = substr then aux (i :: acc) (i + 1)
    else aux acc (i + 1)
  in
  aux [] start_point

let matches_glob ~glob x =
  let rec contains_all_sections = function
    | _, [] | _, [ "" ] -> true
    | i, [ g ] ->
        (* need to find a match that matches to end of string *)
        find_substrings ~start_point:i g x
        |> List.exists (fun j -> j + String.length g = String.length x)
    | 0, "" :: g :: gs ->
        find_substrings g x
        |> List.exists (fun j ->
               contains_all_sections (j + String.length g, gs))
    | i, g :: gs ->
        find_substrings ~start_point:i g x
        |> List.exists (fun j ->
               (if i = 0 then j = 0 else true)
               && contains_all_sections (j + String.length g, gs))
  in
  contains_all_sections (0, String.split_on_char '*' glob)
