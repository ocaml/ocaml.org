(* One record per scrape attempt, appended to stats.jsonl, which policy.ml reads
   to decide how often to scrape. *)

type t = {
  started : int;
  finished : int;
  status : [ `Scraped | `Aborted ];
  reason : string option;
  requests : int;
  bytes : int;
  fetched : int;
  unchanged : int;
  missing : int;
  skipped : int;
  errors : int;
  changed_packages : string list;  (** all of them; at most 500 are written *)
  last_modified : int list;
      (** the backend's Last-Modified time of every sidebar fetched, sorted *)
}

let to_json r =
  `Assoc
    [
      ("started", `Int r.started);
      ("finished", `Int r.finished);
      ( "status",
        `String
          (match r.status with `Scraped -> "scraped" | `Aborted -> "aborted") );
      ("reason", match r.reason with None -> `Null | Some s -> `String s);
      ("requests", `Int r.requests);
      ("bytes", `Int r.bytes);
      ("fetched", `Int r.fetched);
      ("unchanged", `Int r.unchanged);
      ("missing", `Int r.missing);
      ("skipped", `Int r.skipped);
      ("errors", `Int r.errors);
      ("changed", `Int (List.length r.changed_packages));
      ( "changed_packages",
        `List
          (List.filteri (fun i _ -> i < 500) r.changed_packages
          |> List.map (fun s -> `String s)) );
      ("last_modified", `List (List.map (fun t -> `Int t) r.last_modified));
    ]

let to_line r = Yojson.Safe.to_string (to_json r) ^ "\n"

(* An HTTP date, "Sun, 06 Nov 1994 08:49:37 GMT", as a Unix time. *)
let parse_http_date s =
  let months =
    [
      "Jan";
      "Feb";
      "Mar";
      "Apr";
      "May";
      "Jun";
      "Jul";
      "Aug";
      "Sep";
      "Oct";
      "Nov";
      "Dec";
    ]
  in
  match
    Scanf.sscanf s "%_s@, %d %s %d %d:%d:%d GMT%!" (fun d mon y hh mm ss ->
        (d, mon, y, hh, mm, ss))
  with
  | exception (Scanf.Scan_failure _ | End_of_file | Failure _) -> None
  | d, mon, y, hh, mm, ss -> (
      let rec index i = function
        | [] -> None
        | m :: _ when m = mon -> Some (i + 1)
        | _ :: l -> index (i + 1) l
      in
      match index 0 months with
      | None -> None
      | Some m -> (
          match Ptime.of_date_time ((y, m, d), ((hh, mm, ss), 0)) with
          | None -> None
          | Some t -> Some (int_of_float (Ptime.to_float_s t))))

(* The records of a stats.jsonl file's contents: those the policy needs. *)
type run = { run_started : int; scraped : bool; run_last_modified : int list }

let runs_of_string s =
  let ( let* ) = Result.bind in
  String.split_on_char '\n' s
  |> List.mapi (fun i l -> (i + 1, l))
  |> List.filter (fun (_, l) -> String.trim l <> "")
  |> List.fold_left
       (fun acc (n, l) ->
         let* acc = acc in
         let fail m = Error (Printf.sprintf "line %d: %s" n m) in
         match Yojson.Safe.from_string l with
         | exception Yojson.Json_error e -> fail e
         | `Assoc f -> (
             let status = List.assoc_opt "status" f in
             match (List.assoc_opt "started" f, status) with
             | Some (`Int started), Some (`String "scraped") -> (
                 match List.assoc_opt "last_modified" f with
                 | Some (`List l)
                   when List.for_all (function `Int _ -> true | _ -> false) l ->
                     Ok
                       ({
                          run_started = started;
                          scraped = true;
                          run_last_modified =
                            List.map (function `Int t -> t | _ -> 0) l;
                        }
                       :: acc)
                 | _ -> fail "last_modified: expected a list of integers")
             | Some (`Int started), Some (`String _) ->
                 Ok
                   ({
                      run_started = started;
                      scraped = false;
                      run_last_modified = [];
                    }
                   :: acc)
             | _ -> fail "expected started and status")
         | _ -> fail "expected an object")
       (Ok [])
  |> Result.map List.rev
