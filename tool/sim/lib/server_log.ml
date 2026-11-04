(* Follow the server's log and pick out the package-state update cycle.

   The lines come from [Ocamlorg_package] (src/ocamlorg_package/lib/): ["Opam
   repo: git pull"], ["Update server state"], the phase timings logged by
   [time_it_lwt] (["Read packages: 12.34s"]), ["Loaded N packages"], ["Package
   state saved"] and ["Failed to update ..."]. [docker logs --timestamps]
   prefixes each line with its RFC 3339 time. *)

open Lwt.Syntax

let header = [ "t"; "event"; "seconds"; "detail" ]

let contains ~sub s =
  let n = String.length sub and m = String.length s in
  let rec go i = i + n <= m && (String.sub s i n = sub || go (i + 1)) in
  go 0

let after ~sub s =
  let n = String.length sub and m = String.length s in
  let rec go i =
    if i + n > m then None
    else if String.sub s i n = sub then Some (String.sub s (i + n) (m - i - n))
    else go (i + 1)
  in
  go 0

(* A timing line, ["<phase>: <seconds>s"], as logged by [time_it_lwt] and its
   siblings. Dream prefixes messages with a date, the log source and the level
   (" INFO "); before Dream sets up logging, and in a separate builder process,
   the default reporter writes ["server: [INFO] "]. The phase starts after the
   level. *)
let timing msg =
  let msg =
    match after ~sub:" INFO " msg with
    | Some m -> m
    | None -> ( match after ~sub:"[INFO] " msg with Some m -> m | None -> msg)
  in
  let msg = String.trim msg in
  match Scanf.sscanf_opt msg "%[^:]: %fs%!" (fun p s -> (p, s)) with
  | Some (p, s)
    when p <> ""
         && String.for_all
              (fun c ->
                c = ' ' || Char.lowercase_ascii c <> Char.uppercase_ascii c)
              p ->
      Some ("phase", Printf.sprintf "%.2f" s, p)
  | _ -> None

(* [Some (event, seconds, detail)] for the lines we care about. *)
let classify msg =
  match timing msg with
  | Some _ as r -> r
  | None -> (
      match after ~sub:"Opam repository is currently at " msg with
      | Some sha -> Some ("at", "", String.trim sha)
      | None -> (
          if contains ~sub:"Opam repo: git pull" msg then Some ("pull", "", "")
          else if contains ~sub:"Opam repo: git clone" msg then
            Some ("clone", "", "")
          else if contains ~sub:"Update server state" msg then
            Some ("update", "", "")
          else if contains ~sub:"Package state saved" msg then
            Some ("saved", "", "")
          else if contains ~sub:"Failed to update" msg then
            Some ("failed", "", "")
          else
            match after ~sub:"Loaded " msg with
            | Some rest when contains ~sub:" packages" rest -> (
                match Scanf.sscanf_opt rest "%d packages" Fun.id with
                | Some n -> Some ("loaded", "", string_of_int n)
                | None -> None)
            | _ -> None))

let split_timestamp line =
  match String.index_opt line ' ' with
  | None -> None
  | Some i -> (
      match Ptime.of_rfc3339 (String.sub line 0 i) with
      | Ok (t, _, _) ->
          Some
            ( Ptime.to_float_s t,
              String.sub line (i + 1) (String.length line - i - 1) )
      | Error _ -> None)

(* Follow [container]'s log until it exits or [stop] resolves, copying it to
   [raw] and the update events to [csv]. *)
let follow ~container ~t0 ~stop ~raw csv =
  let cmd =
    ("", [| "docker"; "logs"; "--follow"; "--timestamps"; container |])
  in
  Lwt_process.with_process_full cmd (fun p ->
      let pump ic =
        Lwt_stream.iter
          (fun line ->
            output_string raw line;
            output_char raw '\n';
            flush raw;
            match split_timestamp line with
            | None -> ()
            | Some (t, msg) -> (
                match classify msg with
                | None -> ()
                | Some (event, secs, detail) ->
                    Csv.row csv [ Csv.float (t -. t0); event; secs; detail ]))
          (Lwt_io.read_lines ic)
      in
      let* () = Lwt.pick [ Lwt.join [ pump p#stdout; pump p#stderr ]; stop ] in
      flush raw;
      p#terminate;
      let+ _ = p#close in
      ())
