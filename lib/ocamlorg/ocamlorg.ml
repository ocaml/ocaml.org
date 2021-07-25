module Package = Package

let pipeline =
  Ocamlorg_pipeline.init
    ~opam_dir:Config.opam_repository_path
    ~callback:Package.callback

let () =
  Lwt.async (fun () ->
      let open Lwt.Syntax in
      let* result = Ocamlorg_pipeline.v pipeline in
      match result with
      | Ok t ->
        Lwt.return t
      | Error (`Msg m) ->
        Lwt.fail_with m)

let site_dir =
  let site_dir = Fpath.to_string (Ocamlorg_pipeline.site_dir pipeline) in
  Printf.printf "Site dir is at %s" site_dir;
  site_dir
