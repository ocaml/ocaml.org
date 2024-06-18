open Data_intf.Opam_user

let all () = Utils.yaml_sequence_file of_yaml "opam-users.yml"

let template () =
  Format.asprintf {|
include Data_intf.Opam_user
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
