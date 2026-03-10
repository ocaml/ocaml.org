(* Governance iCal scraper: exports upcoming meetings to
   data/governance-meetings.yml *)

open Data_packer.Import

let governance_file = "governance.yml"
let output_file = "data/governance-meetings.yml"
let horizon_days = 365

type weekday = Mon | Tue | Wed | Thu | Fri | Sat | Sun

type rule =
  | Weekly of {
      interval_weeks : int;
      byweekday : weekday list;
      until : string option;
    }
  | Monthly_nth_weekday of {
      interval_months : int;
      nth : int;
      weekday : weekday;
      until : string option;
    }

type event = {
  starts_at : string;
  timezone : string;
  duration_minutes : int;
  rule : rule option;
  exdates : string list;
  is_override_instance : bool;
}

type team_calendar = {
  team_id : string;
  team_name : string;
  meeting_link : string;
  notes_link : string;
  ical : string;
}

type meeting = {
  team_id : string;
  team_name : string;
  starts_at : string;
  timezone : string;
  duration_minutes : int;
  meeting_link : string;
  notes_link : string;
  ical : string;
}

let split_once ~on s = String.cut s ~on

let trim_cr s =
  if String.length s > 0 && s.[String.length s - 1] = '\r' then
    String.sub s 0 (String.length s - 1)
  else s

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

let unfold_ical_lines body =
  let lines = String.split_on_char '\n' body |> List.map trim_cr in
  let rec loop acc current = function
    | [] -> (
        match current with None -> List.rev acc | Some x -> List.rev (x :: acc))
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

let weekday_of_code = function
  | "MO" -> Some Mon
  | "TU" -> Some Tue
  | "WE" -> Some Wed
  | "TH" -> Some Thu
  | "FR" -> Some Fri
  | "SA" -> Some Sat
  | "SU" -> Some Sun
  | _ -> None

let weekday_to_unix = function
  | Sun -> 0
  | Mon -> 1
  | Tue -> 2
  | Wed -> 3
  | Thu -> 4
  | Fri -> 5
  | Sat -> 6

let parse_ical_datetime value =
  let raw =
    if String.length value > 0 && value.[String.length value - 1] = 'Z' then
      String.sub value 0 (String.length value - 1)
    else value
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
          Ok
            (Printf.sprintf "%s-%s-%sT%s:%s:%s" (String.sub date 0 4)
               (String.sub date 4 2) (String.sub date 6 2) (String.sub time 0 2)
               (String.sub time 2 2) (String.sub time 4 2))

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

let duration_from_dtend ~dtstart ~dtend =
  let parse value =
    match Ptime.of_rfc3339 (value ^ "+00:00") with
    | Ok (ptime, _, _) -> Some ptime
    | Error _ -> None
  in
  match (parse dtstart, parse dtend) with
  | Some start_ptime, Some end_ptime -> (
      match Ptime.Span.to_int_s (Ptime.diff end_ptime start_ptime) with
      | Some s when s > 0 -> Some (s / 60)
      | _ -> None)
  | _ -> None

