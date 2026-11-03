(* The reverse dependencies that [Info.of_opamfiles] computes on a small
   repository: which names, in which order, with which version formula and
   latest version. *)

module Package = Ocamlorg_package

let opams =
  [
    ("a.1", "");
    ("a.2", "");
    ("a.3", "");
    ("b.1", {|"a" {>= "2"}|});
    ("b.2", {|"a"|});
    ("c.1", {|"a" {< "2"} | "b"|});
    ("d.1", {|"b" {= "1"}|});
    ("d.2", {|"zzz"|});
  ]

let state =
  List.fold_left
    (fun acc (pkg, depends) ->
      let pkg = OpamPackage.of_string pkg in
      let opam =
        OpamFile.OPAM.read_from_string
          (Printf.sprintf "opam-version: \"2.0\"\ndepends: [ %s ]\n" depends)
      in
      Package.Name.Map.update
        (Package.Name.of_string (OpamPackage.name_to_string pkg))
        (Package.Version.Map.add
           (Package.Version.of_string (OpamPackage.version_to_string pkg))
           opam)
        Package.Version.Map.empty acc)
    Package.Name.Map.empty opams

let timestamps =
  List.fold_left
    (fun acc (pkg, _) -> OpamPackage.Map.add (OpamPackage.of_string pkg) 0. acc)
    OpamPackage.Map.empty opams

let rev_deps =
  let infos = Lwt_main.run (Package.Info.of_opamfiles ~timestamps state) in
  fun pkg ->
    let pkg = OpamPackage.of_string pkg in
    let info =
      Package.Name.Map.find
        (Package.Name.of_string (OpamPackage.name_to_string pkg))
        infos
      |> Package.Version.Map.find
           (Package.Version.of_string (OpamPackage.version_to_string pkg))
    in
    List.map
      (fun (name, formula, latest) ->
        ( Package.Name.to_string name,
          Option.value ~default:"" formula,
          Package.Version.to_string latest ))
      info.Package.Info.rev_deps

(* For each version: the names that depend on it, in increasing order, with the
   versions of that name that do (as a formula over all its versions, empty when
   they all do) and the latest of them. *)
let expected =
  [
    (* b.1 needs a >= 2, so only b.2 accepts a.1; c.1 does through a < 2. *)
    ("a.1", [ ("b", {|>= "2"|}, "2"); ("c", "", "1") ]);
    (* Per-name masking reduces c.1's [a < 2 | b] to [a < 2] for a. *)
    ("a.2", [ ("b", "", "2") ]);
    ("a.3", [ ("b", "", "2") ]);
    ("b.1", [ ("c", "", "1"); ("d", {|< "2"|}, "1") ]);
    ("b.2", [ ("c", "", "1") ]);
    ("c.1", []);
    ("d.1", []);
    ("d.2", []);
  ]

let test_rev_deps (pkg, want) () =
  Alcotest.(check (list (triple string string string))) pkg want (rev_deps pkg)

let () =
  Alcotest.run "Info.of_opamfiles"
    [
      ( "reverse dependencies",
        List.map
          (fun ((pkg, _) as case) ->
            Alcotest.test_case pkg `Quick (test_rev_deps case))
          expected );
    ]
