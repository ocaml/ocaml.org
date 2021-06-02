open Cmdliner

let get_time () =
  Ptime.of_float_s (Unix.gettimeofday ()) |> function
  | Some t ->
      Ptime.pp_rfc3339 () Format.str_formatter t;
      Format.flush_str_formatter ()
  | None -> "2020-09-01 11:15:30 +00:00"

let run () =
  print_endline (get_time ());
  0

let info =
  let doc = "Print the current time." in
  Term.info ~doc "time"

let term = Term.(pure run $ pure ())

let cmd = (term, info)
