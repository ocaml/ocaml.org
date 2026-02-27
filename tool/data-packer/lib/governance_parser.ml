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
        let ( let* ) = Result.bind in
        let* value = field name in
        match value with
        | `Float f ->
            if Float.is_integer f then Ok (int_of_float f)
            else Error (`Msg ("Invalid integer for field: " ^ name))
        | `String s -> (
            match int_of_string_opt s with
            | Some v -> Ok v
            | None -> Error (`Msg ("Invalid integer for field: " ^ name)))
        | _ -> Error (`Msg ("Invalid integer for field: " ^ name))
      in
      let rec parse_weekdays acc = function
        | [] -> Ok (List.rev acc)
        | x :: xs ->
            let ( let* ) = Result.bind in
            let* weekday = weekday_of_yaml x in
            parse_weekdays (weekday :: acc) xs
      in
      let ( let* ) = Result.bind in
      let* kind = field "kind" in
      (match kind with
      | `String "weekly" ->
          let* interval_weeks = int_field "interval_weeks" in
          let* () =
            if interval_weeks >= 1 then Ok ()
            else Error (`Msg "interval_weeks must be >= 1")
          in
          let* byweekday = field "byweekday" in
          let* byweekday =
            match byweekday with
            | `A weekdays -> parse_weekdays [] weekdays
            | _ -> Error (`Msg "Invalid recurrence field: byweekday")
          in
          let* () =
            if byweekday <> [] then Ok ()
            else Error (`Msg "byweekday must not be empty")
          in
          Ok (Weekly { interval_weeks; byweekday })
      | `String "monthly_by_nth_weekday" ->
          let* interval_months = int_field "interval_months" in
          let* () =
            if interval_months >= 1 then Ok ()
            else Error (`Msg "interval_months must be >= 1")
          in
          let* nth = int_field "nth" in
          let* () =
            if nth >= 1 && nth <= 5 then Ok ()
            else Error (`Msg "nth must be between 1 and 5")
          in
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
[@@deriving show]

let validate_starts_at starts_at =
  let is_digit c = c >= '0' && c <= '9' in
  let expected_len = 19 in
  let fail msg = Error (`Msg ("Invalid starts_at value '" ^ starts_at ^ "': " ^ msg)) in
  if String.length starts_at <> expected_len then
    fail "expected format YYYY-MM-DDTHH:MM:SS"
  else if
    not
      (is_digit starts_at.[0] && is_digit starts_at.[1] && is_digit starts_at.[2]
     && is_digit starts_at.[3] && starts_at.[4] = '-' && is_digit starts_at.[5]
     && is_digit starts_at.[6] && starts_at.[7] = '-' && is_digit starts_at.[8]
     && is_digit starts_at.[9] && starts_at.[10] = 'T'
     && is_digit starts_at.[11] && is_digit starts_at.[12]
     && starts_at.[13] = ':' && is_digit starts_at.[14]
     && is_digit starts_at.[15] && starts_at.[16] = ':'
     && is_digit starts_at.[17] && is_digit starts_at.[18])
  then fail "expected format YYYY-MM-DDTHH:MM:SS"
  else
    match Ptime.of_rfc3339 (starts_at ^ "+00:00") with
    | Ok _ -> Ok ()
    | Error _ ->
        fail "contains an invalid date or time component"

type recurrence_metadata = {
  starts_at : string;
  timezone : string;
  duration_minutes : int;
  rule : recurrence_rule;
}
[@@deriving of_yaml, stable_record ~version:Data_intf.Governance.recurrence]

let recurrence_of_yaml yml =
  let ( let* ) = Result.bind in
  let* recurrence = recurrence_metadata_of_yaml yml in
  let* () = validate_starts_at recurrence.starts_at in
  let* () =
    if String.trim recurrence.timezone <> "" then Ok ()
    else Error (`Msg "timezone must not be empty")
  in
  let* () =
    if recurrence.duration_minutes >= 1 then Ok ()
    else Error (`Msg "duration_minutes must be >= 1")
  in
  Ok (recurrence_metadata_to_Data_intf_Governance_recurrence recurrence)

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
