type url = { uri : string; checksum : string list } [@@deriving repr]

(* This is used to invalidate the package state cache if one of the types
   [Info.t] or [Ocamlorg_package.state] has changed. *)
let version = "6"

type t = {
  synopsis : string;
  description : string;
  authors : string list;
  maintainers : string list;
  license : string;
  homepage : string list;
  tags : string list;
  dependencies :
    ((OpamPackage.Name.t[@repr Opam_repr.name]) * string option) list;
  rev_deps :
    ((OpamPackage.Name.t[@repr Opam_repr.name])
    * string option
    * (OpamPackage.Version.t[@repr Opam_repr.version]))
    list;
  depopts : ((OpamPackage.Name.t[@repr Opam_repr.name]) * string option) list;
  conflicts : ((OpamPackage.Name.t[@repr Opam_repr.name]) * string option) list;
  url : url option;
  publication : float;
  flags : (OpamTypes.package_flag[@repr Opam_repr.package_flag]) list;
}
[@@deriving repr]

let relop_to_string = OpamPrinter.FullPos.relop_kind
let filter_to_string = OpamFilter.to_string

(* The parser keeps parentheses as [Block] nodes, and the printer adds its own
   around some atoms, such as a negation. Printing a parsed formula as is, then
   parsing it again, would add a pair of parentheses each time. Keep only the
   [Block]s that group an [And] or an [Or], so that printing the parsed result
   gives the same string. *)
let rec tidy_blocks = function
  | OpamFormula.Block f -> (
      match tidy_blocks f with
      | (OpamFormula.Block _ | Atom _ | Empty) as f -> f
      | f -> Block f)
  | And (a, b) -> And (tidy_blocks a, tidy_blocks b)
  | Or (a, b) -> Or (tidy_blocks a, tidy_blocks b)
  | (Empty | Atom _) as f -> f

let string_of_formula = function
  | OpamFormula.Empty -> None
  | formula ->
      Some
        (OpamFormula.string_of_formula
           (function
             | OpamTypes.Filter f -> filter_to_string f
             | Constraint (relop, f) ->
                 relop_to_string relop ^ " " ^ filter_to_string f)
           (tidy_blocks formula))

let parse_formula =
  OpamFormula.fold_left
    (fun lst (name, cstr) -> (name, string_of_formula cstr) :: lst)
    []

module Lwt_fold = struct
  let fold fn =
    let open Lwt.Syntax in
    Lwt_list.fold_left_s (fun acc (key, value) ->
        let* () = Lwt.pause () in
        fn key value acc)

  let package_name_map fn map init =
    OpamPackage.Name.Map.bindings map |> fold fn init
end

let get_conflicts (opam : OpamFile.OPAM.t) =
  let data = OpamFile.OPAM.conflicts opam in
  parse_formula data

let get_dependencies (opam : OpamFile.OPAM.t) =
  let data = OpamFile.OPAM.depends opam in
  parse_formula data

let get_depopts (opam : OpamFile.OPAM.t) =
  let data = OpamFile.OPAM.depopts opam in
  parse_formula data

(* Every package version gets an integer id, in [OpamPackage.compare] order, so
   that the versions of a name have consecutive ids. Building the reverse
   dependencies on ids instead of [OpamPackage.t] keys avoids most name and
   version comparisons, which dominated the rebuild's profile. The index is the
   only place where ids are assigned: every pass reads them from [ranges]. *)
type index = {
  packages : OpamPackage.t array;
  ranges : (int * int) OpamPackage.Name.Map.t;
      (** For each name, the id of its first version and its number of versions. *)
}

(* [packages] must be sorted by [OpamPackage.compare]. *)
let index_of_packages packages =
  let packages = Array.of_list packages in
  let ranges = ref OpamPackage.Name.Map.empty in
  Array.iteri
    (fun id pkg ->
      let name = OpamPackage.name pkg in
      ranges :=
        OpamPackage.Name.Map.update name
          (fun (first, count) -> (first, count + 1))
          (id, 0) !ranges)
    packages;
  { packages; ranges = !ranges }

let index opams =
  OpamPackage.Name.Map.fold
    (fun name vmap acc ->
      OpamPackage.Version.Map.fold
        (fun version _ acc -> OpamPackage.create name version :: acc)
        vmap acc)
    opams []
  |> List.rev |> index_of_packages

(* [iter_ids index name vmap f] calls [f id version v] for every binding of
   [vmap], the versions of [name], with the id that [index] gives it. *)
let iter_ids index name vmap f =
  let first, count = OpamPackage.Name.Map.find name index.ranges in
  for id = first to first + count - 1 do
    let version = OpamPackage.version index.packages.(id) in
    f id version (OpamPackage.Version.Map.find version vmap)
  done

(* [iter_matching index formula f] calls [f] on the id of every version that
   [OpamFormula.packages] returns for [formula], evaluating the same per-name
   DNF directly on the consecutive ids of each name. Tested against
   [OpamFormula.packages] in [packages_matching_test.ml]. *)
let iter_matching index formula f =
  let open OpamTypes in
  let dnf = OpamFormula.dnf_of_formula formula in
  OpamPackage.Name.Set.iter
    (fun dep ->
      match OpamPackage.Name.Map.find_opt dep index.ranges with
      | None -> ()
      | Some (first, count) ->
          let name_formula =
            OpamFormula.map
              (fun ((n, _) as a) -> if n = dep then Atom a else Empty)
              dnf
          in
          for target = first to first + count - 1 do
            let v = OpamPackage.version index.packages.(target) in
            if
              OpamFormula.eval
                (fun (_, cstr) -> OpamFormula.check_version_formula cstr v)
                name_formula
            then f target
          done)
    (OpamFormula.all_names formula)

