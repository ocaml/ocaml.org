(* Exercise → tutorial reference checking. *)

module E = Data_packer.Exercise_parser

let exercise ~slug tutorials : Data_intf.Exercise.t =
  Data_intf.Exercise.
    {
      title = "Count the Axolotls";
      slug;
      difficulty = Beginner;
      tags = [];
      description = "";
      statement = "";
      solution = "";
      tutorials;
    }

let tutorial_slugs = [ "lists"; "options" ]

let resolved () =
  E.check_tutorial_references ~tutorial_slugs
    [
      exercise ~slug:"001" [ "lists" ];
      exercise ~slug:"002" [ "lists"; "options" ];
    ]

let empty () =
  E.check_tutorial_references ~tutorial_slugs [ exercise ~slug:"001" [] ]

let dangling () =
  match
    E.check_tutorial_references ~tutorial_slugs
      [ exercise ~slug:"001" [ "lists" ]; exercise ~slug:"017" [ "lsits" ] ]
  with
  | () -> Alcotest.fail "expected Missing_Tutorial"
  | exception E.Missing_Tutorial msg ->
      Alcotest.(check string)
        "message"
        "The following tutorial(s) referenced by exercise slug \"017\" were \
         not found: [lsits]"
        msg

let () =
  Alcotest.run "exercise"
    [
      ( "tutorial references",
        [
          Alcotest.test_case "all resolved" `Quick resolved;
          Alcotest.test_case "no references" `Quick empty;
          Alcotest.test_case "dangling slug" `Quick dangling;
        ] );
    ]
