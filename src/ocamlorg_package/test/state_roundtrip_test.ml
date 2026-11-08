module Package = Ocamlorg_package

let name = Package.Name.of_string

(* Every field is non-empty, so that comparing whole states shows each one
   survives the round-trip. *)
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
    rev_deps =
      [
        (name "gamma", Some {|>= "1.0"|}, Package.Version.of_string "1.2");
        (name "delta", None, Package.Version.of_string "0.1");
      ];
    depopts = [ (name "lwt", None); (name "async", Some {|< "1.0"|}) ];
    conflicts = [ (name "base-no-ppx", None) ];
    url =
      Some
        {
          Package.Info.uri = "https://example.org/x.tbz";
          checksum =
            [
              "md5=d41d8cd98f00b204e9800998ecf8427e";
              "sha256=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
            ];
        };
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
        ~dependencies:[ dep "dune"; dep "fmt"; (name "ocamlfind", None) ]
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

let test_background_save () =
  with_temp_file (fun path ->
      let original = sample_state () in
      Lwt_main.run (Package.save_state_in_background_to path original);
      Alcotest.(check (list string))
        "versions survive a background save"
        (versions_of original "alpha")
        (versions_of (Package.load_state_from path) "alpha");
      (* Every Git call goes through [Lwt_process], which forks. Saving in a
         domain would make OCaml 5 refuse [Unix.fork] from then on. *)
      Alcotest.(check string)
        "a subprocess still runs after a background save" "ok"
        (String.trim
           (Lwt_main.run (Lwt_process.pread ("echo", [| "echo"; "ok" |])))))

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

(* The state is written in place, so a write interrupted by a restart leaves a
   prefix of it. *)
let test_truncated_file_is_empty_state () =
  with_temp_file (fun path ->
      Package.save_state_to path (sample_state ());
      let full =
        In_channel.with_open_bin (Fpath.to_string path) In_channel.input_all
      in
      let n = String.length full in
      List.iter
        (fun len ->
          Out_channel.with_open_bin (Fpath.to_string path) (fun oc ->
              Out_channel.output_string oc (String.sub full 0 len));
          Alcotest.(check (list string))
            (Printf.sprintf "%d of %d bytes yield an empty state" len n)
            []
            (versions_of (Package.load_state_from path) "alpha"))
        (List.sort_uniq compare [ 0; 1; n / 4; n / 2; n - 1 ]))

(* Every version of every package, with its whole info. [Info.t] is plain data,
   so polymorphic equality compares every field, including fields added
   later. *)
let all_infos state =
  Package.all_latest state
  |> List.concat_map (fun latest ->
         Package.get_by_name state (Package.name latest)
         |> Option.value ~default:[])
  |> List.map (fun p ->
         ( Package.Name.to_string (Package.name p),
           Package.Version.to_string (Package.version p),
           Package.info p ))
  |> List.sort compare

let test_roundtrip_preserves_every_field () =
  with_temp_file (fun path ->
      let original = sample_state () in
      Package.save_state_to path original;
      let loaded = Package.load_state_from path in
      Alcotest.(check int)
        "number of versions" 3
        (List.length (all_infos original));
      Alcotest.(check bool)
        "every field of every version survives the round-trip" true
        (all_infos original = all_infos loaded))

let read_file path =
  In_channel.with_open_bin (Fpath.to_string path) In_channel.input_all

(* Binary -> state -> binary: the encoding is deterministic, so saving a loaded
   state writes the same bytes. *)
let test_resave_is_byte_identical () =
  with_temp_file (fun first ->
      with_temp_file (fun second ->
          Package.save_state_to first (sample_state ());
          Package.save_state_to second (Package.load_state_from first);
          Alcotest.(check bool)
            "saving a loaded state writes the same bytes" true
            (String.equal (read_file first) (read_file second))))

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
          test_case "every field is preserved"
            test_roundtrip_preserves_every_field;
          test_case "saving a loaded state is byte-identical"
            test_resave_is_byte_identical;
          test_case "background save, then a subprocess" test_background_save;
        ] );
      ( "fallback",
        [
          test_case "missing file yields empty state"
            test_missing_file_is_empty_state;
          test_case "corrupt file yields empty state"
            test_corrupt_file_is_empty_state;
          test_case "truncated file yields empty state"
            test_truncated_file_is_empty_state;
        ] );
    ]
