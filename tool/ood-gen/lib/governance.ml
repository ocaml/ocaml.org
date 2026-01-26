open Ocamlorg.Import

type member = [%import: Data_intf.Governance.member] [@@deriving of_yaml, show]

type contact_kind = [%import: Data_intf.Governance.contact_kind]
[@@deriving show]

let contact_kind_of_yaml = function
  | `String "github" -> Ok GitHub
  | `String "email" -> Ok Email
  | `String "discord" -> Ok Discord
  | `String "chat" -> Ok Chat
  | `String "forum" -> Ok Forum
  | `String "website" -> Ok Website
  | x -> (
      match Yaml.to_string x with
      | Ok str ->
          Error
            (`Msg
              ("\"" ^ str
             ^ "\" is not a valid contact_kind! valid options are: github, \
                email, discord, chat, forum"))
      | Error _ -> Error (`Msg "Invalid Yaml value"))

let contact_kind_to_yaml = function
  | GitHub -> `String "github"
  | Email -> `String "email"
  | Discord -> `String "discord"
  | Chat -> `String "chat"
  | Forum -> `String "forum"
  | Website -> `String "website"

type contact = [%import: Data_intf.Governance.contact]
[@@deriving of_yaml, show]

type dev_meeting = [%import: Data_intf.Governance.dev_meeting]
[@@deriving of_yaml, show]

type team_metadata = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  dev_meeting : dev_meeting option; [@default None] [@key "dev-meeting"]
  members : member list; [@default []]
  subteams : team_metadata list; [@default []]
}
[@@deriving of_yaml, stable_record ~version:Data_intf.Governance.team]

let team_of_yaml yml =
  yml |> team_metadata_of_yaml
  |> Result.map team_metadata_to_Data_intf_Governance_team

type team = [%import: Data_intf.Governance.team] [@@deriving show]

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
    (Fmt.Dump.list pp_team) t.teams (Fmt.Dump.list pp_team) t.working_groups
