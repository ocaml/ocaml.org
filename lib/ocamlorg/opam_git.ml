module Store = Git_unix.Store
module Search = Git.Search.Make (Digestif.SHA1) (Store)
open Lwt.Infix

let read_dir store hash =
  Store.read store hash >|= function
  | Error e ->
    Fmt.failwith "Failed to read tree: %a" Store.pp_error e
  | Ok (Git.Value.Tree tree) ->
    Some tree
  | Ok _ ->
    None

let read_package store pkg hash =
  Search.find store hash (`Path [ "opam" ]) >>= function
  | None ->
    Fmt.failwith "opam file not found for %s" (OpamPackage.to_string pkg)
  | Some hash ->
    Store.read store hash >|= ( function
    | Ok (Git.Value.Blob blob) ->
      OpamFile.OPAM.read_from_string (Store.Value.Blob.to_string blob)
    | _ ->
      Fmt.failwith "Bad Git object type for %s!" (OpamPackage.to_string pkg) )

(* Get a map of the versions inside [entry] (an entry under "packages") *)
let read_versions store (entry : Store.Value.Tree.entry) =
  read_dir store entry.node >>= function
  | None ->
    Lwt.return_none
  | Some tree ->
    Store.Value.Tree.to_list tree
    |> Lwt_list.fold_left_s
         (fun acc (entry : Store.Value.Tree.entry) ->
           match OpamPackage.of_string_opt entry.name with
           | Some pkg ->
             read_package store pkg entry.node >|= fun opam ->
             OpamPackage.Version.Map.add pkg.version opam acc
           | None ->
             OpamConsole.log
               "opam-0install"
               "Invalid package name %S"
               entry.name;
             Lwt.return acc)
         OpamPackage.Version.Map.empty
    >|= fun versions -> Some versions

let read_packages store commit =
  Search.find store commit (`Commit (`Path [ "packages" ])) >>= function
  | None ->
    Fmt.failwith "Failed to find packages directory!"
  | Some tree_hash ->
    read_dir store tree_hash >>= ( function
    | None ->
      Fmt.failwith "'packages' is not a directory!"
    | Some tree ->
      Store.Value.Tree.to_list tree
      |> Lwt_list.fold_left_s
           (fun acc (entry : Store.Value.Tree.entry) ->
             match OpamPackage.Name.of_string entry.name with
             | exception ex ->
               OpamConsole.log
                 "opam-0install"
                 "Invalid package name %S: %s"
                 entry.name
                 (Printexc.to_string ex);
               Lwt.return acc
             | name ->
               read_versions store entry >|= ( function
               | None ->
                 acc
               | Some versions ->
                 OpamPackage.Name.Map.add name versions acc ))
           OpamPackage.Name.Map.empty )
