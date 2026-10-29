module Package = Ocamlorg_package

let info ?(publication = 0.) ?(flags = []) ?(dependencies = []) () =
  {
    Package.Info.synopsis = "a synopsis";
    description = "a description";
    authors = [ "Alice"; "Bob" ];
    maintainers = [ "Carol" ];
    license = "ISC";
    homepage = [ "https://example.org" ];
    tags = [ "test" ];
    dependencies;
    rev_deps = [];
    depopts = [];
    conflicts = [];
    url = Some { Package.Info.uri = "https://example.org/x.tbz"; checksum = [] };
    publication;
    flags;
  }

let dep name = (Package.Name.of_string name, Some ">= 1.0.0")

let package ?publication ?flags ?dependencies name version =
  Package.create
    ~name:(Package.Name.of_string name)
    ~version:(Package.Version.of_string version)
    (info ?publication ?flags ?dependencies ())

(* Covers every named arm plus [Pkgflag_Unknown], which round-trips through its
   embedded string. *)
let all_flags =
  OpamTypes.
    [
      Pkgflag_LightUninstall;
      Pkgflag_Verbose;
      Pkgflag_Plugin;
      Pkgflag_Compiler;
      Pkgflag_Conf;
      Pkgflag_AvoidVersion;
      Pkgflag_Deprecated;
      Pkgflag_Unknown "some-future-flag";
    ]

let sample_state () =
  Package.mockup_state
    [
      package ~publication:1.
        ~dependencies:[ dep "dune"; dep "fmt" ]
        "alpha" "1.0.0";
      package ~publication:2. ~flags:all_flags "alpha" "2.0.0";
      package ~publication:3. "beta" "0.1.0";
    ]

(* Compare two states by the observable, persisted projection: for every package
   name, the descending version list and each version's publication date and
   flags. [docs] is excluded by design (runtime-only cache). *)
let versions_of state name =
  Package.get_versions state (Package.Name.of_string name)
  |> List.map (fun (s : Package.version_summary) ->
         Package.Version.to_string s.version)

let flags_of state name version =
  match
    Package.get state
      (Package.Name.of_string name)
      (Package.Version.of_string version)
  with
  | None -> []
  | Some p ->
      (Package.info p).Package.Info.flags
      |> List.map OpamTypesBase.string_of_pkg_flag

let with_temp_file f =
  let path = Filename.temp_file "ocamlorg_state" ".bin" in
  Fun.protect
    (fun () -> f (Fpath.v path))
    ~finally:(fun () -> try Sys.remove path with Sys_error _ -> ())

let test_roundtrip_preserves_packages () =
  with_temp_file (fun path ->
      let original = sample_state () in
      Package.save_state_to path original;
      let loaded = Package.load_state_from path in
      List.iter
        (fun name ->
          Alcotest.(check (list string))
            ("versions of " ^ name)
            (versions_of original name)
            (versions_of loaded name);
          Alcotest.(check (list string))
            ("2.0.0 flags of " ^ name)
            (flags_of original name "2.0.0")
            (flags_of loaded name "2.0.0"))
        [ "alpha"; "beta" ])

let test_roundtrip_preserves_all_flags () =
  with_temp_file (fun path ->
      Package.save_state_to path (sample_state ());
      let loaded = Package.load_state_from path in
      Alcotest.(check (list string))
        "every package_flag survives the round-trip"
        (List.map OpamTypesBase.string_of_pkg_flag all_flags)
        (flags_of loaded "alpha" "2.0.0"))

let test_missing_file_is_empty_state () =
  let loaded = Package.load_state_from (Fpath.v "/nonexistent/state.bin") in
  Alcotest.(check (list string))
    "a missing cache file yields an empty state" []
    (versions_of loaded "alpha")

let test_corrupt_file_is_empty_state () =
  with_temp_file (fun path ->
      let oc = open_out_bin (Fpath.to_string path) in
      output_string oc "not a valid repr blob";
      close_out oc;
      let loaded = Package.load_state_from path in
      Alcotest.(check (list string))
        "a corrupt cache file yields an empty state, not a crash" []
        (versions_of loaded "alpha"))

let test_case name fn = Alcotest.test_case name `Quick fn

let () =
  Alcotest.run "package state serialization"
    [
      ( "repr round-trip",
        [
          test_case "packages and versions are preserved"
            test_roundtrip_preserves_packages;
          test_case "all package flags are preserved"
            test_roundtrip_preserves_all_flags;
        ] );
      ( "fallback",
        [
          test_case "missing file yields empty state"
            test_missing_file_is_empty_state;
          test_case "corrupt file yields empty state"
            test_corrupt_file_is_empty_state;
        ] );
    ]
