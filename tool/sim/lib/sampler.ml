(* Resource sampling, from the host, without touching the container.

   - Container totals from its cgroup (v2): [memory.current], [memory.peak],
   [anon]/[file] from [memory.stat], CPU from [cpu.stat]'s [usage_usec]. - The
   server process's [VmRSS]/[VmHWM] from [/proc/<pid>/status]. *)

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
  ]

let mb = function
  | Some b -> Printf.sprintf "%.1f" (float_of_int b /. 1048576.)
  | None -> ""

let run ~pid ~t0 ~until ~interval csv =
  let cg =
    match cgroup_dir pid with
    | Some d -> d
    | None -> failwith "cannot find the server's cgroup (cgroup v2 required)"
  in
  let f name = Filename.concat cg name in
  let status = Printf.sprintf "/proc/%d/status" pid in
  let rec loop prev =
    let now = Unix.gettimeofday () in
    if now >= until () then Lwt.return_unit
    else
      let usage = kv_file (f "cpu.stat") "usage_usec" in
      let cpu =
        match (prev, usage) with
        | Some (t, u), Some u' when now > t ->
            Printf.sprintf "%.1f"
              (float_of_int (u' - u) /. 1e6 /. (now -. t) *. 100.)
        | _ -> ""
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
          cpu;
        ];
      let* () = Lwt_unix.sleep interval in
      loop (Option.map (fun u -> (now, u)) usage)
  in
  loop None
