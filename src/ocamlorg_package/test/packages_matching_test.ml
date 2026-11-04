(* [Info.packages_matching] re-implements [OpamFormula.packages] on integer ids
   to build the reverse dependencies. Check that both agree, so that an
   opam-format upgrade that changes the library's semantics is caught. *)

let universe =
  [
    "a.1";
    "a.1.9";
    "a.1.10";
    "a.2~beta";
    "a.2";
    "a.3";
    "b.1";
    "b.2";
    "c.1";
    "c.2";
    "ca.1";
  ]
  |> List.map OpamPackage.of_string
  |> OpamPackage.Set.of_list

(* The filtered [depends] formula of an opam file with [depends], as the reverse
   dependencies compute it. *)
let formula depends =
  let opam =
    OpamFile.OPAM.read_from_string
      (Printf.sprintf "opam-version: \"2.0\"\ndepends: [ %s ]\n" depends)
  in
  OpamFilter.filter_formula ~default:true
    (fun _ -> None)
    (OpamFile.OPAM.depends opam)

let depends =
  [
    {|"a"|};
    {|"a" {>= "2"}|};
    {|"a" {> "1" & < "3"}|};
    {|"a" {< "2" | > "2"}|};
    {|"a" {>= "1.9" & < "1.10"}|};
    {|"a" {< "2"}|};
    {|"a" {!= "2"}|};
    {|"a" {>= "2"} | "b"|};
    {|("a" {= "1"} | "b" {= "2"}) "c"|};
    {|"a" {>= "2"} "a" {< "3"}|};
    {|"c" {!= "1"} "ca"|};
    {|"zzz"|};
    {|"zzz" | "b" {>= "2"}|};
    {|"b" {with-test}|};
    {|"a" {build & >= "2"}|};
    {|"a" {with-test & < "2"} "b"|};
    "";
  ]

let to_strings set =
  OpamPackage.Set.elements set |> List.map OpamPackage.to_string

let test_agrees depends () =
  let f = formula depends in
  Alcotest.(check (list string))
    depends
    (to_strings (OpamFormula.packages universe f))
    (to_strings (Ocamlorg_package.Info.packages_matching universe f))

let () =
  Alcotest.run "Info.packages_matching"
    [
      ( "agrees with OpamFormula.packages",
        List.map
          (fun d ->
            Alcotest.test_case
              (if d = "" then "(empty)" else d)
              `Quick (test_agrees d))
          depends );
    ]
