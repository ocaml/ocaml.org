type t = [%import: Data_intf.Opam_user.t] [@@deriving of_yaml, show]

let all () = Utils.yaml_sequence_file of_yaml "opam-users.yml"

let template () =
  Format.asprintf {|
include Data_intf.Opam_user
let all = %a
|}
    (Fmt.Dump.list pp) (all ())
