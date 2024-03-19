open OUnit2

module type Testable = sig
  type bool_expr =
    | Var of string
    | Not of bool_expr
    | And of bool_expr * bool_expr
    | Or of bool_expr * bool_expr
  
 
  val table2 : string -> string -> bool_expr -> (bool * bool * bool) list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let example_tests = "table2" >::: [
    "example 1" >:: (fun _ ->
      assert_equal
        [(true, true, true); (true, false, true); (false, true, false); (false, false, false)]
        (table2 "a" "b" (And (Var "a", Or (Var "a", Var "b")))));
    "example 2" >:: (fun _ ->
      assert_equal
        [(true, true, true); (true, false, true); (false, true, false); (false, false, false)]
        (table2 "a" "b" (Or (Var "a", And (Var "a", Var "b"))))); 
   
  ]
  
  let v = "truth table for a two-variable tests" >::: [
    example_tests;
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
