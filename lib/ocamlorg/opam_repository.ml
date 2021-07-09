open Lwt.Infix
module Store = Git_unix.Store

let clone_path = Fpath.(v "var" / "opam-repository")

let open_store () =
  Git_unix.Store.v ~dotgit:clone_path clone_path >|= function
  | Ok x ->
    x
  | Error e ->
    Fmt.failwith "Failed to open opam-repository: %a" Store.pp_error e

let clone () =
  match Bos.OS.Path.exists clone_path with
  | Ok true ->
    Lwt.return_unit
  | Ok false ->
    Process.exec
      ( ""
      , [| "git"
         ; "clone"
         ; "--bare"
         ; "https://github.com/ocaml/opam-repository.git"
         ; Fpath.to_string clone_path
        |] )
  | _ ->
    Fmt.failwith "Error finding about this path: %a" Fpath.pp clone_path

let fetch () =
  Process.exec
    ("", [| "git"; "-C"; Fpath.to_string clone_path; "fetch"; "origin" |])
