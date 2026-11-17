(* Code outside the library reads a package only through its accessors: each one
   returns the field it names. *)

module Package = Ocamlorg_package

let name = Package.Name.of_string
let version = Package.Version.of_string

let info =
  {
    Package.Info.synopsis = "Composable parsers";
    description = "Parses things, with combinators.";
    authors = [ "Xochitl" ];
    maintainers = [ "Itzel"; "Citlali" ];
    license = "ISC";
    homepage = [ "https://example.org/angstrom" ];
    tags = [ "parser"; "combinators" ];
    dependencies = [ (name "ocaml", Some ">= 4.14") ];
    rev_deps =
      [
        (name "http-parser", None, version "2.0");
        (name "csv-reader", Some ">= 1.0", version "0.3");
      ];
    depopts = [ (name "lwt", None) ];
    conflicts = [ (name "old-parser", Some "< 1.0") ];
    url =
      Some
        {
          Package.Info.uri = "https://example.org/angstrom-1.0.tar.gz";
          checksum = [ "sha256=00" ];
        };
    publication = 1_700_000_000.;
    flags = [ OpamTypes.Pkgflag_Deprecated ];
  }

let package =
  Package.create ~name:(name "angstrom") ~version:(version "1.0") info

let strings = Alcotest.(list string)

let deps =
  Alcotest.(
    list
      (pair
         (testable Fmt.nop (fun a b -> Package.Name.compare a b = 0))
         (option string)))

let test_accessors () =
  Alcotest.(check string) "synopsis" info.synopsis (Package.synopsis package);
  Alcotest.(check string)
    "description" info.description
    (Package.description package);
  Alcotest.check strings "authors" info.authors (Package.authors package);
  Alcotest.check strings "maintainers" info.maintainers
    (Package.maintainers package);
  Alcotest.(check string) "license" info.license (Package.license package);
  Alcotest.check strings "homepage" info.homepage (Package.homepage package);
  Alcotest.check strings "tags" info.tags (Package.tags package);
  Alcotest.check deps "dependencies" info.dependencies
    (Package.dependencies package);
  Alcotest.check deps "depopts" info.depopts (Package.depopts package);
  Alcotest.check deps "conflicts" info.conflicts (Package.conflicts package);
  Alcotest.(check bool)
    "rev_deps" true
    (info.rev_deps = Package.rev_deps package);
  Alcotest.(check int) "rev_deps_count" 2 (Package.rev_deps_count package);
  Alcotest.(check bool) "url" true (info.url = Package.url package);
  Alcotest.(check (float 0.))
    "publication" info.publication
    (Package.publication package);
  Alcotest.(check bool) "flags" true (info.flags = Package.flags package)

let test_stats_absent () =
  let state = Package.mockup_state [ package ] in
  Alcotest.(check bool) "no stats" true (Package.stats state = None);
  Alcotest.(check int) "count_latest" 1 (Package.count_latest state)

let () =
  Alcotest.run "accessors"
    [
      ( "accessors",
        [
          Alcotest.test_case "every field" `Quick test_accessors;
          Alcotest.test_case "count and stats" `Quick test_stats_absent;
        ] );
    ]