let packages_matching packages formula =
  let index = index_of_packages (OpamPackage.Set.elements packages) in
  let matching = ref OpamPackage.Set.empty in
  iter_matching index formula (fun id ->
      matching := OpamPackage.Set.add index.packages.(id) !matching);
  !matching

(* [rev_dependencies index opams] maps each id to the ids of the versions that
   depend on it, in decreasing order. A version depends on the versions that
   [OpamFormula.packages] would return for its filtered [depends] formula. It
   runs on the server's event loop during each rebuild, so it yields between
   package names (see ocaml/ocaml.org#3959). *)
let rev_dependencies index opams =
  let open OpamTypes in
  let rdeps = Array.make (Array.length index.packages) [] in
  let open Lwt.Syntax in
  let+ () =
    Lwt_fold.package_name_map
      (fun name vmap () ->
        iter_ids index name vmap (fun id version opam ->
            let env v =
              match OpamVariable.Full.to_string v with
              | "name" -> Some (S (OpamPackage.Name.to_string name))
              | "version" -> Some (S (OpamPackage.Version.to_string version))
              | _ -> None
            in
            let formula =
              OpamFilter.filter_formula ~default:true env
                (OpamFile.OPAM.depends opam)
            in
            iter_matching index formula (fun target ->
                rdeps.(target) <- id :: rdeps.(target)));
        Lwt.return_unit)
      opams ()
  in
  rdeps

let rev_dep_entry versions_of_name name versions =
  let open OpamTypes in
  let formula =
    OpamFormula.formula_of_version_set
      (OpamPackage.Name.Map.find name versions_of_name)
      versions
    |> OpamFormula.map (fun (op, v) ->
           Atom (Constraint (op, FString (OpamPackage.Version.to_string v))))
  in
  (name, string_of_formula formula, OpamPackage.Version.Set.max_elt versions)

(* [sources] are ids in decreasing order, so the versions of each name are
   consecutive and names come out in increasing order. *)
let mk_revdeps index versions_of_name sources =
  let flush acc = function
    | None -> acc
    | Some (name, versions) ->
        rev_dep_entry versions_of_name name versions :: acc
  in
  let acc, current =
    List.fold_left
      (fun (acc, current) id ->
        let pkg = index.packages.(id) in
        let name = OpamPackage.name pkg and version = OpamPackage.version pkg in
        match current with
        | Some (n, versions) when OpamPackage.Name.equal n name ->
            (acc, Some (n, OpamPackage.Version.Set.add version versions))
        | _ ->
            ( flush acc current,
              Some (name, OpamPackage.Version.Set.singleton version) ))
      ([], None) sources
  in
  flush acc current

let make ~package ~rev_deps ~timestamps opam =
  let publication = OpamPackage.Map.find package timestamps in
  let open OpamFile.OPAM in
  {
    synopsis = synopsis opam |> Option.value ~default:"No synopsis";
    authors = author opam;
    maintainers = maintainer opam;
    license = license opam |> String.concat "; ";
    description =
      descr opam |> Option.map OpamFile.Descr.body |> Option.value ~default:"";
    homepage = homepage opam;
    tags = tags opam;
    rev_deps;
    conflicts = get_conflicts opam;
    dependencies = get_dependencies opam;
    depopts = get_depopts opam;
    url =
      url opam
      |> Option.map (fun url ->
             {
               uri = OpamUrl.to_string (OpamFile.URL.url url);
               checksum =
                 OpamFile.URL.checksum url |> List.map OpamHash.to_string;
             });
    publication;
    flags = flags opam;
  }

let time_it_lwt name f =
  let open Lwt.Syntax in
  let t0 = Unix.gettimeofday () in
  let+ result = f () in
  let t1 = Unix.gettimeofday () in
  Logs.info (fun log -> log "%s: %.2fs" name (t1 -. t0));
  result

let of_opamfiles ~timestamps
    (opams : OpamFile.OPAM.t OpamPackage.Version.Map.t OpamPackage.Name.Map.t) =
  let open Lwt.Syntax in
  let index = index opams in
  let* rdeps =
    time_it_lwt "Reverse dependencies" (fun () -> rev_dependencies index opams)
  in
  let versions_of_name =
    OpamPackage.Name.Map.map
      (fun vmap ->
        OpamPackage.Version.Set.of_list (OpamPackage.Version.Map.keys vmap))
      opams
  in
  time_it_lwt "Generate package info" (fun () ->
      Lwt_fold.package_name_map
        (fun name vmap acc ->
          let first, count = OpamPackage.Name.Map.find name index.ranges in
          let rec versions id vs =
            if id = first + count then Lwt.return vs
            else
              let* () = Lwt.pause () in
              let package = index.packages.(id) in
              let version = OpamPackage.version package in
              let opam = OpamPackage.Version.Map.find version vmap in
              let rev_deps = mk_revdeps index versions_of_name rdeps.(id) in
              (* Read once: let the GC reclaim the list now. *)
              rdeps.(id) <- [];
              let t = make ~rev_deps ~package ~timestamps opam in
              versions (id + 1) (OpamPackage.Version.Map.add version t vs)
          in
          let+ vs = versions first OpamPackage.Version.Map.empty in
          OpamPackage.Name.Map.add name vs acc)
        opams OpamPackage.Name.Map.empty)
