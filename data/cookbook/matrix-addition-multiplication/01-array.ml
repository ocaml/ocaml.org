---
packages:
---

(* Note: For production the Owl library has these matrix operations implemented in a more performant approach. *)
(* To define the addition and multiplication of matrices, we can use the Array module, where a matrix is defined as an array of an array. A key function is `Array.init_matrix` that we will use multiple times. Along this recipe we use integers as elements for vectors and matrices and, therefore, their operators *,+ and - in the definitions. Our approach to define the algebra of matrices rely on the algebra of vectors, so we will define first the addition and multiplication of vectors (after several supporting functions for the tests). *)

(* Supporting functions: for convenience we define two functions to print vectors and matrices with integer elements. *) 
let print_vec v      = let s = Array.map (Printf.sprintf "%5i") v |> Array.to_list in 
                       Printf.printf "[ %s ]\n" (String.concat "," s)
let print_mat name x = let _ = Printf.printf "%s :\n" name in 
                       Array.iter print_vec x 

(* Supporting functions: to understand better the `Array.init_matrix` we use it to create our input matrices with two functions, one where the element (i,j) of the matrix has the value (i+j) and the other the value (i-j). Here, n is the number of rows, and m is the number of columns. As we are using integer elements, the operators will be + and - *)
let make_add n m = Array.init_matrix n m (+)
let make_sub n m = Array.init_matrix n m (-)

(* Sum of two vectors: the motivation of this definition is that although the element (ij) of the matrix a+b is a.(i).(j) + b.(i).(j), we also can add matrices directly row by row (which are vectors). *)
let add_vec a b = Array.map2 ( + ) a b

(* Dot product of two vectors: will be useful because the element (i,j) of the multiplication of two matrices a and b can be defined as the dot product of the i-row of a by the j-column of b. *)
let dot_vec a b = Array.map2 ( * ) a b |> Array.fold_left ( + ) 0

(* Matrix dimensions: get matrix dimensions where n is the number of rows and m is the number of columns. *)
let dim_mat a = (Array.length a),(Array.length a.(0))

(* Transpose of a matrix *)
let transpose a = 
    let n,m = dim_mat a in 
    let tr_elem  x i j = Array.get (Array.get x j) i in 
    Array.init_matrix m n (tr_elem a) 

(* Addition of matrices a and b: we are adding row by row. *)
let add_mat x y = Array.map2 (fun a b -> (add_vec a b)) x y

(* Multiplication of matrices a and b: the element (i,j) of the matrix product a*b is the dot vector product of the i-row of a by the j-column of a, or the dot product of i-row of a by the j-row of the transpose of b. We use this last definition. If the dimensions of matrix a are (n,m) those of b should be (m,p), so we test that the product is possible according to input matrices dimensions, if not returns 1x1 matrix with value 0 *)
let mul_mat a b =
    let dot_ij z y i j  = dot_vec (Array.get z i) (Array.get y j) in 
    let n,m = dim_mat a in 
    let k,p = dim_mat b in 
    if k=m 
    then Array.init_matrix n p (dot_ij a (transpose b)) 
    else (Array.make_matrix 1 1 0)

(* We can apply now our definitions *) 
let () = 
         (* Test for Addition and Multiplication of square matrices *)
         let a  = make_add 3 3 in 
         let b  = make_sub 3 3 in
         let _  = print_mat "Matrix A (square)    "   a in 
         let _  = print_mat "Matrix B (square)    "   b in 
         let _  = print_mat "Addition A+B (square)" (add_mat a b) in 
         let _  = print_mat "Product  A B (square)" (mul_mat a b) in
         (* Test for Multiplication of non-square matrices *)
         let a1 = make_add 3 2 in
         let b1 = make_sub 3 3 in
         let _  = print_mat "Matrix A1 (non-square)" a1 in 
         let _  = print_mat "Matrix B1 (non-square)" b1 in
         let _  = print_mat "Product A1 B1 (non-square)" (mul_mat a1 b1) in
         (* Test for Addition of non-square matrices *)
         let a2 = make_add 4 2 in
         let b2 = make_sub 4 2 in
         let _  = print_mat "Matrix A2 (non-square)" a2 in 
         let _  = print_mat "Matrix B2 (non-square)" b2 in
         print_mat "Addition A2 B2 (non-square)" (add_mat a2 b2)
