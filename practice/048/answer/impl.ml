type bool_expr =
  | Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr

let rec eval val_vars = function
  | Var x -> List.assoc x val_vars
  | Not e -> not (eval val_vars e)
  | And(e1, e2) -> eval val_vars e1 && eval val_vars e2
  | Or(e1, e2) -> eval val_vars e1 || eval val_vars e2

let rec table_make val_vars vars expr =
  match vars with
  | [] -> [(List.rev val_vars, eval val_vars expr)]
  | v :: tl ->
       table_make ((v, true) :: val_vars) tl expr
     @ table_make ((v, false) :: val_vars) tl expr

let table vars expr = table_make [] vars expr
