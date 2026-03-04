(* Governance iCal scraper *)

open Data_packer.Import

type weekday = Data_intf.Governance.weekday
type recurrence_rule = Data_intf.Governance.recurrence_rule
type recurrence = Data_intf.Governance.recurrence

let governance_file = "data/governance.yml"

let split_once ~on s =
  match String.cut s ~on with Some (a, b) -> Some (a, b) | None -> None

let trim_cr s =
  if String.length s > 0 && s.[String.length s - 1] = '\r' then
    String.sub s 0 (String.length s - 1)
  else s

let unfold_ical_lines body =
  let lines = String.split_on_char '\n' body |> List.map trim_cr in
  let rec loop acc current = function
    | [] -> (
        match current with
        | None -> List.rev acc
        | Some line -> List.rev (line :: acc))
    | line :: rest ->
        if String.length line > 0 && (line.[0] = ' ' || line.[0] = '\t') then
          let suffix = String.sub line 1 (String.length line - 1) in
          let current =
            match current with
            | None -> Some suffix
            | Some x -> Some (x ^ suffix)
          in
          loop acc current rest
        else
          let acc = match current with None -> acc | Some x -> x :: acc in
          loop acc (Some line) rest
  in
  loop [] None lines

let parse_property line =
  match split_once ~on:":" line with
  | None -> None
  | Some (left, value) -> (
      match String.split_on_char ';' left with
      | [] -> None
      | key :: params ->
          let params =
            params
            |> List.filter_map (fun p -> split_once ~on:"=" p)
            |> List.map (fun (k, v) -> (String.uppercase_ascii k, v))
          in
          Some (String.uppercase_ascii key, params, value))

let weekday_of_code = function
  | "MO" -> Some Data_intf.Governance.Mon
  | "TU" -> Some Data_intf.Governance.Tue
  | "WE" -> Some Data_intf.Governance.Wed
  | "TH" -> Some Data_intf.Governance.Thu
  | "FR" -> Some Data_intf.Governance.Fri
  | "SA" -> Some Data_intf.Governance.Sat
  | "SU" -> Some Data_intf.Governance.Sun
  | _ -> None

let parse_weekday_list value =
  value |> String.split_on_char ',' |> List.filter_map weekday_of_code

let parse_ical_datetime value =
  let raw, is_utc =
    if String.length value > 0 && value.[String.length value - 1] = 'Z' then
      (String.sub value 0 (String.length value - 1), true)
    else (value, false)
  in
  match split_once ~on:"T" raw with
  | None -> Error (`Msg ("Invalid iCal datetime: " ^ value))
  | Some (date, time) ->
      if String.length date <> 8 then
        Error (`Msg ("Invalid iCal date component: " ^ value))
      else
        let time =
          match String.length time with 6 -> time | 4 -> time ^ "00" | _ -> ""
        in
        if String.length time <> 6 then
          Error (`Msg ("Invalid iCal time component: " ^ value))
        else
          let starts_at =
            Printf.sprintf "%s-%s-%sT%s:%s:%s" (String.sub date 0 4)
              (String.sub date 4 2) (String.sub date 6 2) (String.sub time 0 2)
              (String.sub time 2 2) (String.sub time 4 2)
          in
          Ok (starts_at, is_utc)

let duration_of_times ~dtstart ~dtend =
  let parse value =
    match Ptime.of_rfc3339 (value ^ "+00:00") with
    | Ok (ptime, _, _) -> Ok ptime
    | Error _ -> Error (`Msg ("Invalid RFC3339 datetime: " ^ value))
  in
  match (parse dtstart, parse dtend) with
  | Ok start_ptime, Ok end_ptime -> (
      let span = Ptime.diff end_ptime start_ptime in
      match Ptime.Span.to_int_s span with
      | None -> Error (`Msg "Unable to compute duration")
      | Some secs ->
          if secs <= 0 then Error (`Msg "Non-positive duration")
          else Ok (secs / 60))
  | Error e, _ | _, Error e -> Error e

