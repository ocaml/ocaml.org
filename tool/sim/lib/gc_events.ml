(* GC activity of the server, read from its OCaml runtime-events ring.

   The server runs with [OCAML_RUNTIME_EVENTS_START=1] and
   [OCAML_RUNTIME_EVENTS_DIR] on a directory shared with the host, so its ring
   ([<pid>.events], pid 1 in the container) can be read from here without any
   change to the server. Events are aggregated into one row per second: the
   number, total and longest duration of minor collections and of major slices
   (the pauses the mutator sees), and the last reported major heap size. Each
   pause is also written on its own to [events], for percentiles and minimum
   mutator utilisation ([Summary]).

   Event timestamps come from the monotonic clock shared by every process on the
   host. To place them on the wall clock, a short-lived child ([sim
   clock-offset]) starts runtime events in itself and reads its clock offset off
   an event it provokes. It must be a separate process: once started, the
   runtime gives every forked child its own ring, and the children of [sim]
   (docker, git) never remove theirs. *)

open Lwt.Syntax

let ns ts = Int64.to_float (Runtime_events.Timestamp.to_int64 ts) /. 1e9

(* [wall - monotonic], in seconds, measured in this process. Only for [sim
   clock-offset]. *)
let measure_offset () =
  Runtime_events.start ();
  let cursor = Runtime_events.create_cursor None in
  let seen = ref None in
  let cb =
    Runtime_events.Callbacks.create
      ~runtime_begin:(fun _ ts phase ->
        if phase = Runtime_events.EV_EXPLICIT_GC_MINOR && !seen = None then
          seen := Some (ns ts))
      ()
  in
  let rec attempt n =
    let before = Unix.gettimeofday () in
    Gc.minor ();
    let after = Unix.gettimeofday () in
    ignore (Runtime_events.read_poll cursor cb None);
    match !seen with
    | Some mono -> ((before +. after) /. 2.) -. mono
    | None when n > 0 -> attempt (n - 1)
    | None -> failwith "could not calibrate the runtime-events clock"
  in
  let offset = attempt 10 in
  Runtime_events.free_cursor cursor;
  offset

(* [measure_offset] in a child process whose ring goes to [dir]. *)
let clock_offset ~dir =
  let+ out =
    Proc.read
      ~extra_env:[ ("OCAML_RUNTIME_EVENTS_DIR", dir) ]
      [ Sys.executable_name; "clock-offset" ]
  in
  match float_of_string_opt (String.trim out) with
  | Some x -> x
  | None -> failwith ("sim clock-offset: unexpected output: " ^ out)

type bucket = {
  mutable minor_n : int;
  mutable minor_sum : float;
  mutable minor_max : float;
  mutable major_n : int;
  mutable major_sum : float;
  mutable major_max : float;
}

let empty () =
  {
    minor_n = 0;
    minor_sum = 0.;
    minor_max = 0.;
    major_n = 0;
    major_sum = 0.;
    major_max = 0.;
  }

let header =
  [
    "t";
    "minor_n";
    "minor_ms";
    "minor_max_ms";
    "major_slice_n";
    "major_slice_ms";
    "major_slice_max_ms";
    "heap_mb";
    "lost_events";
  ]

let rec wait_for path ~until =
  if Sys.file_exists path then Lwt.return_true
  else if Unix.gettimeofday () >= until then Lwt.return_false
  else
    let* () = Lwt_unix.sleep 0.2 in
    wait_for path ~until

(* Header of the per-event file: one row per minor collection or major slice,
   with its start time and duration. *)
let events_header = [ "t"; "kind"; "ms" ]

let run ~dir ~pid ~t0 ~until ~events csv =
  let* offset = clock_offset ~dir in
  let ring = Filename.concat dir (string_of_int pid ^ ".events") in
  let* ok =
    wait_for ring ~until:(Float.min until (Unix.gettimeofday () +. 60.))
  in
  if not ok then (
    prerr_endline ("sim: no runtime-events ring at " ^ ring ^ "; no GC data");
    Lwt.return_unit)
  else
    let cursor = Runtime_events.create_cursor (Some (dir, pid)) in
    let buckets : (int, bucket) Hashtbl.t = Hashtbl.create 64 in
    let open_spans = Hashtbl.create 8 in
    let heap = ref None and pool = ref 0 and large = ref 0 and lost = ref 0 in
    let bucket sec =
      match Hashtbl.find_opt buckets sec with
      | Some b -> b
      | None ->
          let b = empty () in
          Hashtbl.replace buckets sec b;
          b
    in
    let tracked = function
      | Runtime_events.EV_MINOR | EV_MAJOR_SLICE -> true
      | _ -> false
    in
    let cb =
      Runtime_events.Callbacks.create
        ~runtime_begin:(fun ring ts phase ->
          if tracked phase then Hashtbl.replace open_spans (ring, phase) (ns ts))
        ~runtime_end:(fun ring ts phase ->
          match Hashtbl.find_opt open_spans (ring, phase) with
          | None -> ()
          | Some start ->
              Hashtbl.remove open_spans (ring, phase);
              let t = start +. offset -. t0 in
              let ms = (ns ts -. start) *. 1000. in
              Csv.row events
                [
                  Csv.float6 t;
                  (if phase = EV_MINOR then "minor" else "major");
                  Printf.sprintf "%.4f" ms;
                ];
              let b = bucket (int_of_float t) in
              if phase = EV_MINOR then (
                b.minor_n <- b.minor_n + 1;
                b.minor_sum <- b.minor_sum +. ms;
                b.minor_max <- Float.max b.minor_max ms)
              else (
                b.major_n <- b.major_n + 1;
                b.major_sum <- b.major_sum +. ms;
                b.major_max <- Float.max b.major_max ms))
        ~runtime_counter:(fun _ _ counter v ->
          match counter with
          | EV_C_MAJOR_HEAP_POOL_WORDS ->
              pool := v;
              heap := Some (!pool + !large)
          | EV_C_MAJOR_HEAP_LARGE_WORDS ->
              large := v;
              heap := Some (!pool + !large)
          | _ -> ())
        ~lost_events:(fun _ n -> lost := !lost + n)
        ()
    in
    (* Emit every bucket older than the current second. *)
    let flush ~upto =
      let secs =
        Hashtbl.fold
          (fun s _ acc -> if s < upto then s :: acc else acc)
          buckets []
        |> List.sort compare
      in
      List.iter
        (fun s ->
          let b = Hashtbl.find buckets s in
          Hashtbl.remove buckets s;
          Csv.row csv
            [
              string_of_int s;
              string_of_int b.minor_n;
              Csv.float b.minor_sum;
              Csv.float b.minor_max;
              string_of_int b.major_n;
              Csv.float b.major_sum;
              Csv.float b.major_max;
              (match !heap with
              | Some w ->
                  Printf.sprintf "%.1f" (float_of_int (w * 8) /. 1048576.)
              | None -> "");
              string_of_int !lost;
            ])
        secs
    in
    let rec loop () =
      let now = Unix.gettimeofday () in
      let alive = Sys.file_exists ring in
      (try ignore (Runtime_events.read_poll cursor cb None)
       with Failure _ -> ());
      flush ~upto:(int_of_float (now -. t0));
      if now >= until || not alive then (
        flush ~upto:max_int;
        Runtime_events.free_cursor cursor;
        Lwt.return_unit)
      else
        let* () = Lwt_unix.sleep 0.1 in
        loop ()
    in
    loop ()
