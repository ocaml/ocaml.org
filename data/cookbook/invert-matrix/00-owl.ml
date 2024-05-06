---
packages:
- name: owl
  tested_version: "1.1"
  used_libraries:
  - owl
---
let m = Owl.Mat.of_array [|1.;2.;3.;4.|] 2 2
let minv = Owl.Linalg.D.inv m

let () =
Owl.Mat.iteri_2d (fun i j a -> Printf.printf "(%i,%i) %.1f\n" i j a) minv;;

(* A verification *)

let () = assert Owl.Mat.( m *@ minv =~ eye 2)
