type t = { filepath : string; digest : string option }

let to_url_path static_url =
  match static_url.digest with
  | None -> static_url.filepath
  | Some digest -> Fmt.str "/_/%s/%s" digest static_url.filepath

let of_url_path path =
  let xs = String.split_on_char '/' path in
  match xs with
  | [] -> raise (Invalid_argument "invalid Digest_url: path cannot be empty")
  | "_" :: [] | [ "_"; _ ] ->
      raise
        (Invalid_argument
           "invalid Digest_url: paths starting with '_' must be followed by a \
            digest and filepath")
  | "_" :: x :: xs -> { digest = Some x; filepath = String.concat "/" xs }
  | _ -> { digest = None; filepath = path }
