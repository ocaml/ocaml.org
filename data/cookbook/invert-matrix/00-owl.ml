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
  Owl.Mat.iteri_2d
    (fun i j a ->
      Printf.printf "(%i,%i) %.1f\n" i j a)
    minv;;

(*
Verify that the inverse is correct by checking if
m * m^(-1) = Identity matrix
=~ operator checks if matrices are approximately equal
(within numerical precision)
*)
let () = assert Owl.Mat.(m *@ minv =~ eye 2)
