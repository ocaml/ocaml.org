(* Open-loop HTTP traffic.

   Each stream draws its request times from a Poisson process whose rate may
   vary over time, independently of how fast the server answers: a slow server
   does not slow the generator down (no coordinated omission), and latency is
   measured from the {e scheduled} time, so time spent queued behind a stalled
   server counts. When [max_inflight] requests are already outstanding, a new
   one is not sent and is recorded as dropped. *)

open Lwt.Syntax

type stream = {
  name : string;
  rate : float -> float;  (** requests per second at a given wall-clock time *)
  next : unit -> string;  (** path of the next request *)
}

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

(* Human visitors: a profile's page mix at its diurnal rate. [hour_of] maps
   wall-clock time to the UTC hour whose weight applies. *)
let human ~rng ~profile ~packages ~scale ~hour_of =
  let s = Profile.sampler profile in
  {
    name = "human";
    rate =
      (fun now ->
        profile.Profile.base_rps *. scale *. profile.hourly.(hour_of now mod 24));
    next =
      (fun () ->
        instantiate rng packages (Profile.pick s (Random.State.float rng 1.)));
  }

(* A crawler sweeping every package and package-version page in a shuffled
   order, at a constant rate. Documentation pages are proxied to the external
   docs server, so they are only included on request. *)
let crawler ~rng ~packages ~rps ~include_docs =
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
    let j = Random.State.int rng (i + 1) in
    let t = urls.(i) in
    urls.(i) <- urls.(j);
    urls.(j) <- t
  done;
  let i = ref 0 in
  {
    name = "bot";
    rate = (fun _ -> rps);
    next =
      (fun () ->
        if n = 0 then "/"
        else
          let u = urls.(!i mod n) in
          incr i;
          u);
  }

let header =
  [
    "t_sched"; "t_send"; "latency"; "status"; "bytes"; "stream"; "class"; "path";
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

let run ~base ~t0 ~until ~max_inflight ~timeout ~rng csv streams =
  let inflight = ref 0 in
  let record ~sched ~send ~fin ~status ~bytes ~stream path =
    Csv.row csv
      [
        Csv.float6 (sched -. t0);
        Csv.float6 (send -. t0);
        Csv.float6 (fin -. sched);
        status;
        string_of_int bytes;
        stream;
        Profile.classify path;
        (* the only field that may contain a comma *)
        replace_all ~sub:"," ~by:"%2C" path;
      ]
  in
  let fire stream sched =
    let path = stream.next () in
    let send = Unix.gettimeofday () in
    if !inflight >= max_inflight then
      record ~sched ~send ~fin:send ~status:"drop" ~bytes:0 ~stream:stream.name
        path
    else (
      incr inflight;
      Lwt.async (fun () ->
          let+ status, bytes = request ~base ~timeout path in
          decr inflight;
          record ~sched ~send ~fin:(Unix.gettimeofday ()) ~status ~bytes
            ~stream:stream.name path))
  in
  let loop stream =
    let rec go sched =
      if sched >= until then Lwt.return_unit
      else
        let r = stream.rate sched in
        if r <= 0. then
          (* idle: check again in a second *)
          let* () = Lwt_unix.sleep 1. in
          go (Float.max sched (Unix.gettimeofday ()))
        else
          let dt = -.log (1. -. Random.State.float rng 1.) /. r in
          let sched = sched +. dt in
          let wait = sched -. Unix.gettimeofday () in
          let* () = if wait > 0. then Lwt_unix.sleep wait else Lwt.pause () in
          if sched < until then fire stream sched;
          go sched
    in
    go (Unix.gettimeofday ())
  in
  let* () = Lwt.join (List.map loop streams) in
  (* let outstanding requests finish (they time out after [timeout]) *)
  let rec drain n =
    if !inflight = 0 || n <= 0 then Lwt.return_unit
    else
      let* () = Lwt_unix.sleep 0.1 in
      drain (n - 1)
  in
  drain (int_of_float (timeout *. 10.) + 10)
