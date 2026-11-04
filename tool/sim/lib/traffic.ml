(* Open-loop HTTP traffic.

   Each stream draws its request times from a Poisson process whose rate may
   vary over time, independently of how fast the server answers: a slow server
   does not slow the generator down (no coordinated omission), and latency is
   measured from the {e scheduled} time, so time spent queued behind a stalled
   server counts. When [max_inflight] requests are already outstanding, a new
   one is not sent and is recorded as dropped.

   The whole schedule (send times and paths) is drawn before the first request,
   from random generators derived from the seed: one per stream for its times,
   one per stream for its paths. It is counted from the moment traffic starts,
   so two runs with the same seed, profile and options send the same requests at
   the same offsets, whatever the server does. *)

open Lwt.Syntax

type stream = {
  name : string;
  rate : float -> float;
      (** requests per second, [offset] seconds after traffic starts *)
  peak : float;  (** an upper bound of [rate] *)
  next : unit -> string;  (** path of the next request *)
}

(* A random generator for [purpose] (e.g. a stream's times), derived from [seed]
   alone, so that it does not depend on which other streams exist or on the
   order in which they draw. *)
let rng ~seed purpose = Random.State.make [| seed; Hashtbl.hash purpose |]

(* Packages and their versions, from the opam repository the server runs on, to
   fill the [{pkg}] and [{ver}] placeholders and to drive the crawler. *)
type packages = (string * string array) array

let packages_of_find out : packages =
  (* lines are [<root>/packages/<name>/<name>.<version>] *)
  let tbl = Hashtbl.create 8192 in
  List.iter
    (fun line ->
      match List.rev (String.split_on_char '/' line) with
      | dir :: name :: "packages" :: _ ->
          let prefix = name ^ "." in
          if String.starts_with ~prefix dir then
            let ver =
              String.sub dir (String.length prefix)
                (String.length dir - String.length prefix)
            in
            Hashtbl.replace tbl name
              (ver :: Option.value ~default:[] (Hashtbl.find_opt tbl name))
      | _ -> ())
    (Proc.lines out);
  Hashtbl.fold (fun n vs acc -> (n, Array.of_list vs) :: acc) tbl []
  |> List.sort compare |> Array.of_list

let replace_all ~sub ~by s =
  let b = Buffer.create (String.length s) in
  let n = String.length sub in
  let rec go i =
    if i > String.length s - n then
      Buffer.add_string b (String.sub s i (String.length s - i))
    else if String.sub s i n = sub then (
      Buffer.add_string b by;
      go (i + n))
    else (
      Buffer.add_char b s.[i];
      go (i + 1))
  in
  go 0;
  Buffer.contents b

let instantiate rng (pkgs : packages) path =
  if Array.length pkgs = 0 || not (String.contains path '{') then path
  else
    let name, vers = pkgs.(Random.State.int rng (Array.length pkgs)) in
    let ver =
      if Array.length vers = 0 then ""
      else vers.(Random.State.int rng (Array.length vers))
    in
    path
    |> replace_all ~sub:"{pkg}" ~by:name
    |> replace_all ~sub:"{ver}" ~by:ver

(* Human visitors: a profile's page mix at its diurnal rate. [hour_of] maps an
   offset from the start of traffic to the UTC hour whose weight applies. *)
let human ~seed ~profile ~packages ~scale ~hour_of =
  let paths = rng ~seed "human paths" in
  let s = Profile.sampler profile in
  let rate_at h =
    profile.Profile.base_rps *. scale *. profile.hourly.(h mod 24)
  in
  {
    name = "human";
    rate = (fun offset -> rate_at (hour_of offset));
    peak = Array.fold_left Float.max 0. (Array.init 24 rate_at);
    next =
      (fun () ->
        instantiate paths packages
          (Profile.pick s (Random.State.float paths 1.)));
  }

(* A crawler sweeping every package and package-version page in a shuffled
   order, at a constant rate. Documentation pages are proxied to the external
   docs server, so they are only included on request. *)
let crawler ~seed ~packages ~rps ~include_docs =
  let shuffle = rng ~seed "bot order" in
  let urls =
    Array.to_list packages
    |> List.concat_map (fun (name, vers) ->
           ("/p/" ^ name)
           :: List.concat_map
                (fun v ->
                  let base = "/p/" ^ name ^ "/" ^ v in
                  if include_docs then [ base; base ^ "/doc/index.html" ]
                  else [ base ])
                (Array.to_list vers))
    |> Array.of_list
  in
  let n = Array.length urls in
  for i = n - 1 downto 1 do
    let j = Random.State.int shuffle (i + 1) in
    let t = urls.(i) in
    urls.(i) <- urls.(j);
    urls.(j) <- t
  done;
  let i = ref 0 in
  {
    name = "bot";
    rate = (fun _ -> rps);
    peak = rps;
    next =
      (fun () ->
        if n = 0 then "/"
        else
          let u = urls.(!i mod n) in
          incr i;
          u);
  }

type planned = {
  offset : float;  (** seconds after traffic starts *)
  stream : string;
  id : int;  (** position in its stream, from 0 *)
  path : string;
}

(* Send times of a Poisson process of rate [rate] over [[0, duration)], by
   thinning: candidates at the constant rate [peak], each kept with probability
   [rate t / peak]. *)
let times ~rng ~rate ~peak ~duration =
  if peak <= 0. then []
  else
    let rec go t acc =
      let t = t -. (log (1. -. Random.State.float rng 1.) /. peak) in
      if t >= duration then List.rev acc
      else
        let keep = Random.State.float rng 1. *. peak < rate t in
        go t (if keep then t :: acc else acc)
    in
    go 0. []

(* Every request of every stream over [duration] seconds, in send order. *)
let plan ~seed ~duration streams =
  List.concat_map
    (fun s ->
      times
        ~rng:(rng ~seed (s.name ^ " times"))
        ~rate:s.rate ~peak:s.peak ~duration
      |> List.mapi (fun id offset ->
             { offset; stream = s.name; id; path = s.next () }))
    streams
  |> List.stable_sort (fun a b -> compare a.offset b.offset)
  |> Array.of_list

let header =
  [
    "t_sched";
    "t_send";
    "latency";
    "status";
    "bytes";
    "stream";
    "class";
    "path";
    "id";
  ]

let request ~base ~timeout path =
  let uri = Uri.of_string (Uri.to_string base ^ path) in
  let get =
    let* resp, body = Cohttp_lwt_unix.Client.get uri in
    let+ s = Cohttp_lwt.Body.to_string body in
    ( string_of_int (Cohttp.Code.code_of_status (Cohttp.Response.status resp)),
      String.length s )
  in
  let timed_out =
    let+ () = Lwt_unix.sleep timeout in
    ("timeout", 0)
  in
  Lwt.catch
    (fun () -> Lwt.pick [ get; timed_out ])
    (fun _ -> Lwt.return ("error", 0))

(* Send [plan] (from [plan]), counting offsets from [start], up to [until]. *)
let run ~base ~t0 ~start ~until ~max_inflight ~timeout csv plan =
  let inflight = ref 0 in
  (* Once [run] returns, the caller closes [csv]: a request that resolves later
     (only if the event loop lags past [drain]) must not write to it. *)
  let finished = ref false in
  let record ~sched ~send ~fin ~status ~bytes (p : planned) =
    if !finished then ()
    else
      Csv.row csv
        [
          Csv.float6 (sched -. t0);
          Csv.float6 (send -. t0);
          Csv.float6 (fin -. sched);
          status;
          string_of_int bytes;
          p.stream;
          Profile.classify p.path;
          (* the only field that may contain a comma *)
          replace_all ~sub:"," ~by:"%2C" p.path;
          string_of_int p.id;
        ]
  in
  let fire p sched =
    let send = Unix.gettimeofday () in
    if !inflight >= max_inflight then
      record ~sched ~send ~fin:send ~status:"drop" ~bytes:0 p
    else (
      incr inflight;
      Lwt.async (fun () ->
          let+ status, bytes = request ~base ~timeout p.path in
          decr inflight;
          record ~sched ~send ~fin:(Unix.gettimeofday ()) ~status ~bytes p))
  in
  let rec go i =
    if i >= Array.length plan then Lwt.return_unit
    else
      let p = plan.(i) in
      let sched = start +. p.offset in
      if sched >= until then Lwt.return_unit
      else
        let wait = sched -. Unix.gettimeofday () in
        let* () = if wait > 0. then Lwt_unix.sleep wait else Lwt.return_unit in
        fire p sched;
        go (i + 1)
  in
  let* () = go 0 in
  (* let outstanding requests finish (they time out after [timeout]) *)
  let rec drain n =
    if !inflight = 0 || n <= 0 then Lwt.return_unit
    else
      let* () = Lwt_unix.sleep 0.1 in
      drain (n - 1)
  in
  let+ () = drain (int_of_float (timeout *. 10.) + 10) in
  finished := true;
  if !inflight > 0 then
    Printf.eprintf
      "sim: %d requests still outstanding when the traffic ended; not recorded\n\
       %!"
      !inflight
