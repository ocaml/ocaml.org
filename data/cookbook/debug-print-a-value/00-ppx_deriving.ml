---
packages:
- name: "ppx_deriving"
  tested_version: "6.0.3"
  used_libraries:
  - ppx_deriving
discussion: |
    It is required to have `(preprocess (pps ppx_deriving.show))` in `dune` file.
---

(* string *)
let () = print_endline "hello world"
let () = print_endline ([%show: string] "hello world")

(* integer *)
let show_int = [%show: int]
let () = print_endline (show_int 7)

(* tuple of integer and string *)
let show_pair : (int * string) -> string = [%show: (int * string)]
let () = print_endline (show_pair (3, "hello"))

(* list of tuples, each is a boolean and character *)
let () = print_endline @@ [%show: (bool * char) list] [ (true, 'a'); (false, 'b') ]

(* user-defined type; binary tree with weighted vertices *)
type tree =
    | Leaf of float
    | Node of float * tree * tree
    [@@deriving show]
let () = (Node (0.3,
            Node (0.5,
                Leaf 0.2, Leaf 0.3),
            Leaf 0.1) ) |> show_tree |> print_endline

(* Excluding path in printing from a user-defined type *)
type tree_char =
    | Leaf of char
    | Node of char * tree_char * tree_char
    [@@deriving show { with_path = false }]
let foo : tree_char = Node('a', Leaf 'b', Leaf 'c')
let () = foo |> show_tree_char |> print_endline

(* list of boolean option *)
let () = print_endline @@ [%show: (bool option) list] @@ [Some true; None; Some false]

(* string integer result *)
let () = Ok "hello" |> [%show: (string, int) result] |> print_endline
let () = Error 404 |> [%show: (string, int) result] |> print_endline

(* record of a string, integer, and boolean *)
type person = {
    last_name : string;
    age : int;
    is_married : bool
} [@@deriving show]

let gerard = {
    last_name = "Touny";
    age = 26;
    is_married = true
}
let () = print_endline @@ show_person @@ gerard

(* all strings generated above can be used with a formatter like Printf or anything else that works with strings *)
let () =
    let i = 20 in
    Printf.printf "At line 20 - and variable i is %i" i
