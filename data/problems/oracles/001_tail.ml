(* The user input is wrapped in a first [User_input] module.
   This second module allows to check the type and gives a better error message
   if the function under-test is missing. *)
module User_input : sig
  val last : 'a list -> 'a option
end =
  User_input
;;

let () =
  let check (type i o) (f : i -> o) i o s n =
    if f i <> o then Format.eprintf "Test %i: [FAIL] %s@." n s
    else Format.eprintf "Test %i: [PASS]@." n
  in
  let open User_input in
  let tests = [
    check last ["a" ; "b" ; "c" ; "d"] (Some "d") {|last ["a" ; "b" ; "c" ; "d"] should return Some "d"|};
    check last [] None {|last [] should return None|};
    check last [1; 2] (Some 2) {|last [1; 2] should return Some 1|};
    check last [[]] (Some []) {|last [[]] should return Some []|};
    check last [None] (Some None) {|last [None] should return Some None|}
  ]
  in
  List.iteri (fun i x -> x i) tests
;;
