(* The durable package state: what is computed from opam-repository and saved to
   the state file. *)

open Package

let packages_repr =
  Opam_repr.map ~empty:Name.Map.empty ~add:Name.Map.add
    ~bindings:Name.Map.bindings Opam_repr.name
    (Opam_repr.map ~empty:Version.Map.empty ~add:Version.Map.add
       ~bindings:Version.Map.bindings Opam_repr.version Info.t)

(* When this type changes, [Info.version] needs to be incremented to invalidate
   the saved state. *)
type t = {
  version : string;
  opam_repository_commit : string option;
  packages : (Info.t Version.Map.t Name.Map.t[@repr packages_repr]);
  stats : Packages_stats.t option;
}
[@@deriving repr]

let empty =
  {
    version = Info.version;
    opam_repository_commit = None;
    packages = Name.Map.empty;
    stats = None;
  }

let read_versions package_name versions =
  List.fold_left
    (fun acc package_version ->
      match OpamPackage.of_string_opt package_version with
      | Some pkg -> (
          match Opam_repository.opam_file package_name package_version with
          | Ok opam -> Version.Map.add pkg.version opam acc
          | Error reason ->
              Logs.err (fun m ->
                  m "Failed to read opam file for %S %s: %s" package_name
                    package_version reason);
              acc)
      | None ->
          Logs.err (fun m ->
              m "Invalid package version %S for %S" package_version package_name);
          acc)
    Version.Map.empty versions

let read_packages () =
  let open Lwt.Syntax in
  let t0 = Unix.gettimeofday () in
  let packages_and_versions = Opam_repository.list_packages_and_versions () in
  let t1 = Unix.gettimeofday () in
  Logs.info (fun log -> log "List packages: %.2fs" (t1 -. t0));
  let+ result =
    Lwt_list.fold_left_s
      (fun acc (package_name, versions) ->
        match Name.of_string package_name with
        | exception ex ->
            Logs.err (fun m ->
                m "Invalid package name %S: %s" package_name
                  (Printexc.to_string ex));
            Lwt.return acc
        | name ->
            (* Reading is synchronous, so yield between packages. *)
            let+ () = Lwt.pause () in
            let versions = read_versions package_name versions in
            (* A name with no readable version would have no entry in the
               package index, and no latest version for the statistics. *)
            if Version.Map.is_empty versions then (
              Logs.err (fun m ->
                  m "No readable version of %S: skipping it" package_name);
              acc)
            else Name.Map.add name versions acc)
      Name.Map.empty packages_and_versions
  in
  let t2 = Unix.gettimeofday () in
  Logs.info (fun log -> log "Read opam files: %.2fs" (t2 -. t1));
  result

let time_it_lwt name f =
  let open Lwt.Syntax in
  let t0 = Unix.gettimeofday () in
  let+ result = f () in
  let t1 = Unix.gettimeofday () in
  Logs.info (fun log -> log "%s: %.2fs" name (t1 -. t0));
  result

let rebuild ~previous ~commit =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "Opam repository is currently at %s" commit);
  Logs.info (fun m -> m "Updating opam package list");
  let* packages = time_it_lwt "Read packages" (fun () -> read_packages ()) in
  let* timestamps =
    time_it_lwt "Publication dates" (fun () ->
        Publication_dates.compute
          ~previous:(previous.opam_repository_commit, previous.packages)
          ~commit packages)
  in
  let* packages =
    time_it_lwt "Compute package info" (fun () ->
        Info.of_opamfiles ~timestamps packages)
  in
  let+ stats =
    time_it_lwt "Compute statistics" (fun () -> Packages_stats.compute packages)
  in
  Logs.info (fun m -> m "Loaded %d packages" (Name.Map.cardinal packages));
  {
    version = Info.version;
    opam_repository_commit = Some commit;
    packages;
    stats = Some stats;
  }

let load state_path =
  let exception Invalid_version in
  Logs.info (fun m -> m "State cache file: %s" (Fpath.to_string state_path));
  try
    let channel = open_in_bin (Fpath.to_string state_path) in
    Fun.protect
      (fun () ->
        let s = really_input_string channel (in_channel_length channel) in
        let v =
          match Repr.(unstage (of_bin_string t)) s with
          | Ok v -> v
          | Error (`Msg _) -> raise Invalid_version
        in
        if Info.version <> v.version then raise Invalid_version;
        Logs.info (fun f ->
            f "Package state loaded (%d packages, opam commit %s)"
              (Name.Map.cardinal v.packages)
              (Option.value ~default:"" v.opam_repository_commit));
        v)
      ~finally:(fun () -> close_in channel)
  with Failure _ | Sys_error _ | Invalid_version | End_of_file ->
    Logs.info (fun f -> f "Package state starting from scratch");
    empty

(* Write in place, not to a temporary file renamed over [state_path]: in the
   Docker image, [state_path] is [/var/package.state], owned by the server's
   user in a directory it can't write to, and [init-cache] waits for the
   build-time state with [inotifywait -e close_write] on the file itself. An
   interrupted write leaves a truncated file, which [load] reads as an empty
   state. *)
let write state_path v =
  let content = Repr.(unstage (to_bin_string t)) v in
  Out_channel.with_open_bin (Fpath.to_string state_path) (fun channel ->
      Out_channel.output_string channel content)
