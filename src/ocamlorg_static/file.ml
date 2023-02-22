let to_url_path ?digest filepath =
  match digest with
  | None -> filepath
  | Some digest -> Fmt.str "/_/%s/%s" digest filepath

type t = { filepath : string; digest : string option }

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
