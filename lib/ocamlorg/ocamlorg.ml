open Lwt.Infix
module Config = Config
module Package = Package
module Oop = Ocamlorg_pipeline

type t = Oop.t

let init () =
  let pipeline =
    Oop.init ~opam_dir:Config.opam_repository_path ~callback:Package.callback
  in
  pipeline

let pipeline t =
  Oop.v t >>= function
  | Ok t ->
    Lwt.return t
  | Error (`Msg m) ->
    Lwt.fail_with m

let site_dir = Oop.site_dir
