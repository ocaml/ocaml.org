let int_of_month = function
  | "Jan" ->
    1
  | "Feb" ->
    2
  | "Mar" ->
    3
  | "Apr" ->
    4
  | "May" ->
    5
  | "Jun" ->
    6
  | "Jul" ->
    7
  | "Aug" ->
    8
  | "Sep" ->
    9
  | "Oct" ->
    10
  | "Nov" ->
    11
  | "Dec" ->
    12
  | _ ->
    invalid_arg "RFC822.int_of_month"

let parse_offset = function
  | "UT" | "GMT" | "Z" ->
    0
  | "EST" ->
    -5 * 60
  | "EDT" ->
    -4 * 60
  | "CST" ->
    -6 * 60
  | "CDT" ->
    -5 * 60
  | "MST" ->
    -7 * 60
  | "MDT" ->
    -6 * 60
  | "PST" ->
    -8 * 60
  | "PDT" ->
    -7 * 60
  | "A" ->
    -1 * 60
  | "M" ->
    -12 * 60
  | "N" ->
    1 * 60
  | "Y" ->
    12 * 60
  | str ->
    let intv = int_of_string str in
    let hours = intv / 100 |> abs in
    let mins = intv mod 100 |> abs in
    (if intv >= 0 then 1 else -1) * ((hours * 60) + mins)

let parse_time ?(offset = 0) str =
  match String.split_on_char ':' str with
  | [ hr; mn ] ->
    (int_of_string hr, int_of_string mn, 0), offset
  | [ hr; mn; s ] ->
    (int_of_string hr, int_of_string mn, int_of_string s), offset
  | _ ->
    invalid_arg "RFC822.parse_time"

let parse str =
  let str =
    match String.index str ',' with
    | exception Not_found ->
      str
    | pos ->
      String.(sub str (pos + 1) (length str - pos - 1) |> trim)
  in
  match String.split_on_char ' ' str with
  | [ day; month; year; time ] ->
    Ptime.of_date_time
    @@ ( (int_of_string year, int_of_month month, int_of_string day)
       , parse_time time )
  | [ day; month; year; time; offset ] ->
    Ptime.of_date_time
    @@ ( (int_of_string year, int_of_month month, int_of_string day)
       , parse_time ~offset:(parse_offset offset * 60) time )
  | _ ->
    None

let parse_exn str =
  match parse str with None -> invalid_arg "Rfc822.parse" | Some t -> t
