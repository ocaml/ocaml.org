open OUnit2

module type Testable = sig
  val pack : 'a list -> 'a list list 
end

module Make(Tested: Testable) : sig val v : test end = struct
  let v = "pack" >::: [
    "example" >:: (fun _ ->
      assert_equal
        [["a"; "a"; "a"; "a"]; ["b"]; ["c"; "c"]; ["a"; "a"]; ["d"; "d"];
         ["e"; "e"; "e"; "e"]]
        (Tested.pack ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "d"; "e"; "e"; "e"; "e"]))
  ]
end

module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
