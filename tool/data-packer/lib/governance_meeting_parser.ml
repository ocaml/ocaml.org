type t = [%import: Data_intf.Governance_meeting.t] [@@deriving of_yaml, show]

let all () =
  Utils.yaml_sequence_file ~key:"meetings" of_yaml "governance-meetings.yml"
