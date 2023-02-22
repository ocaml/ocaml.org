module Asset = Asset
module Media = Media

let of_url_path = File.of_url_path

(* given the path of a file from `assets.ml`: 1. looks up the file's digest in
   and 2. returns the corresponding digest URL for use in templates *)
let asset_url filepath =
  let digest =
    Option.map (fun d -> Dream.to_base64url d) (Asset.hash filepath)
  in
  if digest = None then
    raise
      (Invalid_argument
         (Fmt.str
            "ERROR: '%s' is rendered via asset_url, but it is not an asset!"
            filepath));
  File.to_url_path ?digest filepath
