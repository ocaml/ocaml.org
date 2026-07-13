module Package = Ocamlorg_package

let info ?(publication = 0.) ?(flags = []) () =
  {
    Package.Info.synopsis = "";
    description = "";
    authors = [];
    maintainers = [];
    license = "";
    homepage = [];
    tags = [];
    dependencies = [];
    rev_deps = [];
    depopts = [];
    conflicts = [];
    url = None;
    publication;
    flags;
  }

let package ?publication ?flags name version =
  Package.create
    ~name:(Package.Name.of_string name)
    ~version:(Package.Version.of_string version)
    (info ?publication ?flags ())

let latest_version state name =
  Package.get_latest state (Package.Name.of_string name)
  |> Option.map Package.version
  |> Option.map Package.Version.to_string

let check_latest expected state name =
  Alcotest.(check (option string))
    ("latest version of " ^ name)
    (Some expected)
    (latest_version state name)

let avoid_version = OpamTypes.Pkgflag_AvoidVersion
let deprecated = OpamTypes.Pkgflag_Deprecated

let test_avoided_version_is_not_latest () =
  let state =
    Package.mockup_state
      [
        package "example" "1.0.0";
        package ~flags:[ avoid_version ] "example" "2.0.0";
      ]
  in
  check_latest "1.0.0" state "example"

let test_deprecated_version_is_not_latest () =
  let state =
    Package.mockup_state
      [
        package "example" "1.0.0";
        package ~flags:[ deprecated ] "example" "2.0.0";
      ]
  in
  check_latest "1.0.0" state "example"

let test_all_discouraged_versions_fall_back_to_highest () =
  let state =
    Package.mockup_state
      [
        package ~flags:[ avoid_version ] "example" "1.0.0";
        package ~flags:[ deprecated ] "example" "2.0.0";
      ]
  in
  check_latest "2.0.0" state "example"

let test_all_latest_matches_get_latest () =
  let state =
    Package.mockup_state
      [
        package "alpha" "1.0.0";
        package ~flags:[ avoid_version ] "alpha" "2.0.0";
        package ~flags:[ deprecated ] "beta" "1.0.0";
        package ~flags:[ deprecated ] "beta" "2.0.0";
      ]
  in
  let all_latest = Package.all_latest state in
  Alcotest.(check int) "one version per package" 2 (List.length all_latest);
  List.iter
    (fun latest ->
      let name = Package.name latest |> Package.Name.to_string in
      Alcotest.(check (option string))
        ("all_latest agrees for " ^ name)
        (latest_version state name)
        (Some (Package.version latest |> Package.Version.to_string)))
    all_latest

let string_of_status = function
  | Package.Avoided -> "avoided"
  | Package.Deprecated -> "deprecated"

let test_version_summaries_include_statuses_and_dates () =
  let state =
    Package.mockup_state
      [
        package ~publication:1. "example" "1.0.0";
        package ~publication:2. ~flags:[ avoid_version ] "example" "2.0.0";
        package ~publication:3.
          ~flags:[ avoid_version; deprecated ]
          "example" "3.0.0";
      ]
  in
  match Package.get_versions state (Package.Name.of_string "example") with
  | [ both; avoided; preferred ] ->
      Alcotest.(check (list string))
        "versions remain in descending order"
        [ "3.0.0"; "2.0.0"; "1.0.0" ]
        (List.map
           (fun (summary : Package.version_summary) ->
             Package.Version.to_string summary.version)
           [ both; avoided; preferred ]);
      Alcotest.(check (list string))
        "both statuses are exposed"
        [ "avoided"; "deprecated" ]
        (List.map string_of_status both.statuses);
      Alcotest.(check (list string))
        "avoid-version is exposed" [ "avoided" ]
        (List.map string_of_status avoided.statuses);
      Alcotest.(check (list string))
        "preferred version has no discouraged status" []
        (List.map string_of_status preferred.statuses);
      Alcotest.(check (float 0.))
        "repository date is preserved" 3. both.opam_repository_date
  | versions ->
      Alcotest.failf "expected three version summaries, got %d"
        (List.length versions)

let test_case name fn = Alcotest.test_case name `Quick fn

let () =
  Alcotest.run "package versions"
    [
      ( "latest selection",
        [
          test_case "avoid-version is skipped"
            test_avoided_version_is_not_latest;
          test_case "deprecated is skipped"
            test_deprecated_version_is_not_latest;
          test_case "all discouraged versions use the highest fallback"
            test_all_discouraged_versions_fall_back_to_highest;
          test_case "all_latest uses the same selection"
            test_all_latest_matches_get_latest;
        ] );
      ( "version summaries",
        [
          test_case "statuses and repository dates are exposed"
            test_version_summaries_include_statuses_and_dates;
        ] );
    ]
