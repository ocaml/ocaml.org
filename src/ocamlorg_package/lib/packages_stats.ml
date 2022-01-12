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
  ; newest_packages : package_stat list
  ; recently_updated : package_stat list
  ; most_revdeps : (package_stat * int) list
  }

let package_of_path p =
  match Fpath.segs p with
  | "packages" :: _ :: name_version :: _ ->
    Some name_version
  | _ ->
    None

let compute_updates_since date =
  let* commit = Opam_repository.commit_at_date date in
  let+ paths = Opam_repository.new_files_since ~a:commit ~b:"@" in
  List.filter_map package_of_path paths
  |> List.sort_uniq String.compare
  |> List.length

(** Newly added packages. Most recent first. *)
let compute_new_packages_since date =
  let module NameMap = OpamPackage.Name.Map in
  let* commit = Opam_repository.commit_at_date date in
  let+ paths = Opam_repository.new_files_since ~a:commit ~b:"@" in
  let of_path path = package_of_path path |> Option.map OpamPackage.of_string in
  let packages = List.filter_map of_path paths in
  let new_versions =
    (* Count the number of new versions for each packages. *)
    let count_new_versions acc pkg =
      let name = OpamPackage.name pkg in
      let n = try NameMap.find name acc with Not_found -> 0 in
      NameMap.add name (n + 1) acc
    in
    List.fold_left count_new_versions NameMap.empty packages
  in
  (* Keep packages that only have new versions. *)
  packages
  |> List.filter (fun pkg ->
         let name = OpamPackage.name pkg in
         let new_versions = NameMap.find name new_versions in
         let all_versions =
           Opam_repository.list_package_versions
             (OpamPackage.Name.to_string name)
         in
         new_versions >= List.length all_versions)

module Acc_biggest (Elt : sig
  type t

  val compare : t -> t -> int
end) : sig
  (** Accumulate the [n] bigger elements given to [acc]. *)

  type elt = Elt.t

  type t

  val make : int -> t

  val acc : elt -> t -> t

  val to_list : t -> elt list
end = struct
  type elt = Elt.t

  type t = int * elt list

  let make size = size, []

  (* Insert sort is enough. *)
  let rec insert_sort elt = function
    | [] ->
      [ elt ]
    | hd :: _ as t when Elt.compare hd elt >= 0 ->
      elt :: t
    | hd :: tl ->
      hd :: insert_sort elt tl

  let acc elt (rem, elts) =
    let elts = insert_sort elt elts in
    if rem = 0 then 0, List.tl elts else rem - 1, elts

  let to_list (_, elts) = elts
end

let rec list_take n = function
  | _ when n = 0 ->
    []
  | [] ->
    []
  | hd :: tl ->
    hd :: list_take (n - 1) tl

let compute_newest_packages n new_packages packages =
  let mk_package pkg =
    let name = OpamPackage.name pkg
    and version = OpamPackage.version pkg in
    let info =
      OpamPackage.Name.Map.find name packages
      |> OpamPackage.Version.Map.find version
    in
    { name; version; info }
  in
  list_take n new_packages |> List.map mk_package

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
  let nb_packages = OpamPackage.Name.Map.cardinal packages in
  let+ nb_update_week = compute_updates_since "7.days"
  and+ nb_packages_month, newest_packages =
    let+ new_pkgs = compute_new_packages_since "30.days" in
    List.length new_pkgs, compute_newest_packages 5 new_pkgs packages
  in
  let recently_updated = []
  and most_revdeps = compute_most_revdeps 5 packages in
  { nb_packages
  ; nb_update_week
  ; nb_packages_month
  ; newest_packages
  ; recently_updated
  ; most_revdeps
  }
