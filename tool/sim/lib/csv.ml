(* Minimal CSV writer. Every file starts with a header row; fields never contain
   commas (paths are written as-is, and the paths we request have none). Rows
   are flushed eagerly so a run that is interrupted still leaves usable data. *)

type t = out_channel

let create path header =
  let oc = open_out path in
  output_string oc (String.concat "," header);
  output_char oc '\n';
  flush oc;
  oc

let row oc fields =
  output_string oc (String.concat "," fields);
  output_char oc '\n';
  flush oc

let close = close_out
let float x = Printf.sprintf "%.3f" x
let float6 x = Printf.sprintf "%.6f" x

(* Read a CSV file written by [create]: the header and the rows, split on
   commas. *)
let read path =
  let ic = open_in path in
  let rec lines acc =
    match input_line ic with
    | line -> lines (String.split_on_char ',' line :: acc)
    | exception End_of_file ->
        close_in ic;
        List.rev acc
  in
  match lines [] with [] -> ([], []) | header :: rows -> (header, rows)
