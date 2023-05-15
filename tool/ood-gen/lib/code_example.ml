type t = { title : string; body : string }
[@@deriving show { with_path = false }]

let all () =
  Utils.read_from_dir "code_examples/*.ml"
  |> List.fold_left
       (fun acc (path, body) ->
         let title = Filename.basename path in
         { title; body } :: acc)
       []

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; body : string
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
