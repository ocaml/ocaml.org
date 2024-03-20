let gray n =
  let rec gray_next_level k l =
    if k < n then
      let (first_half,second_half) =
          List.fold_left (fun (acc1,acc2) x ->
              (("0" ^ x) :: acc1, ("1" ^ x) :: acc2)) ([], []) l
      in
      gray_next_level (k + 1) (List.rev_append first_half second_half)
    else l
  in
  gray_next_level 1 ["0"; "1"]