let parse_duration value =
  if not (String.starts_with ~prefix:"PT" value) then None
  else
    let body = String.sub value 2 (String.length value - 2) in
    let rec loop hours minutes acc = function
      | [] -> Some (acc + (hours * 60) + minutes)
      | c :: tl when c >= '0' && c <= '9' ->
          loop hours minutes ((acc * 10) + (Char.code c - Char.code '0')) tl
      | 'H' :: tl -> loop acc minutes 0 tl
      | 'M' :: tl -> loop hours acc 0 tl
      | _ -> None
    in
    loop 0 0 0 (String.to_seq body |> List.of_seq)

let parse_rrule value =
  let pairs =
    value |> String.split_on_char ';'
    |> List.filter_map (fun item -> split_once ~on:"=" item)
    |> List.map (fun (k, v) -> (String.uppercase_ascii k, v))
  in
  let find k = List.assoc_opt k pairs in
  match find "FREQ" with
  | Some "WEEKLY" ->
      let interval_weeks =
        Option.bind (find "INTERVAL") int_of_string_opt
        |> Option.value ~default:1
      in
      let byweekday =
        find "BYDAY" |> Option.value ~default:"" |> parse_weekday_list
      in
      if byweekday = [] then
        Error (`Msg ("Unsupported weekly RRULE (missing BYDAY): " ^ value))
      else Ok (Data_intf.Governance.Weekly { interval_weeks; byweekday })
  | Some "MONTHLY" -> (
      let interval_months =
        Option.bind (find "INTERVAL") int_of_string_opt
        |> Option.value ~default:1
      in
      let parse_nth_byday s =
        let len = String.length s in
        if len < 3 then None
        else
          let day = String.sub s (len - 2) 2 in
          let prefix = String.sub s 0 (len - 2) in
          match (int_of_string_opt prefix, weekday_of_code day) with
          | Some nth, Some weekday when nth >= 1 && nth <= 5 ->
              Some (nth, weekday)
          | _ -> None
      in
      let nth_weekday =
        match find "BYDAY" with
        | Some byday ->
            if String.contains byday ',' then None else parse_nth_byday byday
        | None -> None
      in
      let nth_weekday =
        match nth_weekday with
        | Some _ as v -> v
        | None -> (
            match
              (find "BYDAY", Option.bind (find "BYSETPOS") int_of_string_opt)
            with
            | Some day, Some nth -> (
                match weekday_of_code day with
                | Some weekday when nth >= 1 && nth <= 5 -> Some (nth, weekday)
                | _ -> None)
            | _ -> None)
      in
      match nth_weekday with
      | Some (nth, weekday) ->
          Ok
            (Data_intf.Governance.Monthly_by_nth_weekday
               { interval_months; nth; weekday })
      | None ->
          Error
            (`Msg
              ("Unsupported monthly RRULE (expected nth weekday): " ^ value)))
  | Some freq -> Error (`Msg ("Unsupported RRULE frequency " ^ freq))
  | None -> Error (`Msg "RRULE missing FREQ")

let parse_event ~calendar_tz properties =
  let find_prop name =
    List.find_opt (fun (key, _, _) -> String.equal key name) properties
  in
  let ( let* ) = Result.bind in
  let* _, dtstart_params, dtstart_value =
    match find_prop "DTSTART" with
    | Some value -> Ok value
    | None -> Error (`Msg "RRULE event without DTSTART")
  in
  let* starts_at, dtstart_is_utc = parse_ical_datetime dtstart_value in
  let timezone =
    match List.assoc_opt "TZID" dtstart_params with
    | Some tz -> tz
    | None ->
        if dtstart_is_utc then "UTC"
        else Option.value ~default:"UTC" calendar_tz
  in
  let duration_minutes =
    match find_prop "DURATION" with
    | Some (_, _, duration) -> parse_duration duration
    | None -> None
  in
  let duration_minutes =
    match (duration_minutes, find_prop "DTEND") with
    | Some minutes, _ when minutes > 0 -> Ok minutes
    | _, Some (_, _, dtend_value) ->
        let* dtend, _ = parse_ical_datetime dtend_value in
        duration_of_times ~dtstart:starts_at ~dtend
    | _ -> Ok 60
  in
  let* duration_minutes = duration_minutes in
  let* _, _, rrule_value =
    match find_prop "RRULE" with
    | Some value -> Ok value
    | None -> Error (`Msg "VEVENT is not recurring (missing RRULE)")
  in
  let* rule = parse_rrule rrule_value in
  Ok { Data_intf.Governance.starts_at; timezone; duration_minutes; rule }

