module Digest_url = struct
  type t = { filepath : string; digest : string option }

  let of_path ~digest filepath = { filepath; digest }
  let to_path static_url = static_url.filepath

  let to_string static_url =
    match static_url.digest with
    | None -> static_url.filepath
    | Some digest -> Fmt.str "/_/%s/%s" digest static_url.filepath

  let of_string path =
    let xs = String.split_on_char '/' path in
    match xs with
    | [] -> raise (Invalid_argument "invalid Digest_url: path cannot be empty")
    | "_" :: [] | [ "_"; _ ] ->
        raise
          (Invalid_argument
             "invalid Digest_url: paths starting with '_' must be followed by \
              a digest and filepath")
    | "_" :: x :: xs -> { digest = Some x; filepath = String.concat "/" xs }
    | _ -> { digest = None; filepath = path }
end

let asset_digest_url filepath =
  let digest = Asset.hash filepath in
  if digest = None then
    raise
      (Invalid_argument
         (Fmt.str
            "ERROR: '%s' is rendered via asset_digest_url, but it is not an \
             asset!"
            filepath));
  Digest_url.to_string
    (Digest_url.of_path
       ~digest:(Option.map (fun d -> Dream.to_base64url d) digest)
       filepath)