let parse_rrule value =
  let pairs =
    value |> String.split_on_char ';'
    |> List.filter_map (fun item -> split_once ~on:"=" item)
    |> List.map (fun (k, v) -> (String.uppercase_ascii k, v))
  in
  let find k = List.assoc_opt k pairs in
  let until =
    Option.bind (find "UNTIL") (fun s ->
        parse_ical_datetime s |> Result.to_option)
  in
  match find "FREQ" with
  | Some "WEEKLY" ->
      let interval_weeks =
        Option.bind (find "INTERVAL") int_of_string_opt
        |> Option.value ~default:1
      in
      let byweekday =
        find "BYDAY" |> Option.value ~default:"" |> String.split_on_char ','
        |> List.filter_map weekday_of_code
      in
      Ok (Weekly { interval_weeks; byweekday; until })
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
        | Some byday -> (
            match parse_nth_byday byday with
            | Some _ as v -> v
            | None -> (
                match
                  ( weekday_of_code byday,
                    Option.bind (find "BYSETPOS") int_of_string_opt )
                with
                | Some weekday, Some nth when nth >= 1 && nth <= 5 ->
                    Some (nth, weekday)
                | _ -> None))
        | None -> None
      in
      match nth_weekday with
      | Some (nth, weekday) ->
          Ok (Monthly_nth_weekday { interval_months; nth; weekday; until })
      | None -> Error (`Msg ("Unsupported monthly RRULE: " ^ value)))
  | Some freq -> Error (`Msg ("Unsupported RRULE frequency " ^ freq))
  | None -> Error (`Msg "RRULE missing FREQ")

let parse_ymd s =
  ( int_of_string (String.sub s 0 4),
    int_of_string (String.sub s 5 2),
    int_of_string (String.sub s 8 2) )

let days_in_month y m =
  match m with
  | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
  | 4 | 6 | 9 | 11 -> 30
  | 2 -> if (y mod 4 = 0 && y mod 100 <> 0) || y mod 400 = 0 then 29 else 28
  | _ -> 30

let unix_noon_of_date (y, m, d) =
  let tm =
    {
      Unix.tm_sec = 0;
      tm_min = 0;
      tm_hour = 12;
      tm_mday = d;
      tm_mon = m - 1;
      tm_year = y - 1900;
      tm_wday = 0;
      tm_yday = 0;
      tm_isdst = false;
    }
  in
  fst (Unix.mktime tm)

let add_days (y, m, d) days =
  let t = unix_noon_of_date (y, m, d) +. float_of_int (days * 86400) in
  let tm = Unix.localtime t in
  (tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday)

let date_to_s (y, m, d) = Printf.sprintf "%04d-%02d-%02d" y m d

let today_s () =
  let tm = Unix.localtime (Unix.gettimeofday ()) in
  Printf.sprintf "%04d-%02d-%02d" (tm.tm_year + 1900) (tm.tm_mon + 1) tm.tm_mday

let horizon_s () =
  let tm = Unix.localtime (Unix.gettimeofday ()) in
  let y, m, d = (tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday) in
  add_days (y, m, d) horizon_days |> date_to_s

let date_of_starts_at starts_at = String.sub starts_at 0 10

let within_range ~today ~horizon starts_at =
  let d = date_of_starts_at starts_at in
  String.compare d today >= 0 && String.compare d horizon <= 0

let collect_events ical_body =
  let lines = unfold_ical_lines ical_body in
  let calendar_tz =
    lines
    |> List.find_map (fun line ->
           match parse_property line with
           | Some ("X-WR-TIMEZONE", _, value) -> Some value
           | _ -> None)
    |> Option.value ~default:"UTC"
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
  let event_blocks = collect [] [] false lines in
  event_blocks
  |> List.filter_map (fun block ->
         let props = List.filter_map parse_property block in
         let find name =
           List.find_opt (fun (k, _, _) -> String.equal k name) props
         in
         let find_all name =
           props |> List.filter (fun (k, _, _) -> String.equal k name)
         in
         let result =
           let ( let* ) = Result.bind in
           let* _, dtstart_params, dtstart =
             match find "DTSTART" with
             | Some v -> Ok v
             | None -> Error (`Msg "VEVENT missing DTSTART")
           in
           let* starts_at = parse_ical_datetime dtstart in
           let timezone =
             List.assoc_opt "TZID" dtstart_params
             |> Option.value ~default:calendar_tz
           in
           let duration_minutes =
             match find "DURATION" with
             | Some (_, _, d) -> parse_duration d
             | None -> None
           in
           let duration_minutes =
             match (duration_minutes, find "DTEND") with
             | Some m, _ when m > 0 -> m
             | _, Some (_, _, dtend) -> (
                 match parse_ical_datetime dtend with
                 | Ok dtend ->
                     duration_from_dtend ~dtstart:starts_at ~dtend
                     |> Option.value ~default:60
                 | Error _ -> 60)
             | _ -> 60
           in
           let* rule =
             match find "RRULE" with
             | Some (_, _, value) -> parse_rrule value |> Result.map Option.some
             | None -> Ok None
           in
           let exdates =
             find_all "EXDATE"
             |> List.concat_map (fun (_, _, values) ->
                    String.split_on_char ',' values)
             |> List.filter_map (fun v ->
                    parse_ical_datetime v |> Result.to_option)
           in
           let is_override_instance = Option.is_some (find "RECURRENCE-ID") in
           Ok
             {
               starts_at;
               timezone;
               duration_minutes;
               rule;
               exdates;
               is_override_instance;
             }
         in
         match result with
         | Ok e -> Some e
         | Error (`Msg msg) ->
             prerr_endline ("[governance-calendars] " ^ msg);
             None)

let starts_at_with_date original_starts_at date_s =
  date_s
  ^ String.sub original_starts_at 10 (String.length original_starts_at - 10)

let expand_weekly ~today ~horizon (event : event) interval byweekday until =
  let start_date = parse_ymd (date_of_starts_at event.starts_at) in
  let start_unix = unix_noon_of_date start_date in
  let rec loop date acc =
    let date_s = date_to_s date in
    if String.compare date_s horizon > 0 then List.rev acc
    else
      let tm = Unix.localtime (unix_noon_of_date date) in
      let weekday_ok =
        List.exists (fun w -> weekday_to_unix w = tm.tm_wday) byweekday
      in
      let weeks_since_start =
        int_of_float ((unix_noon_of_date date -. start_unix) /. 604800.)
      in
      let starts_at = starts_at_with_date event.starts_at date_s in
      let until_ok =
        match until with
        | None -> true
        | Some u -> String.compare starts_at u <= 0
      in
      let keep =
        weekday_ok && weeks_since_start >= 0
        && weeks_since_start mod interval = 0
        && within_range ~today ~horizon starts_at
        && until_ok
        && not (List.mem starts_at event.exdates)
      in
      let acc = if keep then starts_at :: acc else acc in
      loop (add_days date 1) acc
  in
  loop start_date []

let nth_weekday_day_of_month year month nth weekday =
  let first_wday =
    (Unix.localtime (unix_noon_of_date (year, month, 1))).tm_wday
  in
  let target = weekday_to_unix weekday in
  let offset = (target - first_wday + 7) mod 7 in
  let day = 1 + offset + ((nth - 1) * 7) in
  if day > days_in_month year month then None else Some day

let expand_monthly_nth ~today ~horizon (event : event) interval nth weekday
    until =
  let y0, m0, _ = parse_ymd (date_of_starts_at event.starts_at) in
  let start_idx = (y0 * 12) + (m0 - 1) in
  let yh, mh, _ = parse_ymd horizon in
  let end_idx = (yh * 12) + (mh - 1) in
  let rec loop idx acc =
    if idx > end_idx then List.rev acc
    else
      let year = idx / 12 in
      let month = (idx mod 12) + 1 in
      let acc =
        if (idx - start_idx) mod interval <> 0 then acc
        else
          match nth_weekday_day_of_month year month nth weekday with
          | None -> acc
          | Some day ->
              let date_s = date_to_s (year, month, day) in
              let starts_at = starts_at_with_date event.starts_at date_s in
              let until_ok =
                match until with
                | None -> true
                | Some u -> String.compare starts_at u <= 0
              in
              if
                within_range ~today ~horizon starts_at
                && String.compare starts_at event.starts_at >= 0
                && until_ok
                && not (List.mem starts_at event.exdates)
              then starts_at :: acc
              else acc
      in
      loop (idx + 1) acc
  in
  loop start_idx []

let occurrences_for_event ~today ~horizon (event : event) =
  if event.is_override_instance then []
  else
    match event.rule with
    | None ->
        if
          within_range ~today ~horizon event.starts_at
          && not (List.mem event.starts_at event.exdates)
        then [ event.starts_at ]
        else []
    | Some (Weekly { interval_weeks; byweekday; until }) ->
        let byweekday =
          if byweekday = [] then
            let wday =
              (Unix.localtime
                 (unix_noon_of_date
                    (parse_ymd (date_of_starts_at event.starts_at))))
                .tm_wday
            in
            let default =
              match wday with
              | 0 -> Sun
              | 1 -> Mon
              | 2 -> Tue
              | 3 -> Wed
              | 4 -> Thu
              | 5 -> Fri
              | _ -> Sat
            in
            [ default ]
          else byweekday
        in
        expand_weekly ~today ~horizon event interval_weeks byweekday until
    | Some (Monthly_nth_weekday { interval_months; nth; weekday; until }) ->
        expand_monthly_nth ~today ~horizon event interval_months nth weekday
          until

let meeting_to_yaml (meeting : meeting) =
  `O
    [
      ("team_id", `String meeting.team_id);
      ("team_name", `String meeting.team_name);
      ("starts_at", `String meeting.starts_at);
      ("timezone", `String meeting.timezone);
      ("duration_minutes", `Float (float_of_int meeting.duration_minutes));
      ("meeting_link", `String meeting.meeting_link);
      ("notes_link", `String meeting.notes_link);
      ("ical", `String meeting.ical);
    ]

let write_output (meetings : meeting list) =
  let yaml = `O [ ("meetings", `A (List.map meeting_to_yaml meetings)) ] in
  match Yaml.to_string yaml with
  | Ok content ->
      let oc = open_out output_file in
      output_string oc content;
      close_out oc
  | Error (`Msg msg) -> failwith msg

let assoc_get_string key fields =
  match List.assoc_opt key fields with Some (`String s) -> Some s | _ -> None

