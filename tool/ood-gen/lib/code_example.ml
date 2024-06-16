open Data_intf.Code_examples

let all () =
  Utils.read_from_dir "code_examples/*.ml"
  |> List.map (fun (path, body) ->
         let title = Filename.basename path in
         { title; body })

let template () =
  Format.asprintf {|
include Data_intf.Code_examples
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
