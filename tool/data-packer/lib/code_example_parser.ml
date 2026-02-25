(* Code example parser - adapted from ood-gen/lib/code_example.ml *)

type t = Data_intf.Code_examples.t = { title : string; body : string }

let all () : t list =
  Utils.read_from_dir "code_examples/*.ml"
  |> List.map (fun (path, body) ->
         let title =
           Filename.basename path |> Filename.remove_extension
           |> String.capitalize_ascii
         in
         { title; body })
