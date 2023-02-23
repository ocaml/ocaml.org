let to_url_path ?digest filepath =
  match digest with
  | None -> filepath
  | Some digest -> Fmt.str "/_/%s/%s" digest filepath

type t = { filepath : string; digest : string option }

let of_url_path path =
  let xs = String.split_on_char '/' path in
  match xs with
  | "_" :: x :: xs -> Some { digest = Some x; filepath = String.concat "/" xs }
  | "_" :: _ | [] -> None
  | _ -> Some { digest = None; filepath = path }
