open OUnit2

module type Testable = sig
  val huffman : (string * int) list -> (string * string) list
end

module Make(Tested: Testable) : sig val v : test end = struct
  let example_tests = "Huffman" >::: [
    "Test" >:: (fun _ ->
      assert_equal
        [("a", "0"); ("c", "100"); ("b", "101"); ("f", "1100"); ("e", "1101"); ("d", "111")]
        (Tested.huffman [("a", 45); ("b", 13); ("c", 12); ("d", 16); ("e", 9); ("f", 5)]))
  
  ]

  

  let v = "Huffman Tests" >::: [example_tests]
end


module Work : Testable = Work.Impl
module Answer : Testable = Answer.Impl
