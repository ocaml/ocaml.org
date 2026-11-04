(* Resource sampling, from the host, without touching the container.

   - Container totals from its cgroup (v2): [memory.current], [memory.peak],
   [anon]/[file] from [memory.stat], CPU from [cpu.stat]'s [usage_usec], swap
   from [memory.swap.current], major page faults from [memory.stat], and the
   share of time stalled on memory from [memory.pressure] (PSI). - The server
   process's [VmRSS]/[VmHWM] from [/proc/<pid>/status]. - The host's available
   memory and swap use ([/proc/meminfo]), major page faults ([/proc/vmstat]) and
   memory stall share ([/proc/pressure/memory]): another process short of memory
   on the host can push the server into swap or evict its file cache, which
   slows a run without the server being at fault. *)

open Lwt.Syntax

let read_file path =
  match open_in path with
  | ic ->
      let s = In_channel.input_all ic in
      close_in ic;
      Some s
  | exception Sys_error _ -> None

let int_file path =
  Option.bind (read_file path) (fun s -> int_of_string_opt (String.trim s))

(* [key value] lines, as in [memory.stat] or [cpu.stat]. *)
let kv_file path key =
  Option.bind (read_file path) (fun s ->
      Proc.lines s
      |> List.find_map (fun l ->
             match String.split_on_char ' ' l with
             | [ k; v ] when k = key -> int_of_string_opt v
             | _ -> None))

(* [VmRSS: 123456 kB] lines of [/proc/<pid>/status]; in bytes. *)
let status_kb path key =
  Option.bind (read_file path) (fun s ->
      Proc.lines s
      |> List.find_map (fun l ->
             if String.starts_with ~prefix:(key ^ ":") l then
               Scanf.sscanf_opt l "%_s %d kB" (fun kb -> kb * 1024)
             else None))

(* The cgroup directory of a host process, from [/proc/<pid>/cgroup]'s v2 line
   [0::/system.slice/docker-<id>.scope]. *)
let cgroup_dir pid =
  match read_file (Printf.sprintf "/proc/%d/cgroup" pid) with
  | None -> None
  | Some s ->
      Proc.lines s
      |> List.find_map (fun l ->
             if String.starts_with ~prefix:"0::" l then
               Some ("/sys/fs/cgroup" ^ String.sub l 3 (String.length l - 3))
             else None)

(* The [total=] field (microseconds) of the [some] line of a PSI file
   ([memory.pressure], [/proc/pressure/memory]): the time at least one task was
   stalled waiting for memory. *)
let psi_some_total path =
  Option.bind (read_file path) (fun s ->
      Proc.lines s
      |> List.find_map (fun l ->
             if String.starts_with ~prefix:"some " l then
               List.find_map
                 (fun w ->
                   if String.starts_with ~prefix:"total=" w then
                     int_of_string_opt (String.sub w 6 (String.length w - 6))
                   else None)
                 (String.split_on_char ' ' l)
             else None))

(* [Key: 123 kB] lines of [/proc/meminfo]; in bytes. *)
let meminfo key = status_kb "/proc/meminfo" key

let header =
  [
    "t";
    "mem_current_mb";
    "mem_peak_mb";
    "anon_mb";
    "file_mb";
    "rss_mb";
    "hwm_mb";
    "cpu_pct";
    "swap_mb";
    "majflt_per_s";
    "mem_stall_pct";
    "host_avail_mb";
    "host_swap_mb";
    "host_majflt_per_s";
    "host_mem_stall_pct";
  ]

let mb = function
  | Some b -> Printf.sprintf "%.1f" (float_of_int b /. 1048576.)
  | None -> ""

(* Counters sampled each time, turned into rates over the interval. *)
type counters = {
  at : float;
  cpu_usec : int option;
  majflt : int option;
  stall_usec : int option;
  host_majflt : int option;
  host_stall_usec : int option;
}

let run ~pid ~t0 ~until ~interval csv =
  let cg =
    match cgroup_dir pid with
    | Some d -> d
    | None -> failwith "cannot find the server's cgroup (cgroup v2 required)"
  in
  let f name = Filename.concat cg name in
  let status = Printf.sprintf "/proc/%d/status" pid in
  (* [scale] times the counter's increase per second since [prev] *)
  let rate ~scale prev now get =
    match prev with
    | Some p -> (
        match (get p, get now) with
        | Some u, Some u' when now.at > p.at ->
            Printf.sprintf "%.1f"
              (float_of_int (u' - u) *. scale /. (now.at -. p.at))
        | _ -> "")
    | None -> ""
  in
  let rec loop prev =
    let now = Unix.gettimeofday () in
    if now >= until () then Lwt.return_unit
    else
      let c =
        {
          at = now;
          cpu_usec = kv_file (f "cpu.stat") "usage_usec";
          majflt = kv_file (f "memory.stat") "pgmajfault";
          stall_usec = psi_some_total (f "memory.pressure");
          host_majflt = kv_file "/proc/vmstat" "pgmajfault";
          host_stall_usec = psi_some_total "/proc/pressure/memory";
        }
      in
      (* microseconds per second, as a percentage *)
      let pct = 1e-4 in
      let host_swap =
        match (meminfo "SwapTotal", meminfo "SwapFree") with
        | Some t, Some fr -> Some (t - fr)
        | _ -> None
      in
      Csv.row csv
        [
          Csv.float (now -. t0);
          mb (int_file (f "memory.current"));
          mb (int_file (f "memory.peak"));
          mb (kv_file (f "memory.stat") "anon");
          mb (kv_file (f "memory.stat") "file");
          mb (status_kb status "VmRSS");
          mb (status_kb status "VmHWM");
          rate ~scale:pct prev c (fun c -> c.cpu_usec);
          mb (int_file (f "memory.swap.current"));
          rate ~scale:1. prev c (fun c -> c.majflt);
          rate ~scale:pct prev c (fun c -> c.stall_usec);
          mb (meminfo "MemAvailable");
          mb host_swap;
          rate ~scale:1. prev c (fun c -> c.host_majflt);
          rate ~scale:pct prev c (fun c -> c.host_stall_usec);
        ];
      let* () = Lwt_unix.sleep interval in
      loop (Some c)
  in
  loop None
