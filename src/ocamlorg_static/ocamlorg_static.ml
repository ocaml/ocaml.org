include Static_file

(* given the path of a file from `assets.ml`: 1. looks up the file's digest in
   and 2. returns the corresponding digest URL for use in templates *)
let asset_digest_url filepath =
  let digest = Asset.hash filepath in
  if digest = None then
    raise
      (Invalid_argument
         (Fmt.str
            "ERROR: '%s' is rendered via asset_digest_url, but it is not an \
             asset!"
            filepath));
  to_url_path
    { digest = Option.map (fun d -> Dream.to_base64url d) digest; filepath }
