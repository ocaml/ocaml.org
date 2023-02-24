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
  include Playground_assets

  let url_root = "/play"

  (* given the path of a file from `assets.ml`: 1. looks up the file's digest in
     and 2. returns the corresponding digest URL for use in templates *)
  let url filepath =
    let digest =
      Option.map (fun d -> Dream.to_base64url d) (Playground_assets.hash filepath)
    in
    if digest = None then
      raise
        (Invalid_argument
            (Fmt.str "'%s' is rendered via Playground.url, but it is not an asset!"
              filepath));
    url_root ^ (File.to_url_path ?digest filepath)
end
