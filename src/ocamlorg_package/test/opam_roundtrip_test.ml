(* Round-trips between opam files and the [Info.t] that [Info.of_opamfiles]
   builds from them, as chains of hops:

   opam0 -> info1 -> opam1 -> info2 -> opam2 -> info3

   [Info.t] does not keep every opam field, nor the [|] between packages of a
   dependency formula, so the first hop loses information. The others must not:
   from info1 on, every hop is a fixpoint. The same goes for each stored
   constraint string, which must be what storing its own parsing gives. *)

module Package = Ocamlorg_package

let opam_version = {|opam-version: "2.0"|}

let fixtures =
  [
    ("a.1", "");
    ( "a.2",
      {|
synopsis: "No synopsis"
description: """
A body
on two lines."""
license: "MIT"
|}
    );
    ( "b.1",
      {|
synopsis: "Every stored field"
description: "A description."
authors: [ "Alice" "Bob" ]
maintainer: "Carol"
license: [ "MIT" "ISC" ]
homepage: [ "https://example.org" "https://example.com" ]
tags: [ "test" "flags:verbose" ]
flags: [ light-uninstall avoid-version some-future-flag ]
depends: [
  "ocaml" {>= "4.08"}
  "dune" {>= "3.0" & < "4.0"}
  "alcotest" {with-test}
  "a" | "c"
  "fmt"
]
depopts: [ "lwt" "async" {>= "v0.15"} ]
conflicts: [ "base-no-ppx" "ppxlib" {< "0.26"} ]
url {
  src: "https://example.org/b-1.tbz"
  checksum: [
    "md5=d41d8cd98f00b204e9800998ecf8427e"
    "sha256=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  ]
}
|}
    );
    ( "c.1",
      {|
synopsis: "A git source"
license: []
depends: [ "a" {= version} "b" {build & != "2"} ]
url { src: "git+https://github.com/example/c.git#main" }
|}
    );
    (* As in dune.3.6.2: the same name on both sides of a [|]. *)
    ("d.1", {|depends: [ "a" {>= "2"} | ("a" {< "2"} & "c") ]|});
    (* As in conf-freeglut.1: a negated conjunction in a filter. *)
    ( "e.1",
      {|depends: [ "a" {build & !(os = "linux" & arch = "x86_64")} ]
depopts: [ "b" {!(os = "macos" | os = "win32")} ]|}
    );
  ]

let read_opam text = OpamFile.OPAM.read_from_string (opam_version ^ "\n" ^ text)
let pkg_name pkg = Package.Name.of_string (OpamPackage.name_to_string pkg)

let pkg_version pkg =
  Package.Version.of_string (OpamPackage.version_to_string pkg)

let repository opams =
  List.fold_left
    (fun acc (pkg, opam) ->
      Package.Name.Map.update (pkg_name pkg)
        (Package.Version.Map.add (pkg_version pkg) opam)
        Package.Version.Map.empty acc)
    Package.Name.Map.empty opams

let originals =
  List.map
    (fun (id, text) -> (OpamPackage.of_string id, read_opam text))
    fixtures

let timestamps =
  List.fold_left
    (fun acc (pkg, _) -> OpamPackage.Map.add pkg 0. acc)
    OpamPackage.Map.empty originals

let infos opams =
  let infos =
    Lwt_main.run (Package.Info.of_opamfiles ~timestamps (repository opams))
  in
  fun pkg ->
    Package.Name.Map.find (pkg_name pkg) infos
    |> Package.Version.Map.find (pkg_version pkg)

let original_info = infos originals

(* [parse_atom name cstr] is the formula atom whose printing [Info.t] stores as
   [(name, cstr)], read back by the opam parser. *)
let parse_atom name cstr =
  let atom =
    Printf.sprintf "%S%s"
      (Package.Name.to_string name)
      (match cstr with None -> "" | Some c -> " {" ^ c ^ "}")
  in
  OpamFile.OPAM.depends (read_opam (Printf.sprintf "depends: [ %s ]" atom))

(* [Info.t] stores the atoms of a formula in reverse order. *)
let formula_of join atoms =
  join (List.rev_map (fun (name, cstr) -> parse_atom name cstr) atoms)

(* Print an info back as an opam file, then read it like any other. *)
let to_opam pkg (info : Package.Info.t) =
  let open OpamFile.OPAM in
  let url =
    Option.map
      (fun (url : Package.Info.url) ->
        OpamFile.URL.create
          ~checksum:(List.map OpamHash.of_string url.checksum)
          (OpamUrl.parse url.uri))
      info.url
  in
  empty
  |> with_name (OpamPackage.name pkg)
  |> with_version (OpamPackage.version pkg)
  |> with_synopsis info.synopsis
  |> with_descr_body info.description
  |> with_author info.authors
  |> with_maintainer info.maintainers
  |> with_license [ info.license ]
  |> with_homepage info.homepage
  |> with_tags info.tags |> with_flags info.flags |> with_url_opt url
  |> with_depends (formula_of OpamFormula.ands info.dependencies)
  (* opam reads a [depopts] or [conflicts] list as a disjunction. Printed as a
     conjunction, it would read back in reverse order. *)
  |> with_depopts (formula_of OpamFormula.ors info.depopts)
  |> with_conflicts (formula_of OpamFormula.ors info.conflicts)
  |> write_to_string |> read_from_string

let reprint info opams =
  List.map (fun (pkg, _) -> (pkg, to_opam pkg (info pkg))) opams

let info1 = original_info
let opam1 = reprint info1 originals
let info2 = infos opam1
let opam2 = reprint info2 opam1
let info3 = infos opam2

let check_each f () =
  List.iter
    (fun (pkg, original) -> f (OpamPackage.to_string pkg) pkg original)
    originals

(* opam0 -> info1 -> opam1 *)
let test_exact_fields =
  check_each (fun id pkg original ->
      let again = List.assoc pkg opam1 in
      let strings label get =
        Alcotest.(check (list string))
          (id ^ ": " ^ label)
          (get original) (get again)
      in
      let open OpamFile.OPAM in
      Alcotest.(check string)
        (id ^ ": name and version")
        id
        (OpamPackage.to_string (package again));
      strings "authors" author;
      strings "maintainer" maintainer;
      strings "homepage" homepage;
      strings "tags" tags;
      strings "flags" (fun o ->
          List.map OpamTypesBase.string_of_pkg_flag (flags o));
      strings "checksums" (fun o ->
          match url o with
          | None -> []
          | Some u -> List.map OpamHash.to_string (OpamFile.URL.checksum u)))

let deps l =
  List.map
    (fun (n, c) -> Package.Name.to_string n ^ " " ^ Option.value ~default:"" c)
    l

let rev_dep_names (i : Package.Info.t) =
  List.map (fun (n, _, _) -> Package.Name.to_string n) i.rev_deps

(* info1 -> opam1 -> info2: what the opam file says about the package itself
   comes back. The reverse dependencies may not: they come from the formulas of
   other packages, which lose their [|] between packages. *)
let test_info2 =
  check_each (fun id pkg _ ->
      let (a : Package.Info.t) = info1 pkg
      and (b : Package.Info.t) = info2 pkg in
      let field label get =
        Alcotest.(check (list string)) (id ^ ": " ^ label) (get a) (get b)
      in
      field "synopsis" (fun i -> [ i.synopsis ]);
      field "description" (fun i -> [ i.description ]);
      field "license" (fun i -> [ i.license ]);
      field "flags" (fun i -> List.map OpamTypesBase.string_of_pkg_flag i.flags);
      field "url" (fun i ->
          match i.url with None -> [] | Some u -> u.uri :: u.checksum);
      field "dependencies" (fun i -> deps i.dependencies);
      field "depopts" (fun i -> deps i.depopts);
      field "conflicts" (fun i -> deps i.conflicts);
      (* Every field, including those not listed above. *)
      Alcotest.(check bool)
        (id ^ ": every field but the reverse dependencies")
        true
        ({ a with rev_deps = [] } = { b with rev_deps = [] }))

(* The loss in the first hop, made explicit: d.1 depends on every version of
   [a], but once its [|] is read as [&], on none. *)
let test_disjunction_is_lost () =
  List.iter
    (fun v ->
      let pkg = OpamPackage.of_string v in
      Alcotest.(check bool)
        (v ^ ": d.1 is a reverse dependency in info1")
        true
        (List.mem "d" (rev_dep_names (info1 pkg)));
      Alcotest.(check bool)
        (v ^ ": d.1 is not one in info2")
        false
        (List.mem "d" (rev_dep_names (info2 pkg))))
    [ "a.1"; "a.2" ]

(* info2 -> opam2 -> info3, and opam1 -> info2 -> opam2: fixpoints. *)
let test_fixpoint =
  check_each (fun id pkg _ ->
      Alcotest.(check bool)
        (id ^ ": info3 is info2, reverse dependencies included")
        true
        (info2 pkg = info3 pkg);
      Alcotest.(check string)
        (id ^ ": opam2 is opam1, as text")
        (OpamFile.OPAM.write_to_string (List.assoc pkg opam1))
        (OpamFile.OPAM.write_to_string (List.assoc pkg opam2)))

(* Parentheses are [Block] nodes, which [Info] may print differently, both in a
   formula over package names and in the constraint of each atom. *)
let rec unblock : 'a. 'a OpamFormula.formula -> 'a OpamFormula.formula =
  function
  | OpamFormula.Block f -> unblock f
  | And (a, b) -> And (unblock a, unblock b)
  | Or (a, b) -> Or (unblock a, unblock b)
  | (Empty | Atom _) as f -> f

let unblock_all f =
  OpamFormula.map (fun (n, c) -> OpamFormula.Atom (n, unblock c)) (unblock f)

(* The string that [Info] stores for the single atom [name {cstr}]. *)
let restore name cstr =
  let pkg = OpamPackage.of_string "z.1" in
  let atom = parse_atom name cstr in
  let opams = [ (pkg, OpamFile.OPAM.(with_depends atom empty)) ] in
  let timestamps = OpamPackage.Map.singleton pkg 0. in
  let infos =
    Lwt_main.run (Package.Info.of_opamfiles ~timestamps (repository opams))
  in
  match
    (Package.Name.Map.find (pkg_name pkg) infos
    |> Package.Version.Map.find (pkg_version pkg))
      .dependencies
  with
  | [ (n, c) ] when Package.Name.to_string n = Package.Name.to_string name -> c
  | _ -> Alcotest.fail "one atom in, one atom out"

(* constraint string -> formula -> constraint string *)
let test_constraints =
  check_each (fun id pkg original ->
      let info = info1 pkg in
      List.iter
        (fun (label, formula, stored) ->
          let atoms =
            OpamFormula.fold_left (fun acc a -> a :: acc) [] formula
          in
          Alcotest.(check int)
            (id ^ ": number of " ^ label)
            (List.length atoms) (List.length stored);
          List.iter2
            (fun atom (name, cstr) ->
              let what =
                Printf.sprintf "%s: %s %s {%s}" id label
                  (Package.Name.to_string name)
                  (Option.value ~default:"" cstr)
              in
              Alcotest.(check bool)
                (what ^ " parses back to the original, up to parentheses")
                true
                (unblock_all (OpamFormula.Atom atom)
                = unblock_all (parse_atom name cstr));
              Alcotest.(check (option string))
                (what ^ " is stored as itself")
                cstr (restore name cstr))
            atoms stored)
        OpamFile.OPAM.
          [
            ("depends", depends original, info.dependencies);
            ("depopts", depopts original, info.depopts);
            ("conflicts", conflicts original, info.conflicts);
          ])

let () =
  let test name f = Alcotest.test_case name `Quick f in
  Alcotest.run "opam round-trip"
    [
      ("opam0 -> info1 -> opam1", [ test "exact fields" test_exact_fields ]);
      ( "info1 -> opam1 -> info2",
        [
          test "same info but reverse dependencies" test_info2;
          test "a disjunction over one name is lost" test_disjunction_is_lost;
        ] );
      ("from info2 on", [ test "every hop is a fixpoint" test_fixpoint ]);
      ( "constraint string -> formula -> constraint string",
        [ test "fixpoint" test_constraints ] );
    ]
