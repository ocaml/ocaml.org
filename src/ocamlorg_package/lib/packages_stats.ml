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

let compute packages =
  let nb_packages = OpamPackage.Name.Map.cardinal packages in
  let+ nb_update_week = compute_updates_since "7.days"
  and+ nb_packages_month = compute_new_packages_since "30.days" in
  let newest_packages = []
  and recently_updated = []
  and most_revdeps = [] in
  { nb_packages
  ; nb_update_week
  ; nb_packages_month
  ; newest_packages
  ; recently_updated
  ; most_revdeps
  }
