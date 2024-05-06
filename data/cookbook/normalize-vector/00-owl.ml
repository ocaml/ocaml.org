---
packages:
- name: owl
  tested_version: "1.1"
  used_libraries:
  - owl
---
let v = Owl.Mat.of_array [|1.;1.|] 2 1

let norm = Owl.Linalg.D.norm v

let v' = Owl.Mat.( v /$ norm );;

let () =
  Owl.Mat.iteri_2d (fun i j a -> Printf.printf "(%i) %.1f\n" i a) v';;

