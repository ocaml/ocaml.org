type t = [%import: Data_intf.Resource.t] [@@deriving of_yaml, show]

let all () = Utils.yaml_sequence_file of_yaml "resources.yml"

let template () =
  let all_resources = all () in
  Format.asprintf
    {|
include Data_intf.Resource
let all = %a
let featured = %a
|}
    (Fmt.Dump.list pp) all_resources (Fmt.Dump.list pp)
    (all_resources |> List.filter (fun (r : t) -> r.featured = true))
