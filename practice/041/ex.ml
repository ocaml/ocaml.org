open OUnit2

module type Testable = sig
  val goldbach_list : int -> int -> (int * (int * int)) list
end

module Make(Tested: Testable) : sig val v : test end = struct

  let tests = "Goldbach's compositions" >::: [

     "goldbach_list from 9 -20" >:: (fun _ ->
      assert_equal [(10, (3, 7)); (12, (5, 7)); (14, (3, 11)); (16, (3, 13)); (18, (5, 13)); (20, (3, 17))]
                   (Tested.goldbach_list 9 20 ));
  ]
  let v = "Goldbach_composition" >::: [
    tests
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
