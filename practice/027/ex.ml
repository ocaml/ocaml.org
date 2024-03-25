open OUnit2

module type Testable = sig
  val group : 'a list -> int list -> 'a list list list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "group" >::: [
    "empty_group" >:: (fun _ -> assert_equal [[]] (Tested.group [] []));
    "group" >:: (fun _ -> assert_equal [[["a"; "b"]; ["c"]]; [["a"; "c"]; ["b"]]; [["b"; "c"]; ["a"]];
    [["a"; "b"]; ["d"]]; [["a"; "c"]; ["d"]]; [["b"; "c"]; ["d"]];
    [["a"; "d"]; ["b"]]; [["b"; "d"]; ["a"]]; [["a"; "d"]; ["c"]];
    [["b"; "d"]; ["c"]]; [["c"; "d"]; ["a"]]; [["c"; "d"]; ["b"]]] (Tested.group ["a"; "b"; "c"; "d"] [2; 1]));
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
