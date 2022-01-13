open Import
open Lwt.Syntax
module StringMap = Map.Make (String)

type package_stat =
  { name : OpamPackage.Name.t
  ; version : OpamPackage.Version.t
  ; info : Info.t
  }

type t =
  { nb_packages : int
  ; nb_update_week : int
  ; nb_packages_month : int
  ; newest_packages : (package_stat * string) list
  ; recently_updated : package_stat list
  ; most_revdeps : (package_stat * int) list
  }

let package_of_path p =
  match Fpath.segs p with
  | "packages" :: namespace :: name_version :: _ ->
    (match OpamPackage.of_string_opt name_version with
    | Some pkg ->
      Some (namespace, pkg)
    | None ->
      None)
  | _ ->
    None

let package_namespace_of_path p =
  match Fpath.segs p with
  | "packages" :: namespace :: _ ->
    Some namespace
  | _ ->
    None

(** Make a {!package_stat} from a {!OpamPackage.t}. *)
let mk_package_stat pkg packages =
  let name = OpamPackage.name pkg
  and version = OpamPackage.version pkg in
  try
    let info =
      OpamPackage.Name.Map.find name packages
      |> OpamPackage.Version.Map.find version
    in
    Some { name; version; info }
  with
  | Not_found ->
    (* Can happen if the package is added then removed, eg. 344f20e909. *)
    None

(** Look at the Git history and return the list of packages that have been
    modified (added or just changed) since the given [date]. Returns the list of
    versions affected for each packages, lastest version first, and the
    corresponding date (in Git's relative format). The packages are ordered
    according to the history, most recently modified first. *)
let compute_updated_packages_since date =
  let module StringMap = Map.Make (String) in
  let module VersionMap = OpamPackage.Version.Map in
  let* commit = Opam_repository.commit_at_date date in
  let+ paths = Opam_repository.new_files_since ~a:commit ~b:"@" in
  (* Group all modified versions of each packages. Using [VersionMap] to sort
     versions. [acc] is indexed by [package_namespace_of_path path]. *)
  let group_versions_by_name acc (path, date) =
    match package_of_path path with
    | Some (key, pkg) ->
      let versions =
        try StringMap.find key acc with Not_found -> VersionMap.empty
      in
      let v = OpamPackage.version pkg in
      (* Keep the most recent version. Without this check, [date] wouldn't be
         the last modification date. *)
      if VersionMap.mem v versions then
        acc
      else
        let versions = VersionMap.add v (pkg, date) versions in
        StringMap.add key versions acc
    | _ ->
      acc
  in
  (* Iterate again on [paths] to preserve the order: most recently modified
     first. *)
  let acc_versions_of_path ((versions_by_name, acc) as acc') (path, _) =
    match package_namespace_of_path path with
    | Some key ->
      (match StringMap.find_opt key versions_by_name with
      | Some versions ->
        (* Lastest version first. *)
        let versions = List.rev (VersionMap.values versions) in
        (* Remove to be sure to keep the most recent modification for each
           packages. *)
        StringMap.remove key versions_by_name, versions :: acc
      | None ->
        acc')
    | None ->
      acc'
  in
  let versions_by_name =
    List.fold_left group_versions_by_name StringMap.empty paths
  in
  List.fold_left acc_versions_of_path (versions_by_name, []) paths
  |> snd
  |> List.rev

(** Newly added packages. Most recent first. *)
let compute_new_packages_since date =
  let+ packages = compute_updated_packages_since date in
  (* Keep packages that only have new versions. *)
  let filter_new_packages acc modified_versions =
    let pkg, _ = List.hd modified_versions in
    let name = OpamPackage.(Name.to_string (name pkg)) in
    let all_versions = Opam_repository.list_package_versions name in
    if List.length modified_versions >= List.length all_versions then
      List.rev_append modified_versions acc (* [acc] is in reverse order *)
    else
      acc
  in
  List.fold_left filter_new_packages [] packages |> List.rev

(** Count the number of updates. *)
let compute_nb_updates updt_packages =
  let count_updates acc versions = acc + List.length versions in
  List.fold_left count_updates 0 updt_packages

(** The lastest version of the [n] most recently updated packages. *)
let compute_recently_updated n updt_packages packages =
  let lastest_version versions =
    let pkg, _ = List.hd versions in
    mk_package_stat pkg packages
  in
  List.take n updt_packages |> List.filter_map lastest_version

let compute_newest_packages n new_packages packages =
  let mk_package (pkg, date) =
    mk_package_stat pkg packages |> Option.map (fun p -> p, date)
  in
  List.take n new_packages |> List.filter_map mk_package

(** Remove some packages from the revdeps stats to make it more interesting. *)
let most_revdeps_hidden = function
  | "ocaml" | "ocamlfind" | "dune" | "ocamlbuild" | "jbuilder" ->
    true
  | _ ->
    false

let compute_most_revdeps n packages =
  let module Acc =
    Acc_biggest (struct
      type t = package_stat * int

      let compare (_, a) (_, b) = Int.compare a b
    end)
  in
  OpamPackage.Name.Map.fold
    (fun name versions acc ->
      (* Do not count some packages. *)
      if most_revdeps_hidden (OpamPackage.Name.to_string name) then
        acc
      else (* Look only at the lastest version. *)
        let version, info = OpamPackage.Version.Map.max_binding versions in
        let rev_deps = List.length info.Info.rev_deps in
        Acc.acc ({ name; version; info }, rev_deps) acc)
    packages
    (Acc.make n)
  |> Acc.to_list
  |> List.rev

let compute packages =
  let+ updated_pkgs = compute_updated_packages_since "7.days"
  and+ new_pkgs = compute_new_packages_since "30.days" in
  { nb_packages = OpamPackage.Name.Map.cardinal packages
  ; nb_update_week = compute_nb_updates updated_pkgs
  ; recently_updated = compute_recently_updated 5 updated_pkgs packages
  ; nb_packages_month = List.length new_pkgs
  ; newest_packages = compute_newest_packages 5 new_pkgs packages
  ; most_revdeps = compute_most_revdeps 5 packages
  }
