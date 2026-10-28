(* Opam user parser - adapted from ood-gen/lib/opam_user.ml *)

type t = [%import: Data_intf.Opam_user.t] [@@deriving of_yaml]

let all () = Utils.yaml_sequence_file of_yaml "opam-users.yml"
