type url = { uri : string; checksum : string list }

(* This is used to invalidate the package state cache if one of the types
   [Info.t] or [Ocamlorg_package.state] has changed. *)
let version = "4"

type t = {
  synopsis : string;
  description : string;
  authors : string list;
  maintainers : string list;
  license : string;
  homepage : string list;
  tags : string list;
  dependencies : (OpamPackage.Name.t * string option) list;
  rev_deps : (OpamPackage.Name.t * string option * OpamPackage.Version.t) list;
  depopts : (OpamPackage.Name.t * string option) list;
  conflicts : (OpamPackage.Name.t * string option) list;
  url : url option;
  publication : float;
  flags : OpamTypes.package_flag list;
}

let relop_to_string = OpamPrinter.FullPos.relop_kind
let filter_to_string = OpamFilter.to_string

let string_of_formula = function
  | OpamFormula.Empty -> None
  | formula ->
      Some
        (OpamFormula.string_of_formula
           (function
             | OpamTypes.Filter f -> filter_to_string f
             | Constraint (relop, f) ->
                 relop_to_string relop ^ " " ^ filter_to_string f)
           formula)

let parse_formula =
  OpamFormula.fold_left
    (fun lst (name, cstr) -> (name, string_of_formula cstr) :: lst)
    []

let depends packages opams f =
  let open OpamTypes in
  OpamPackage.Name.Map.fold
    (fun name vmap acc ->
      let v =
        OpamPackage.Version.Map.fold
          (fun version opam acc ->
            let env v =
              match OpamVariable.Full.to_string v with
              | "name" -> Some (S (OpamPackage.Name.to_string name))
              | "version" -> Some (S (OpamPackage.Version.to_string version))
              | _ -> None
            in
            let deps =
              OpamFormula.packages packages
              @@ OpamFilter.filter_formula ~default:true env (f opam)
            in
            OpamPackage.Map.add (OpamPackage.create name version) deps acc)
          vmap OpamPackage.Map.empty
      in
      OpamPackage.Map.union (fun a _ -> a) acc v)
    opams OpamPackage.Map.empty

let get_dependency_set pkgs map =
  let f opam = OpamFile.OPAM.depends opam in
  depends pkgs map f

let get_conflicts (opam : OpamFile.OPAM.t) =
  let data = OpamFile.OPAM.conflicts opam in
  parse_formula data

let get_dependencies (opam : OpamFile.OPAM.t) =
  let data = OpamFile.OPAM.depends opam in
  parse_formula data

let get_depopts (opam : OpamFile.OPAM.t) =
  let data = OpamFile.OPAM.depopts opam in
  parse_formula data

module Lwt_fold = struct
  let fold fn =
    let open Lwt.Syntax in
    Lwt_list.fold_left_s (fun acc (key, value) ->
        let* () = Lwt.pause () in
        fn key value acc)

  let package_map fn map init = OpamPackage.Map.bindings map |> fold fn init

  let package_name_map fn map init =
    OpamPackage.Name.Map.bindings map |> fold fn init

  let package_version_map fn map init =
    OpamPackage.Version.Map.bindings map |> fold fn init
end

let rev_depends deps =
  Lwt_fold.package_map
    (fun pkg version acc ->
      Lwt.return
      @@ OpamPackage.Set.fold
           (fun pkg1 ->
             OpamPackage.Map.update pkg1 (OpamPackage.Set.add pkg)
               OpamPackage.Set.empty)
           version acc)
    deps OpamPackage.Map.empty

let mk_revdeps pkg pkgs rdepends =
  let open OpamTypes in
  Lwt_fold.package_name_map
    (fun name versions acc ->
      let vf =
        OpamFormula.formula_of_version_set
          (OpamPackage.versions_of_name pkgs name)
          versions
      in
      let latest = OpamPackage.Version.Set.max_elt versions in
      let flags = OpamStd.String.Set.empty in
      let formula =
        OpamFormula.ands
        @@ List.rev_append
             (List.rev_map
                (fun flag ->
                  Atom (Filter (FIdent ([], OpamVariable.of_string flag, None))))
                (OpamStd.String.Set.elements flags))
             [
               OpamFormula.map
                 (fun (op, v) ->
                   Atom
                     (Constraint (op, FString (OpamPackage.Version.to_string v))))
                 vf;
             ]
      in
      Lwt.return @@ ((name, string_of_formula formula, latest) :: acc))
    (OpamPackage.to_map
    @@ OpamStd.Option.default OpamPackage.Set.empty
    @@ OpamPackage.Map.find_opt pkg rdepends)
    []
  |> Lwt.map List.rev

let make ~package ~packages ~rev_deps ~timestamps opam =
  let open Lwt.Syntax in
  let+ rev_deps = mk_revdeps package packages rev_deps in
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

let time_it name f =
  let t0 = Unix.gettimeofday () in
  let result = f () in
  let t1 = Unix.gettimeofday () in
  Logs.info (fun log -> log "%s: %.2fs" name (t1 -. t0));
  result

let time_it_lwt name f =
  let open Lwt.Syntax in
  let t0 = Unix.gettimeofday () in
  let+ result = f () in
  let t1 = Unix.gettimeofday () in
  Logs.info (fun log -> log "%s: %.2fs" name (t1 -. t0));
  result

let of_opamfiles
    (opams : OpamFile.OPAM.t OpamPackage.Version.Map.t OpamPackage.Name.Map.t) =
  let open Lwt.Syntax in
  let packages =
    let names = OpamPackage.Name.Map.keys opams in
    let f acc name =
      let versions =
        OpamPackage.Version.Map.keys (OpamPackage.Name.Map.find name opams)
      in
      let pkgs =
        List.fold_left
          (fun acc v -> OpamPackage.Set.add (OpamPackage.create name v) acc)
          OpamPackage.Set.empty versions
      in
      OpamPackage.Set.union pkgs acc
    in
    List.fold_left f OpamPackage.Set.empty names
  in
  let dependencies =
    time_it "Dependencies" (fun () -> get_dependency_set packages opams)
  in
  let* rev_deps =
    time_it_lwt "Reverse dependencies" (fun () -> rev_depends dependencies)
  in
  let* timestamps =
    time_it_lwt "Publication dates" (fun () ->
        Opam_repository.create_package_to_timestamp ())
  in
  time_it_lwt "Generate package info" (fun () ->
      Lwt_fold.package_name_map
        (fun name vmap acc ->
          let+ vs =
            Lwt_fold.package_version_map
              (fun version opam acc ->
                let package = OpamPackage.create name version in
                let+ t = make ~rev_deps ~packages ~package ~timestamps opam in
                OpamPackage.Version.Map.add version t acc)
              vmap OpamPackage.Version.Map.empty
          in
          OpamPackage.Name.Map.add name vs acc)
        opams OpamPackage.Name.Map.empty)
