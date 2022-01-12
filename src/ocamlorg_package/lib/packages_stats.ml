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
  | "packages" :: namespace :: name_version :: _ ->
    Some (namespace, name_version)
  | _ ->
    None

let compute_updates_since date =
  let* commit = Opam_repository.commit_at_date date in
  let+ paths = Opam_repository.new_files_since ~a:commit ~b:"@" in
  List.filter_map package_of_path paths
  |> List.map snd
  |> List.sort_uniq String.compare
  |> List.length

let compute_new_packages_since date =
  let* commit = Opam_repository.commit_at_date date in
  let+ paths = Opam_repository.new_files_since ~a:commit ~b:"@" in
  let new_versions =
    List.filter_map package_of_path paths
    |> List.fold_left
         (fun acc (name, name_version) ->
           (* Group versions by package name. *)
           let pkgs = try StringMap.find name acc with Not_found -> [] in
           StringMap.add name (name_version :: pkgs) acc)
         StringMap.empty
  in
  let new_packages =
    StringMap.fold
      (fun name new_versions acc ->
        (* Keep packages that have only new versions. *)
        let all_versions = Opam_repository.list_package_versions name in
        if List.length new_versions >= List.length all_versions then
          name :: acc
        else
          acc)
      new_versions
      []
  in
  List.length new_packages

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

let compute_most_revdeps n packages =
  let module Acc =
    Acc_biggest (struct
      type t = package_stat * int

      let compare (_, a) (_, b) = Int.compare a b
    end)
  in
  OpamPackage.Name.Map.fold
    (fun name versions acc ->
      (* Look only at the lastest version *)
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
  and+ nb_packages_month = compute_new_packages_since "30.days" in
  let newest_packages = []
  and recently_updated = []
  and most_revdeps = compute_most_revdeps 5 packages in
  { nb_packages
  ; nb_update_week
  ; nb_packages_month
  ; newest_packages
  ; recently_updated
  ; most_revdeps
  }
