open Lwt.Syntax

type t =
  { mutable packages :
      Package.Info.t OpamPackage.Version.Map.t OpamPackage.Name.Map.t
  ; docs : Documentation.t
  }

module Store = Git_unix.Store
module Search = Git.Search.Make (Digestif.SHA1) (Store)

let update ~store ~commit t =
  Dream.log "Opened store";
  let+ packages = Opam_git.read_packages store commit in
  t.packages <-
    OpamPackage.Name.Map.map
      (OpamPackage.Version.Map.map Package.Info.of_opamfile)
      packages;
  Dream.log "Loaded %d packages" (OpamPackage.Name.Map.cardinal packages)

let poll_for_opam_packages ~polling v =
  let* () = Opam_repository.clone () in
  let last_commit = ref None in
  let rec updater () =
    let* () =
      Lwt.catch
        (fun () ->
          let* () = Opam_repository.fetch () in
          let* store = Opam_repository.open_store () in
          let* commit = Store.Ref.resolve store Git.Reference.master in
          let commit = Result.get_ok commit in
          if Some commit <> !last_commit then (
            Dream.log "Updating opam package list";
            let+ () = update ~store ~commit v in
            last_commit := Some commit)
          else
            Lwt.return_unit)
        (fun exn ->
          Dream.error (fun log ->
              log
                "Failed to update the opam package list: %s"
                (Printexc.to_string exn));
          Lwt.return ())
    in
    let* () = Lwt_unix.sleep (float_of_int polling) in
    updater ()
  in
  updater ()

let t =
  let docs =
    Documentation.make ~api:Config.graphql_api ~polling:Config.opam_polling ()
  in
  let v = { packages = OpamPackage.Name.Map.empty; docs } in
  Lwt.async (fun () -> poll_for_opam_packages ~polling:Config.opam_polling v);
  v

let all_packages_latest () =
  t.packages
  |> OpamPackage.Name.Map.map OpamPackage.Version.Map.max_binding
  |> Lwt.return

let get_package name =
  t.packages |> OpamPackage.Name.Map.find name |> Lwt.return

let get_package_opt name =
  t.packages |> OpamPackage.Name.Map.find_opt name |> Lwt.return

let docs () = t.docs