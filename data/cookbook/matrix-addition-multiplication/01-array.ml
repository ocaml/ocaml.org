---
packages: []
discussion: |
   - **Dependencies:** Only depends on the Array module of the standard library, where a matrix is an array of an array with elements a'. For arrays of a' we will use here the term vector. Matrix is then an array of vectors.   
   - **Extra functions:** This implementation of the matrix operations rely on: two vector functions (`add_vec` and `dot_vec`) and two matrix functions (`transpose` and `dim_mat`). We keep them independent as they are intrinsically useful functions. 
   - **Method**: Addition of matrices is done row by row using our defined `add_vec`, the multiplication of matrices is using our defined `dot_vec` and `transpose`. The method avoid explicit loops.
   - **Understanding `Array.init_matrix`:** This is a key function used multiple times. Given the dimensions of the matrix (number of rows and number of columns) and a function over the matrix indices (row,column) it returns a (filled) matrix. Two supporting functions, `make_add` and `make_sub`, illustrate how to use `Array.init_matrix`. 
   - **Limitations**: The functions `add_vec` and `dot_vec` used the operators over integers `+` and `*`, therefore the vector and matrices must have integer elements. If we define `add_vec` and `dot_vec` using `+.` and `*.` (and, therefore, `mul_mat` should use `0.` insted of `0`), then we will have the equivalent functions for floats. The supporting functions `make_add` and `make_sub` work for integers but can be also implemented for floats.
   - **Alternatives**: Matrix operations are included in the Owl library. This recipe is useful when the user needs to use the standard library, otherwise Owl offers more functionality.
---

(* The approach used to define the matrix operations rely on vector operations, so we will define first the addition and dot-product of vectors (after several supporting functions). *)

(* Supporting functions: to understand better the `Array.init_matrix` we use it to create our input matrices with two functions, one where the element (i,j) of the matrix has the value (i+j) and the other the value (i-j). Here, n is the number of rows, and m is the number of columns. As we are using integer elements, the operators will be `+` and `-` *)
let make_add n m = Array.init_matrix n m (+)
let make_sub n m = Array.init_matrix n m (-)

(* Sum of two vectors u and v: useful below because we can add matrices directly row by row (and rows are vectors). *)
let add_vec u v = Array.map2 ( + ) u v

(* Dot product of two vectors u and v: it will be useful because the element (i,j) of the multiplication of two matrices a and b can be defined as the dot product of the i-row of a by the j-column of b. *)
let dot_vec u v = Array.map2 ( * ) u v |> Array.fold_left ( + ) 0

(* Matrix dimensions: return matrix dimensions (n,m) of matrix a where n is the number of rows and m is the number of columns. *)
let dim_mat a = (Array.length a),(Array.length a.(0))

(* Transpose of matrix a: if matrix a has a value x in the position (i,j) then the transpose of a has the value x in the position (j,i) *)
let transpose a = 
    let n,m = dim_mat a in 
    let tr_elem x i j = Array.get (Array.get x j) i in 
    Array.init_matrix m n (tr_elem a) 

(* Addition of matrices a and b: we are adding row by row. *)
let add_mat a b = Array.map2 (fun x y -> (add_vec x y)) a b

(* Multiplication of matrices a and b: the element (i,j) of the matrix product a*b is the dot vector product of the i-row of a by the j-column of a, or the dot product of i-row of a by the j-row of the transpose of b. We use this last definition. If the dimensions of matrix a are (n,m) those of b should be (m,p), so we test that the product is possible according to input matrices dimensions, if not returns 1x1 matrix with value 0 *)
let mul_mat a b =
    let dot_ij z y i j  = dot_vec (Array.get z i) (Array.get y j) in 
    let n,m = dim_mat a in 
    let k,p = dim_mat b in 
    if k=m 
    then Array.init_matrix n p (dot_ij a (transpose b)) 
    else (Array.make_matrix 1 1 0)

(* Supporting print functions: for convenience we define two functions to print vectors and matrices with integer elements. *) 
let print_vec v      = 
        let s = Array.map (Printf.sprintf "%5i") v |> Array.to_list in 
        Printf.printf "[ %s ]\n" (String.concat "," s)
let print_mat name x = 
        let _ = Printf.printf "%s :\n" name in 
        Array.iter print_vec x 

(* We can apply now our definitions *) 
let () = 
         (* Test for Addition and Multiplication of square matrices *)
         let a  = make_add 3 3 in 
         let b  = make_sub 3 3 in
         let _  = print_mat "Matrix A (square)    "   a in 
         let _  = print_mat "Matrix B (square)    "   b in 
         let _  = print_mat "Addition A+B (square)" (add_mat a b) in 
         let _  = print_mat "Product  A*B (square)" (mul_mat a b) in
         (* Test for Multiplication of non-square matrices *)
         let a1 = make_add 3 2 in
         let b1 = make_sub 2 3 in
         let _  = print_mat "Matrix A1 (non-square)" a1 in 
         let _  = print_mat "Matrix B1 (non-square)" b1 in
         let _  = print_mat "Product A1*B1 (non-square)" (mul_mat a1 b1) in
         let _  = print_mat "Product B1*A1 (non-square)" (mul_mat b1 a1) in
         let _  = print_endline "*Case of inconsistent dimensions:*" in 
         let _  = print_mat "Product A1*(transpose B1) -> should return 0 <- " (mul_mat a1 (transpose b1)) in
         (* Test for Addition of non-square matrices *)
         let a3 = make_add 4 2 in
         let b3 = make_sub 4 2 in
         let _  = print_mat "Matrix A3 (non-square)" a3 in 
         let _  = print_mat "Matrix B3 (non-square)" b3 in
         print_mat "Addition A3+B3 (non-square)" (add_mat a3 b3)
