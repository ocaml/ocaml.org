open OUnit2

module type Testable = sig
  val gray : int -> string list
end

module Make(Tested: Testable) : sig val v : test end = struct

let gray n =
  let rec gray_next_level k l =
    if k < n then
      let (first_half, second_half) =
        List.fold_left (fun (acc1, acc2) x ->
            (("0" ^ x) :: acc1, ("1" ^ x) :: acc2)) ([], []) l
      in
      gray_next_level (k + 1) (List.rev_append first_half second_half)
    else l
  in
  gray_next_level 1 ["0"; "1"]
  

let example_tests = "gray" >::: [
  "n = 1" >:: (fun _ ->
    assert_equal ["0"; "1"] (gray 1));
  "n = 2" >:: (fun _ ->
    assert_equal ["00"; "01"; "11"; "10"] (gray 2));
  "n = 3" >:: (fun _ ->
    assert_equal ["000"; "001"; "011"; "010"; "110"; "111"; "101"; "100"] (gray 3));
]
let v = "Gray Code Tests" >::: [example_tests]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
