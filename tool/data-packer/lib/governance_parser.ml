(* Governance parser - adapted from ood-gen/lib/governance.ml *)

open Import

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
  | `String "tracker" -> Ok Tracker
  | x -> (
      match Yaml.to_string x with
      | Ok str ->
          Error
            (`Msg
              ("\"" ^ str
             ^ "\" is not a valid contact_kind! valid options are: github, \
                email, discord, chat, forum"))
      | Error _ -> Error (`Msg "Invalid Yaml value"))

type contact = [%import: Data_intf.Governance.contact]
[@@deriving of_yaml, show]

type weekday = [%import: Data_intf.Governance.weekday] [@@deriving show]

let weekday_of_yaml = function
  | `String "mon" | `String "monday" -> Ok Mon
  | `String "tue" | `String "tuesday" -> Ok Tue
  | `String "wed" | `String "wednesday" -> Ok Wed
  | `String "thu" | `String "thursday" -> Ok Thu
  | `String "fri" | `String "friday" -> Ok Fri
  | `String "sat" | `String "saturday" -> Ok Sat
  | `String "sun" | `String "sunday" -> Ok Sun
  | x -> (
      match Yaml.to_string x with
      | Ok s -> Error (`Msg ("Unknown weekday: " ^ s))
      | Error _ -> Error (`Msg "Unknown weekday"))

type recurrence_rule = [%import: Data_intf.Governance.recurrence_rule]
[@@deriving show]

let recurrence_rule_of_yaml = function
  | `O fields ->
      let field name =
        Option.to_result ~none:(`Msg ("Missing recurrence field: " ^ name))
          (List.assoc_opt name fields)
      in
      let int_field name =
        let open Result.Syntax in
        let* value = field name in
        match value with
        | `Float f -> Ok (int_of_float f)
        | `String s -> (
            match int_of_string_opt s with
            | Some v -> Ok v
            | None -> Error (`Msg ("Invalid integer for field: " ^ name)))
        | _ -> Error (`Msg ("Invalid integer for field: " ^ name))
      in
      let rec parse_weekdays acc = function
        | [] -> Ok (List.rev acc)
        | x :: xs ->
            let open Result.Syntax in
            let* weekday = weekday_of_yaml x in
            parse_weekdays (weekday :: acc) xs
      in
      let open Result.Syntax in
      let* kind = field "kind" in
      (match kind with
      | `String "weekly" ->
          let* interval_weeks = int_field "interval_weeks" in
          let* byweekday = field "byweekday" in
          let* byweekday =
            match byweekday with
            | `A weekdays -> parse_weekdays [] weekdays
            | _ -> Error (`Msg "Invalid recurrence field: byweekday")
          in
          Ok (Weekly { interval_weeks; byweekday })
      | `String "monthly_by_nth_weekday" ->
          let* interval_months = int_field "interval_months" in
          let* nth = int_field "nth" in
          let* weekday = field "weekday" in
          let* weekday = weekday_of_yaml weekday in
          Ok (Monthly_by_nth_weekday { interval_months; nth; weekday })
      | _ ->
          Error
            (`Msg
              "Invalid recurrence rule kind. Expected weekly or \
               monthly_by_nth_weekday"))
  | _ ->
      Error
        (`Msg
          "Invalid recurrence rule. Expected kind=weekly or \
           kind=monthly_by_nth_weekday")

type recurrence = [%import: Data_intf.Governance.recurrence]
[@@deriving of_yaml, show]

type dev_meeting = [%import: Data_intf.Governance.dev_meeting] [@@deriving show]

type dev_meeting_metadata = {
  date : string;
  time : string;
  link : string;
  calendar : string option; [@default None]
  notes : string;
  recurrences : recurrence list; [@default []]
}
[@@deriving of_yaml, stable_record ~version:Data_intf.Governance.dev_meeting]

let dev_meeting_of_yaml yml =
  yml |> dev_meeting_metadata_of_yaml
  |> Result.map dev_meeting_metadata_to_Data_intf_Governance_dev_meeting

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

let teams () = (all ()).teams
let working_groups () = (all ()).working_groups