let parse_recurrences ical_body =
  let lines = unfold_ical_lines ical_body in
  let calendar_tz =
    lines
    |> List.find_map (fun line ->
           match parse_property line with
           | Some ("X-WR-TIMEZONE", _, value) -> Some value
           | _ -> None)
  in
  let rec collect acc current in_event = function
    | [] -> List.rev acc
    | line :: rest ->
        if String.equal line "BEGIN:VEVENT" then collect acc [] true rest
        else if String.equal line "END:VEVENT" && in_event then
          collect (List.rev current :: acc) [] false rest
        else if in_event then collect acc (line :: current) true rest
        else collect acc current false rest
  in
  let events = collect [] [] false lines in
  let recurrences, errors =
    events
    |> List.fold_left
         (fun (ok_acc, err_acc) event_lines ->
           let properties = List.filter_map parse_property event_lines in
           match parse_event ~calendar_tz properties with
           | Ok recurrence -> (recurrence :: ok_acc, err_acc)
           | Error (`Msg msg) -> (ok_acc, msg :: err_acc))
         ([], [])
  in
  let recurrences =
    recurrences
    |> List.sort (fun a b ->
           let {
             Data_intf.Governance.starts_at = a_starts_at;
             timezone = a_timezone;
             _;
           } =
             a
           in
           let {
             Data_intf.Governance.starts_at = b_starts_at;
             timezone = b_timezone;
             _;
           } =
             b
           in
           let c = String.compare a_starts_at b_starts_at in
           if c <> 0 then c else String.compare a_timezone b_timezone)
  in
  (recurrences, List.rev errors)

let weekday_to_yaml = function
  | Data_intf.Governance.Mon -> `String "mon"
  | Data_intf.Governance.Tue -> `String "tue"
  | Data_intf.Governance.Wed -> `String "wed"
  | Data_intf.Governance.Thu -> `String "thu"
  | Data_intf.Governance.Fri -> `String "fri"
  | Data_intf.Governance.Sat -> `String "sat"
  | Data_intf.Governance.Sun -> `String "sun"

let rule_to_yaml = function
  | Data_intf.Governance.Weekly { interval_weeks; byweekday } ->
      `O
        [
          ("kind", `String "weekly");
          ("interval_weeks", `Float (float_of_int interval_weeks));
          ("byweekday", `A (List.map weekday_to_yaml byweekday));
        ]
  | Data_intf.Governance.Monthly_by_nth_weekday
      { interval_months; nth; weekday } ->
      `O
        [
          ("kind", `String "monthly_by_nth_weekday");
          ("interval_months", `Float (float_of_int interval_months));
          ("nth", `Float (float_of_int nth));
          ("weekday", weekday_to_yaml weekday);
        ]

let recurrence_to_yaml recurrence =
  let { Data_intf.Governance.starts_at; timezone; duration_minutes; rule } =
    recurrence
  in
  `O
    [
      ("starts_at", `String starts_at);
      ("timezone", `String timezone);
      ("duration_minutes", `Float (float_of_int duration_minutes));
      ("rule", rule_to_yaml rule);
    ]

let assoc_set key value fields =
  let rec loop acc = function
    | [] -> List.rev ((key, value) :: acc)
    | (k, _) :: tl when String.equal k key ->
        List.rev_append acc ((key, value) :: tl)
    | hd :: tl -> loop (hd :: acc) tl
  in
  loop [] fields

let assoc_get_string key fields =
  match List.assoc_opt key fields with Some (`String s) -> Some s | _ -> None

let fetch_ical_for_team ~team_id url =
  try Ok (Http_client.get_sync (Uri.of_string url))
  with e ->
    Error
      (`Msg
        (Printf.sprintf "[%s] failed to fetch iCal URL %s: %s" team_id url
           (Printexc.to_string e)))

