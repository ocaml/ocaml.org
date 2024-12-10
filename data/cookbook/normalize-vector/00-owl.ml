---
packages:
- name: owl
  tested_version: "1.1"
  used_libraries:
  - owl
---

(*
Create a 2x1 matrix (column vector) with values
[1.; 1.]
*)
let v = Owl.Mat.of_array [|1.;1.|] 2 1

(* Calculate the Euclidean norm of the vector *)
let norm = Owl.Linalg.D.norm v

(*
The /$ operator performs element-wise division
between a matrix and a scalar
*)
let v' = Owl.Mat.( v /$ norm );;

let () =
  Owl.Mat.iteri_2d
    (fun i j a -> Printf.printf "(%i) %.1f\n" i a)
    v';;
