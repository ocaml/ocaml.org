open OUnit2

module type Testable = sig
  type bool_expr =
    | Var of string
    | Not of bool_expr
    | And of bool_expr * bool_expr
    | Or of bool_expr * bool_expr
  val table : string list -> bool_expr -> ((string * bool) list * bool) list
end

module Make(Tested: Testable) : sig val v : test end = struct
  open Tested

  let example_tests = "table" >::: [
    "example 1" >:: (fun _ ->
      assert_equal
        [([("a", true); ("b", true)], true);
         ([("a", true); ("b", false)], true);
         ([("a", false); ("b", true)], false);
         ([("a", false); ("b", false)], false)]
        (table ["a"; "b"] (And (Var "a", Or (Var "a", Var "b")))));
  ]
  
  let v = "Truth Tables for Logical Expressions Tests" >::: [
    example_tests;
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
