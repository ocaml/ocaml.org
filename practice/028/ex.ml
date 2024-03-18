open OUnit2

module type Testable = sig
  val length_sort : 'a list list -> 'a list list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "length_sort" >::: [
    "empty_list" >:: (fun _ -> assert_equal [[]] (Tested.length_sort [[]]));
    "length_sort" >:: (fun _ -> assert_equal [["o"]; ["d"; "e"]; ["d"; "e"]; ["m"; "n"]; ["a"; "b"; "c"]; ["f"; "g"; "h"];
    ["i"; "j"; "k"; "l"]] (Tested.length_sort [["a"; "b"; "c"]; ["d"; "e"]; ["f"; "g"; "h"]; ["d"; "e"];
    ["i"; "j"; "k"; "l"]; ["m"; "n"]; ["o"]]));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
