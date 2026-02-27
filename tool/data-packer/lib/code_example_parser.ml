(* Code example parser - adapted from ood-gen/lib/code_example.ml *)

type t = Data_intf.Code_examples.t = { title : string; body : string }

let all () : t list =
  Utils.read_from_dir "code_examples/*.ml"
  |> List.map (fun (path, body) ->
         let title = Filename.basename path in
         { title; body })
  |> fun examples ->
  if
    List.exists
      (fun (example : t) -> String.equal example.title "default.ml")
      examples
  then examples
  else
    failwith
      "Missing required code example: data/code_examples/default.ml. This file \
       is used by /play."
