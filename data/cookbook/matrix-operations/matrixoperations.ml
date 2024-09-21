---
packages: []
---



(*`transpose` returns the transposed form of the 2D array `matrix` that is passed in*)
let rec transpose matrix =
   match matrix with
   | [] -> []
   | [] :: _ -> []
   | rows ->
      let head = List.map List.hd rows in
      let rest = List.map List.tl rows in
      head :: transpose rest


(*`dot` returns the dot product of two matrices*)
let dot row col =
    List.fold_left2 (fun acc x y -> acc + (x * y)) 0 row col




(*`matmul` uses the two helper functions above to multiply two matrices `mx` and `my`*)
let matmul mx my =
  let mxt = transpose my in
  List.map (fun rowx ->
    List.map (fun coly ->
      dot rowx coly
    ) mxt
  ) mx


(*`matadd` uses `List.map` to add up matrices `mx` and `my`*)
let matadd mx my =
   List.map2 (fun rowx rowy ->
      List.map2 (+) rowx rowy
   ) mx my



(*Example use of `matmul`*)
let () =
   let ma1 = [
      [23;4;41];
      [38;94;1];
      [42;32;4];
      [39;31;4];
      [32;18;93];
   ] in

   let ma2 = [
      [17;38;41;1];
      [93;7;94;12];
      [3;49;3;8];
   ] in

   let product = matmul ma1 ma2 in


(*Print out result*)
   Printf.printf "Matrix Addition:\n";
   List.iter (fun row ->
      List.iter (fun elem -> Printf.printf "%d " elem) row;
      Printf.printf "\n"
   ) product;


(*Example use of `matadd`*)
   let ma3 = [
      [51;49];
      [34;46];
   ] in

   let ma4 = [
      [42;51];
      [56;41];
   ] in

   let sum = matadd ma3 ma4 in

   Printf.printf "\n\nMatrix Addition:\n";

   List.iter (fun row ->
      List.iter (fun elem -> Printf.printf "%d " elem) row;
      Printf.printf "\n"
   ) sum


