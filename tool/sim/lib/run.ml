(* One simulation run: start the server container, replay opam-repository
   history into it, send it traffic, and record everything under [out]. *)

open Lwt.Syntax

type diurnal = Compressed | Wall | Off

(* Where the server fetches package documentation from: [Docs_stub] (the
   default), or the real external server. *)
type docs = Stub | Real

type config = {
  image : string;
  compose : string;  (** path to compose.yaml *)
  project : string;  (** compose project name *)
  out : string;  (** run directory, created *)
  days : float;  (** history window to replay *)
  speedup : float;
  poll : int;  (** OCAMLORG_OPAM_POLLING, seconds *)
  duration : float;  (** seconds *)
  port : int;
  mem : string;
  cpus : string;
  profile : Profile.t option;  (** human traffic; [None] for none *)
  traffic_scale : float;
  diurnal : diurnal;
  bot_rps : float;
  include_docs : bool;
  max_inflight : int;
  timeout : float;
  seed : int;
  keep : bool;  (** leave the container running at the end *)
  docs : docs;
  docs_port : int;  (** host port of the docs stub *)
}

let compose_cmd c args =
  [ "docker"; "compose"; "-f"; c.compose; "-p"; c.project ] @ args

let mkdir_p path perm =
  let rec go p =
    if not (Sys.file_exists p) then (
      go (Filename.dirname p);
      Unix.mkdir p perm)
  in
  go path

let absolute p =
  if Filename.is_relative p then Filename.concat (Sys.getcwd ()) p else p

let hour_utc t = int_of_float (Float.rem t 86400. /. 3600.)

let rec wait_http base ~until =
  (* Docker's port proxy accepts connections before the server listens, and such
     a connection can hang: bound every probe. *)
  let probe () =
    let* resp, body = Cohttp_lwt_unix.Client.get (Uri.with_path base "/") in
    let+ () = Cohttp_lwt.Body.drain_body body in
    Cohttp.Code.code_of_status (Cohttp.Response.status resp) < 500
  in
  let ready =
    Lwt.catch
      (fun () ->
        Lwt.pick [ probe (); Lwt.map (fun () -> false) (Lwt_unix.sleep 5.) ])
      (fun _ -> Lwt.return_false)
  in
  let* ok = ready in
  if ok then Lwt.return_true
  else if Unix.gettimeofday () >= until then Lwt.return_false
  else
    let* () = Lwt_unix.sleep 1. in
    wait_http base ~until

