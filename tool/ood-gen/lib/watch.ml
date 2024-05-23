open Data_intf.Watch

let all () = Utils.yaml_sequence_file of_yaml "watch.yml"

let template () =
  Format.asprintf {|
include Data_intf.Watch
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