let dev_meeting_ical fields =
  match List.assoc_opt "dev-meeting" fields with
  | Some (`O dev) -> (
      match
        ( assoc_get_string "ical" dev,
          assoc_get_string "link" dev,
          assoc_get_string "notes" dev )
      with
      | Some ical, Some link, Some notes -> Some (ical, link, notes)
      | _ -> None)
  | _ -> None

let rec collect_team_calendars ?(parent = "") team : team_calendar list =
  match team with
  | `O fields ->
      let team_id =
        match assoc_get_string "id" fields with
        | Some id -> if parent = "" then id else parent ^ "/" ^ id
        | None -> parent
      in
      let team_name =
        Option.value ~default:team_id (assoc_get_string "name" fields)
      in
      let here =
        match dev_meeting_ical fields with
        | Some (ical, meeting_link, notes_link) ->
            [ { team_id; team_name; meeting_link; notes_link; ical } ]
        | None -> []
      in
      let subteams =
        match List.assoc_opt "subteams" fields with
        | Some (`A subteams) ->
            subteams |> List.concat_map (collect_team_calendars ~parent:team_id)
        | _ -> []
      in
      here @ subteams
  | _ -> []

let collect_calendars yaml =
  match yaml with
  | `O fields ->
      let teams =
        match List.assoc_opt "teams" fields with
        | Some (`A teams) -> teams
        | _ -> []
      in
      let wgs =
        match List.assoc_opt "working-groups" fields with
        | Some (`A teams) -> teams
        | _ -> []
      in
      List.concat_map collect_team_calendars (teams @ wgs)
  | _ -> []

let scrape_calendar (calendar : team_calendar) : meeting list =
  let body = Http_client.get_sync (Uri.of_string calendar.ical) in
  let events = collect_events body in
  let today = today_s () in
  let horizon = horizon_s () in
  events
  |> List.concat_map (fun (event : event) ->
         occurrences_for_event ~today ~horizon event
         |> List.map (fun starts_at ->
                {
                  team_id = calendar.team_id;
                  team_name = calendar.team_name;
                  starts_at;
                  timezone = event.timezone;
                  duration_minutes = event.duration_minutes;
                  meeting_link = calendar.meeting_link;
                  notes_link = calendar.notes_link;
                  ical = calendar.ical;
                }))

let scrape () =
  let yaml = Data_packer.Utils.yaml_file governance_file in
  let calendars =
    yaml
    |> Result.get_ok ~error:(fun (`Msg m) -> failwith m)
    |> collect_calendars
  in
  let meetings =
    calendars
    |> List.concat_map (fun calendar ->
           try scrape_calendar calendar
           with e ->
             prerr_endline
               (Printf.sprintf
                  "[governance-calendars] failed to scrape %s (%s): %s"
                  calendar.team_id calendar.ical (Printexc.to_string e));
             [])
    |> List.sort (fun a b ->
           let c = String.compare a.starts_at b.starts_at in
           if c <> 0 then c else String.compare a.team_id b.team_id)
  in
  write_output meetings;
  print_endline
    (Printf.sprintf "[governance-calendars] wrote %d upcoming meeting(s) to %s"
       (List.length meetings) output_file)