let write_meta c ~h ~image_id ~t0 ~t_ready ~packages =
  let n = Array.length h in
  let json : Yojson.Safe.t =
    `Assoc
      [
        ("image", `String c.image);
        ("image_id", `String image_id);
        ("started", `Float t0);
        ( "ready_after",
          match t_ready with Some t -> `Float (t -. t0) | None -> `Null );
        ("history_days", `Float c.days);
        ("history_commits", `Int n);
        ("start_commit", `String h.(0).Upstream.sha);
        ("start_commit_time", `Float h.(0).time);
        ("tip_commit", `String h.(n - 1).sha);
        ("speedup", `Float c.speedup);
        ("poll", `Int c.poll);
        ("duration", `Float c.duration);
        ("mem", `String c.mem);
        ("cpus", `String c.cpus);
        ( "profile",
          match c.profile with Some p -> `String p.source | None -> `Null );
        ("traffic_scale", `Float c.traffic_scale);
        ( "diurnal",
          `String
            (match c.diurnal with
            | Compressed -> "compressed"
            | Wall -> "wall"
            | Off -> "off") );
        ("bot_rps", `Float c.bot_rps);
        ("include_docs", `Bool c.include_docs);
        ("packages", `Int packages);
        ("seed", `Int c.seed);
        ("docs", `String (match c.docs with Stub -> "stub" | Real -> "real"));
      ]
  in
  Yojson.Safe.to_file (Filename.concat c.out "meta.json") json

let run c =
  mkdir_p c.out 0o755;
  let rte = Filename.concat c.out "rte" in
  mkdir_p rte 0o777;
  (* the server runs as uid 1000 and must create its ring here *)
  Unix.chmod rte 0o777;
  let file name = Filename.concat c.out name in
  let* image_id =
    Proc.read [ "docker"; "image"; "inspect"; "-f"; "{{.Id}}"; c.image ]
  in
  let image_id = String.trim image_id in
  Printf.printf "sim: reading opam-repository history from %s\n%!" c.image;
  let* h = Upstream.history ~image:c.image ~days:c.days in
  Printf.printf "sim: %d first-parent commits over %.1f days; start at %s\n%!"
    (Array.length h) c.days h.(0).sha;
  (* The docs stub listens on the Docker bridge gateway, which containers reach
     by IP: no name resolution is involved. *)
  let* stub, docs_env =
    match c.docs with
    | Real -> Lwt.return (None, [])
    | Stub ->
        let* gw =
          Proc.read
            [
              "docker";
              "network";
              "inspect";
              "bridge";
              "-f";
              "{{(index .IPAM.Config 0).Gateway}}";
            ]
        in
        let gw = String.trim gw in
        let+ stub = Docs_stub.start ~host:gw ~port:c.docs_port in
        let base = Printf.sprintf "http://%s:%d/" gw c.docs_port in
        ( Some stub,
          [ ("SIM_DOC_URL", base ^ "docs/"); ("SIM_DOC_STATUS_URL", base) ] )
  in
  let env =
    docs_env
    @ [
        ("SIM_IMAGE", c.image);
        ("SIM_START", h.(0).sha);
        ("SIM_POLL", string_of_int c.poll);
        ("SIM_PORT", string_of_int c.port);
        ("SIM_MEM", c.mem);
        ("SIM_CPUS", c.cpus);
        ("SIM_RTE_DIR", absolute rte);
      ]
  in
  let* () =
    Proc.run ~extra_env:env (compose_cmd c [ "down"; "--remove-orphans" ])
  in
  let t0 = Unix.gettimeofday () in
  let until = t0 +. c.duration in
  let* () = Proc.run ~extra_env:env (compose_cmd c [ "up"; "-d" ]) in
  let* container =
    Proc.read ~extra_env:env (compose_cmd c [ "ps"; "-q"; "server" ])
  in
  let container = String.trim container in
  if container = "" then failwith "the server container did not start";
  let* pid =
    Proc.read [ "docker"; "inspect"; "-f"; "{{.State.Pid}}"; container ]
  in
  let pid = int_of_string (String.trim pid) in
  let stop, stop_wakener = Lwt.wait () in
  let raw = open_out (file "server.log") in
  let sync_csv = Csv.create (file "sync.csv") Server_log.header in
  let logs = Server_log.follow ~container ~t0 ~stop ~raw sync_csv in
  (* The ring is created by the server as soon as its runtime starts, owned by
     uid 1000 and readable by its owner only; open it up for the host. *)
  let ring_in_container = "/sim/rte/1.events" in
  let rec open_ring n =
    if n = 0 then (
      prerr_endline "sim: the server created no runtime-events ring";
      Lwt.return_unit)
    else if Sys.file_exists (Filename.concat rte "1.events") then
      Proc.run
        [
          "docker";
          "exec";
          "-u";
          "0";
          container;
          "chmod";
          "0644";
          ring_in_container;
        ]
    else
      let* () = Lwt_unix.sleep 0.5 in
      open_ring (n - 1)
  in
  let* () = open_ring 120 in
  let base = Uri.of_string (Printf.sprintf "http://127.0.0.1:%d" c.port) in
  let feed_csv = Csv.create (file "feed.csv") Upstream.feed_header in
  let res_csv = Csv.create (file "resources.csv") Sampler.header in
  let gc_csv = Csv.create (file "gc.csv") Gc_events.header in
  let gc_events_csv =
    Csv.create (file "gc-events.csv") Gc_events.events_header
  in
  (* The moment the server first answers is the origin of both the upstream
     replay and the traffic, so they stay aligned with each other whatever the
     start-up time. *)
  let ready =
    let+ ok = wait_http base ~until in
    let t = Unix.gettimeofday () in
    Printf.printf "sim: server %s after %.0fs\n%!"
      (if ok then "answering" else "NOT answering")
      (t -. t0);
    if ok then Some t else None
  in
  let feeder =
    let* r = ready in
    match r with
    | None -> Lwt.return_unit
    | Some origin ->
        Upstream.feed ~container ~h ~speedup:c.speedup ~t0 ~origin ~until
          feed_csv
  in
  let sampler = Sampler.run ~pid ~t0 ~until ~interval:1. res_csv in
  let gc =
    Gc_events.run ~dir:rte ~pid:1 ~t0 ~until ~events:gc_events_csv gc_csv
  in
  let traffic =
    let* t_ready = ready in
    let* found =
      Proc.read
        [
          "docker";
          "exec";
          container;
          "find";
          Upstream.clone_path ^ "/packages";
          "-mindepth";
          "2";
          "-maxdepth";
          "2";
          "-type";
          "d";
        ]
    in
    let packages = Traffic.packages_of_find found in
    write_meta c ~h ~image_id ~t0 ~t_ready ~packages:(Array.length packages);
    let start = Option.value ~default:t0 t_ready in
    (* The hour of the profile's daily curve, [offset] seconds into the traffic.
       With [Compressed], it follows the replayed history from its start, so it
       is the same in every run with the same options. *)
    let hour_of offset =
      match c.diurnal with
      | Compressed -> hour_utc (h.(0).Upstream.time +. (offset *. c.speedup))
      | Wall -> hour_utc (start +. offset)
      | Off -> 0
    in
    let streams =
      (match c.profile with
      | None -> []
      | Some profile ->
          let profile =
            if c.diurnal = Off then { profile with hourly = Array.make 24 1. }
            else profile
          in
          [
            Traffic.human ~seed:c.seed ~profile ~packages ~scale:c.traffic_scale
              ~hour_of;
          ])
      @
      if c.bot_rps > 0. then
        [
          Traffic.crawler ~seed:c.seed ~packages ~rps:c.bot_rps
            ~include_docs:c.include_docs;
        ]
      else []
    in
    let csv = Csv.create (file "traffic.csv") Traffic.header in
    let+ () =
      if t_ready <> None then
        let plan = Traffic.plan ~seed:c.seed ~duration:c.duration streams in
        Traffic.run ~base ~t0 ~start ~until ~max_inflight:c.max_inflight
          ~timeout:c.timeout csv plan
      else Lwt.return_unit
    in
    Csv.close csv
  in
  let* () = Lwt.join [ feeder; sampler; gc; traffic ] in
  Lwt.wakeup_later stop_wakener ();
  let* () = logs in
  List.iter Csv.close [ feed_csv; res_csv; gc_csv; gc_events_csv; sync_csv ];
  close_out raw;
  let* () =
    if c.keep then (
      Printf.printf "sim: container %s left running (--keep)\n%!" container;
      Lwt.return_unit)
    else Proc.run ~extra_env:env (compose_cmd c [ "down" ])
  in
  (* Every process the server forks (git) inherits runtime events and leaves a
     ring of its own behind; they are sparse, but numerous. *)
  Array.iter
    (fun f ->
      if Filename.check_suffix f ".events" && not (c.keep && f = "1.events")
      then try Sys.remove (Filename.concat rte f) with Sys_error _ -> ())
    (Sys.readdir rte);
  match stub with
  | None -> Lwt.return_unit
  | Some stub ->
      let* () = Docs_stub.stop stub in
      let counts = Docs_stub.counts stub in
      Yojson.Safe.to_file (file "docs-stub.json")
        (`Assoc (List.map (fun (k, n) -> (k, `Int n)) counts));
      Printf.printf "sim: docs stub answered %s\n%!"
        (String.concat ", "
           (List.map (fun (k, n) -> Printf.sprintf "%d %s" n k) counts));
      Lwt.return_unit
