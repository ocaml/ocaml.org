(* Round-trips between opam files and the [Info.t] that [Info.of_opamfiles]
   builds from them. [Info.t] does not keep every opam field, nor the structure
   of the dependency formulas, so these tests check what it does keep:

   - opam -> info -> opam: the fields that [Info.t] stores exactly come back. -
   info -> opam -> info: printing an info as an opam file and reading it back
   gives the same info. - constraint string -> formula: each stored constraint
   or filter string parses back to the formula it was printed from. *)

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

let reprinted =
  List.map (fun (pkg, _) -> (pkg, to_opam pkg (original_info pkg))) originals

let reprinted_info = infos reprinted

let check_each f () =
  List.iter
    (fun (pkg, original) -> f (OpamPackage.to_string pkg) pkg original)
    originals

(* opam -> info -> opam *)
let test_exact_fields =
  check_each (fun id pkg original ->
      let again = List.assoc pkg reprinted in
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

(* info -> opam -> info *)
let test_info_is_stable =
  let deps l =
    List.map
      (fun (n, c) -> Package.Name.to_string n ^ Option.value ~default:"" c)
      l
  in
  check_each (fun id pkg _ ->
      let (a : Package.Info.t) = original_info pkg
      and (b : Package.Info.t) = reprinted_info pkg in
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
        (id ^ ": the reprinted opam file gives the same info")
        true (a = b))

(* constraint string -> formula *)
let test_constraints_parse_back =
  check_each (fun id pkg original ->
      let info = original_info pkg in
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
              Alcotest.(check bool)
                (Printf.sprintf "%s: %s %s {%s} parses back" id label
                   (Package.Name.to_string name)
                   (Option.value ~default:"" cstr))
                true
                (OpamFormula.Atom atom = parse_atom name cstr))
            atoms stored)
        OpamFile.OPAM.
          [
            ("depends", depends original, info.dependencies);
            ("depopts", depopts original, info.depopts);
            ("conflicts", conflicts original, info.conflicts);
          ])

let () =
  Alcotest.run "opam round-trip"
    [
      ( "opam -> info -> opam",
        [ Alcotest.test_case "exact fields" `Quick test_exact_fields ] );
      ( "info -> opam -> info",
        [ Alcotest.test_case "same info" `Quick test_info_is_stable ] );
      ( "constraint string -> formula",
        [
          Alcotest.test_case "constraints parse back" `Quick
            test_constraints_parse_back;
        ] );
    ]
