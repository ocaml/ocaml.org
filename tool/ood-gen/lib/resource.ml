open Data_intf.Resource

let all () = Utils.yaml_sequence_file of_yaml "resources.yml"

let template () =
  let all_resources = all () in
  Format.asprintf
    {|
include Data_intf.Resource
let all = %a
let featured = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    all_resources
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all_resources |> List.filter (fun (r : t) -> r.featured = true))
