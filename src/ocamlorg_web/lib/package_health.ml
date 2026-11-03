(* Build results from check.ci.ocaml.org (Data.Opam_health), shaped for the
   package pages, GraphQL and MCP. Everything here is pure over the packed data,
   so it is unit-tested directly. *)

module H = Data.Opam_health

(* check.ci runs weekly; past two weeks a run has been missed at least once. *)
let stale_after_days = 14.

(* opam's version order, so "1.10" > "1.9" and "1.0~beta" < "1.0". *)
let compare_versions a b =
  match
    ( Ocamlorg_package.Version.of_string_opt a,
      Ocamlorg_package.Version.of_string_opt b )
  with
  | Some a, Some b -> Ocamlorg_package.Version.compare a b
  | _ -> String.compare a b

let newest_first (a : H.release) (b : H.release) =
  compare_versions b.version a.version

(* Every checked version of a package, newest first. *)
let versions name = List.sort newest_first (H.versions name)

let find_version version =
  List.find_opt (fun (r : H.release) -> String.equal r.version version)

(* The packages check.ci never builds: the compiler and its options, which it
   installs before each check. Copied from [get_pkgs] in
   https://github.com/ocurrent/opam-health-check/blob/master/server/backend/check.ml *)
let not_checkable =
  [
    "ocaml";
    "ocaml-base-compiler";
    "ocaml-variants";
    "ocaml-beta";
    "ocaml-config";
    "ocaml-option-32bit";
    "ocaml-option-afl";
    "ocaml-option-bytecode-only";
    "ocaml-option-default-unsafe-string";
    "ocaml-option-flambda";
    "ocaml-option-fp";
    "ocaml-option-musl";
    "ocaml-option-nnp";
    "ocaml-option-nnpchecker";
    "ocaml-option-no-flat-float-array";
    "ocaml-option-spacetime";
    "ocaml-option-static";
    "ocaml-options-only-afl";
    "ocaml-options-only-flambda";
    "ocaml-options-only-flambda-fp";
    "ocaml-options-only-fp";
    "ocaml-options-only-nnp";
    "ocaml-options-only-nnpchecker";
    "ocaml-options-only-no-flat-float-array";
    "ocaml-options-vanilla";
  ]

(* [published] is when the viewed version entered opam-repository (Unix
   time). *)
let for_page ~now ~name ~version ~published : Ocamlorg_frontend.Build_status.t =
  match versions name with
  | [] ->
      if published > H.run.timestamp then Not_yet_checked
      else if List.mem name not_checkable then Cannot_be_checked
      else No_information
  | releases ->
      Results
        {
          current = find_version version releases;
          releases;
          stale = H.age_in_days ~now > stale_after_days;
          newer_than_checked =
            List.for_all
              (fun (r : H.release) -> compare_versions version r.version > 0)
              releases;
        }

(* The results for one version of a package, plus its other checked versions
   (newest first). [None] when check.ci has no data for any version. *)
type package_view = { current : H.release option; others : H.release list }

let for_package ~name ~version =
  match versions name with
  | [] -> None
  | releases ->
      Some
        {
          current = find_version version releases;
          others =
            List.filter
              (fun (r : H.release) -> not (String.equal r.version version))
              releases;
        }

(* Range queries across all packages, for the MCP tool
   ocaml_package_build_information. *)

type match_mode = Any | All

type query = {
  package : string option;  (** Exact name, or a glob with [*]. *)
  compiler_min : string option;  (** Inclusive. *)
  compiler_max : string option;  (** Inclusive. *)
  statuses : H.status list;  (** Empty: no status filter. *)
  match_mode : match_mode;
  latest_only : bool;
  limit : int;
  offset : int;
}

let default_query =
  {
    package = None;
    compiler_min = None;
    compiler_max = None;
    statuses = [];
    match_mode = Any;
    latest_only = true;
    limit = 50;
    offset = 0;
  }

let max_limit = 500

(* check.ci-style glob: [*] matches any (possibly empty) sequence. *)
let glob_matches pattern s =
  let re =
    String.split_on_char '*' pattern
    |> List.map Re.str
    |> List.fold_left
         (fun acc p ->
           match acc with
           | None -> Some [ p ]
           | Some l -> Some (p :: Re.(rep any) :: l))
         None
    |> Option.value ~default:[] |> List.rev
  in
  Re.execp (Re.compile (Re.whole_string (Re.seq re))) s

let compilers_in_range ~compiler_min ~compiler_max =
  List.filter
    (fun c ->
      Option.fold ~none:true
        ~some:(fun m -> H.compare_compiler c m >= 0)
        compiler_min
      && Option.fold ~none:true
           ~some:(fun m -> H.compare_compiler c m <= 0)
           compiler_max)
    H.run.compilers

type result = {
  compilers : string list;  (** The compilers in the requested range. *)
  total : int;
  results : (H.release * (string * H.status) list) list;
      (** One page; builds restricted to [compilers]. *)
}

let latest_per_package releases =
  let tbl = Hashtbl.create 8192 in
  List.iter
    (fun (r : H.release) ->
      match Hashtbl.find_opt tbl r.name with
      | Some prev when newest_first prev r <= 0 -> ()
      | _ -> Hashtbl.replace tbl r.name r)
    releases;
  Hashtbl.fold (fun _ r acc -> r :: acc) tbl []

let query ?(releases = H.releases) q =
  let compilers =
    compilers_in_range ~compiler_min:q.compiler_min ~compiler_max:q.compiler_max
  in
  let releases =
    match q.package with
    | None -> releases
    | Some p when String.contains p '*' ->
        List.filter (fun (r : H.release) -> glob_matches p r.name) releases
    | Some p ->
        List.filter (fun (r : H.release) -> String.equal p r.name) releases
  in
  let releases =
    if q.latest_only then latest_per_package releases else releases
  in
  let in_range r =
    List.filter (fun (c, _) -> List.mem c compilers) (H.builds r)
  in
  let keep builds =
    match q.statuses with
    | [] -> true
    | wanted -> (
        let ok (_, s) = List.mem s wanted in
        match q.match_mode with
        | Any -> List.exists ok builds
        | All -> builds <> [] && List.for_all ok builds)
  in
  let matching =
    List.filter_map
      (fun r ->
        let builds = in_range r in
        if keep builds then Some (r, builds) else None)
      releases
    |> List.sort (fun ((a : H.release), _) ((b : H.release), _) ->
           match String.compare a.name b.name with
           | 0 -> newest_first a b
           | c -> c)
  in
  let page =
    List.filteri (fun i _ -> i >= q.offset && i < q.offset + q.limit) matching
  in
  { compilers; total = List.length matching; results = page }
