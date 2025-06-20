---
packages: []
---
let open Format in
(* `Hashtbl.t` is a hash table with in-place modification.
   `Hashtbl.create ( -1 )` creates a table of default size.
   If you know how large the table would become, it is better to set a size on creation.
   But the table grows as needed, so setting the size accurately is technically not necessary.
*)
let numbers = Hashtbl.create ( -1 ) in

(* Adds an element `1` to the table with the key `"one"`. *)
Hashtbl.add numbers "one" 1;
Hashtbl.add numbers "two" 2;
Hashtbl.add numbers "three" 3;
Hashtbl.add numbers "secret" 42;

printf "%i\n%!" (Hashtbl.find numbers "secret");

(* `Hashtbl.find` looks up for an element by its key. *)
(try printf "%i\n%!" (Hashtbl.find numbers "four")
 with Not_found -> printf "There is no four.\n%!");

(* `Hashtbl.find_opt` does the same but returns an `option`. *)
(match Hashtbl.find_opt numbers "four" with
| Some value -> printf "%i\n%!" value
| None -> printf "There is no four.\n%!");

(* `Hashtbl.add` adds an element, but hides the previous element under the same key.
   The classical bahavior of replacing the previous element under the same key.
*)
Hashtbl.add numbers "secret" 543;
printf "%i\n%!" (Hashtbl.find numbers "secret");
(* Removes an element by its key. *)
Hashtbl.remove numbers "secret";
(* The previous values is back. *)
printf "%i\n%!" (Hashtbl.find numbers "secret");

(* Replace the previous value. *)
Hashtbl.replace numbers "secret" 543;
Hashtbl.remove numbers "secret";
(* The element is removed. *)
(try printf "%i\n%!" (Hashtbl.find numbers "secret")
 with Not_found -> printf "There is no secret.\n%!");

(* This becomes a bit tideous, so sometimes people define operators. *)
let ( .%{} ) tbl key = Hashtbl.find tbl key
and ( .%?{} ) tbl key = Hashtbl.find_opt tbl key
and ( .%{}<- ) tbl key value = Hashtbl.replace tbl key value
in
numbers.%{"secret"} <- 42;
printf "%i\n%!" numbers.%{"secret"};

(* Iterate over the whole table. *)
numbers |> Hashtbl.iter (printf "%s = %i\n%!")
