---
packages:
- name: owl
  tested_version: "1.1"
  used_libraries:
  - owl
---

(* Create two 2x2 matrices from 1D arrays *)
let m1 =
  Owl.Mat.of_array [|1.;2.;3.;4.|] 2 2
let m2 =
  Owl.Mat.of_array [|5.;6.;7.;8.|] 2 2

let add = Owl.Mat.( m1 + m2 );;
let mul = Owl.Mat.( m1 *@ m2 );;

let () =
  Owl.Mat.iteri_2d
    (fun i j a ->
      Printf.printf "(%i,%i) %.1f\n" i j a)
    add;;

let () =
  Owl.Mat.iteri_2d
    (fun i j a ->
      Printf.printf "(%i,%i) %.1f\n" i j a)
    mul;;
