(* Publication date of every package version: the time of the last commit, on
   opam-repository's first-parent history, that added, copied or renamed its
   opam file.

   Scanning the whole history is slow, so when the previous state was built at a
   commit [old] on the first-parent history of [commit], only [old..commit] is
   read and folded onto the dates already in that state. This gives the same
   result as a full scan: a version present at [commit] but not at [old] was
   necessarily added in [old..commit]. A version present at [old] that has no
   date in the previous state (its opam file did not parse then) is the one case
   it can't handle, so it falls back to the full scan. *)

open Package

let of_state (packages : Info.t Version.Map.t Name.Map.t) =
  Name.Map.fold
    (fun name versions acc ->
      Version.Map.fold
        (fun version (info : Info.t) acc ->
          OpamPackage.Map.add
            (OpamPackage.create name version)
            info.publication acc)
        versions acc)
    packages OpamPackage.Map.empty

let missing timestamps (opams : _ Version.Map.t Name.Map.t) =
  Name.Map.fold
    (fun name versions acc ->
      Version.Map.fold
        (fun version _ acc ->
          let pkg = OpamPackage.create name version in
          if OpamPackage.Map.mem pkg timestamps then acc else pkg :: acc)
        versions acc)
    opams []

let compute ?repo ~previous ~commit opams =
  let open Lwt.Syntax in
  let full reason =
    Logs.info (fun m -> m "Publication dates: full history (%s)" reason);
    Opam_repository.create_package_to_timestamp ?repo commit
  in
  match previous with
  | None, _ -> full "no previous state"
  | Some old, old_packages -> (
      let* ancestry = Opam_repository.ancestry ?repo old commit in
      match ancestry with
      | Unknown_commit -> full (old ^ " is not in the clone")
      | Not_first_parent ->
          full (old ^ " is not on the first-parent history of " ^ commit)
      | Git_failed reason ->
          (* The range is only a speed-up: a Git failure here must not stop the
             update. *)
          full ("Git failed: " ^ reason)
      | First_parent -> (
          let* timestamps =
            Opam_repository.create_package_to_timestamp ?repo ~since:old
              ~init:(of_state old_packages) commit
          in
          match missing timestamps opams with
          | [] ->
              Logs.info (fun m ->
                  m "Publication dates: incremental %s..%s" old commit);
              Lwt.return timestamps
          | pkgs ->
              full
                (Printf.sprintf "no date for %d versions, e.g. %s"
                   (List.length pkgs)
                   (OpamPackage.to_string (List.hd pkgs)))))
