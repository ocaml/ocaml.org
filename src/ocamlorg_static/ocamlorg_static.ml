let of_url_path = File.of_url_path

let read_file file =
  let open Lwt.Syntax in
  Lwt.catch
    (fun () ->
      Lwt_io.(with_file ~mode:Input file) (fun channel ->
          let* content = Lwt_io.read channel in
          Some content |> Lwt.return))
    (fun _exn ->
      Dream.log "failed to read file %s" file;
      None |> Lwt.return)

module Media = struct
  let file_root = Sys.getcwd () ^ "/_build/default/data/media/"
  let url_root = "/media"
  let digest = Media_digests.digest

  let read filepath =
    let file = Filename.concat file_root filepath in
    read_file file
end

module Asset = struct
  let file_root = Sys.getcwd () ^ "/_build/default/asset/"
  let digest = Asset_digests.digest

  let read filepath =
    let file = Filename.concat file_root filepath in
    read_file file

  let url filepath =
    let digest = Option.map Dream.to_base64url (digest filepath) in
    if digest = None then
      raise
        (Invalid_argument
           (Fmt.str "'%s' is rendered via Asset.url, but it is not an asset!"
              filepath));
    File.to_url_path ?digest filepath
end

module Playground = struct
  let url_root = "/play"
  let file_root = "playground/asset/"
  let digest = Playground_digests.digest

  let read filepath =
    let file = Filename.concat file_root filepath in
    read_file file

  let url filepath =
    let digest =
      Option.map Dream.to_base64url (Playground_digests.digest filepath)
    in
    if digest = None then
      raise
        (Invalid_argument
           (Fmt.str
              "'%s' is rendered via Playground.url, but it is not an asset!"
              filepath));
    url_root ^ File.to_url_path ?digest filepath
end
