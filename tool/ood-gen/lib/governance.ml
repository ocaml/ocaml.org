open Ocamlorg.Import
open Data_intf.Governance

type team_metadata = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  dev_meeting : dev_meeting option; [@default None] [@key "dev-meeting"]
  members : Member.t list; [@default []]
  subteams : team_metadata list; [@default []]
}
[@@deriving of_yaml, stable_record ~version:team]

let team_of_yaml yml =
  yml |> team_metadata_of_yaml |> Result.map team_metadata_to_team

type metadata = {
  teams : team list;
  working_groups : team list; [@key "working-groups"]
}
[@@deriving of_yaml]

let all () =
  let file = "governance.yml" in
  let result =
    let ( let* ) = Result.bind in
    let* yaml = Utils.yaml_file file in
    metadata_of_yaml yaml
  in
  result
  |> Result.map_error (Utils.where file)
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let template () =
  let t = all () in
  Format.asprintf
    {|
include Data_intf.Governance
let teams = %a

let working_groups = %a
|}
    (Fmt.brackets (Fmt.list pp_team ~sep:Fmt.semi))
    t.teams
    (Fmt.brackets (Fmt.list pp_team ~sep:Fmt.semi))
    t.working_groups
