(* Resource parser - adapted from ood-gen/lib/resource.ml *)

open Import

type t = [%import: Data_intf.Resource.t] [@@deriving of_yaml, show]

let all () = Utils.yaml_sequence_file of_yaml "resources.yml"
let featured () = all () |> List.filter (fun (r : t) -> r.featured = true)
