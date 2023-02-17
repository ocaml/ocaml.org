let of_url_path = File.of_url_path

module Media = Media

module Asset = struct
  include Asset

  (* given the path of a file from `assets.ml`: 1. looks up the file's digest in
     and 2. returns the corresponding digest URL for use in templates *)
  let url filepath =
    let digest =
      Option.map (fun d -> Dream.to_base64url d) (Asset.hash filepath)
    in
    if digest = None then
      raise
        (Invalid_argument
           (Fmt.str "'%s' is rendered via Asset.url, but it is not an asset!"
              filepath));
    File.to_url_path ?digest filepath
end

module Playground = struct
  let file_root = "playground/asset/"
  let url_root = "/play"
  let digest_map = Digest_map.read_directory file_root
  let digest filepath = Digest_map.digest filepath digest_map

  let url filepath =
    let file_digest =
      Option.map (fun d -> Dream.to_base64url d) (digest filepath)
    in
    if file_digest = None then
      raise
        (Invalid_argument
           (Fmt.str
              "didn't find a digest for '%s' when trying to render it as \
               Playground.url!"
              filepath));
    url_root ^ File.to_url_path ?digest:file_digest filepath
end