let rec process_team ?(parent = "") (team : Yaml.value) =
  let ( let* ) = Result.bind in
  match team with
  | `O fields ->
      let team_id =
        match assoc_get_string "id" fields with
        | Some id -> if parent = "" then id else parent ^ "/" ^ id
        | None -> if parent = "" then "<unknown-team>" else parent
      in
      let* fields, updated_count =
        match List.assoc_opt "dev-meeting" fields with
        | Some (`O meeting_fields) -> (
            match assoc_get_string "ical" meeting_fields with
            | Some ical_url ->
                let* ical_body = fetch_ical_for_team ~team_id ical_url in
                let recurrences, warnings = parse_recurrences ical_body in
                List.iter
                  (fun warning ->
                    prerr_endline
                      (Printf.sprintf "[governance-calendars] [%s] %s" team_id
                         warning))
                  warnings;
                let* () =
                  if recurrences = [] then
                    Error
                      (`Msg
                        (Printf.sprintf
                           "[%s] no supported recurring events found in iCal %s"
                           team_id ical_url))
                  else Ok ()
                in
                let meeting_fields =
                  assoc_set "recurrences"
                    (`A (List.map recurrence_to_yaml recurrences))
                    meeting_fields
                in
                Ok (assoc_set "dev-meeting" (`O meeting_fields) fields, 1)
            | None -> Ok (fields, 0))
        | _ -> Ok (fields, 0)
      in
      let* subteams, subteam_updates =
        match List.assoc_opt "subteams" fields with
        | Some (`A subteams) ->
            let* updated_subteams, updates =
              process_team_list ~parent:team_id subteams
            in
            Ok (`A updated_subteams, updates)
        | _ -> Ok (`A [], 0)
      in
      let fields =
        match List.assoc_opt "subteams" fields with
        | Some _ -> assoc_set "subteams" subteams fields
        | None -> fields
      in
      Ok (`O fields, updated_count + subteam_updates)
  | _ -> Error (`Msg "Expected a team object")

and process_team_list ?(parent = "") teams =
  let ( let* ) = Result.bind in
  let rec loop acc updates = function
    | [] -> Ok (List.rev acc, updates)
    | team :: tl ->
        let* updated_team, team_updates = process_team ~parent team in
        loop (updated_team :: acc) (updates + team_updates) tl
  in
  loop [] 0 teams

let scrape () =
  let ( let* ) = Result.bind in
  let result =
    let* raw =
      match Data_packer.Utils.read_file (Fpath.v "governance.yml") with
      | Some content -> Ok content
      | None -> Error (`Msg "Could not read data/governance.yml")
    in
    let* yaml = Yaml.of_string raw in
    let* updated_yaml, updated_count =
      match yaml with
      | `O fields ->
          let process_key key fields =
            match List.assoc_opt key fields with
            | Some (`A teams) ->
                let* teams, updates = process_team_list teams in
                Ok (assoc_set key (`A teams) fields, updates)
            | Some _ ->
                Error (`Msg ("Expected sequence at top-level key: " ^ key))
            | None -> Ok (fields, 0)
          in
          let* fields, teams_updates = process_key "teams" fields in
          let* fields, wg_updates = process_key "working-groups" fields in
          Ok (`O fields, teams_updates + wg_updates)
      | _ -> Error (`Msg "Expected governance.yml root to be a mapping")
    in
    let* output = Yaml.to_string updated_yaml in
    (if String.equal raw output then
       print_endline
         "[governance-calendars] no changes (iCal-derived recurrences already \
          up-to-date)"
     else
       let oc = open_out governance_file in
       output_string oc output;
       close_out oc;
       print_endline
         (Printf.sprintf
            "[governance-calendars] updated %d team calendar(s) in %s"
            updated_count governance_file));
    Ok ()
  in
  result |> Result.get_ok ~error:(fun (`Msg msg) -> failwith msg)
