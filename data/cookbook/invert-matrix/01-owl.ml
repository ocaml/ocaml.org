---
packages: [owl]
---

(* Creates an Owl `float` matrix using random numbers drawn from an uniform distribution with `Owl.Mat.uniform`. It is very likely that it will be invertible but we ensure it by checking that the determinat is not zero with `Owl.Linalg.D.dat`. The dimensions of the matrix are defined by m. *)
let rec create_invertible m =
        let input = Owl.Mat.uniform m m in
        match Owl.Linalg.D.det input with
        | 0. -> create_invertible m 
        | _  -> input 

(* Define an input matrix that is invertible *)
let input  = create_invertible 5 

(* Calculates the inverse using `Owl.Mat.inv` *)
let inverse = Owl.Mat.inv input

(* Calculates the matrix product of input and inverse. It is used the operator `*@` available in `Owl.Mat` to perform the matrix product. *)
let id_test = Owl.Mat.(input *@ inverse)

(* id_test should be a diagonal matrix with ones. The non-diagonal elements should be reasonably close zero (round-off effect). We can test this using the operator `=~` also available in `Owl.Mat` *)
let test_result input inverse = 
        Owl.Mat.(input *@ inverse =~ eye 5);;

let () = 
    print_string "** Input matrix (random numbers)" ;
    Owl.Mat.(input  |> print) ; flush_all() ;
    print_string "\n** Inverse of input matrix" ;
    Owl.Mat.(inverse |> print) ; flush_all() ;
    print_string "\n** Product input and inverse =~ identity" ;
    Owl.Mat.(id_test |> print) ; flush_all() ;
    print_string "\n** Is the inverse correct?  " ;
    test_result input inverse |> string_of_bool |> print_string ; 
    print_endline ""

