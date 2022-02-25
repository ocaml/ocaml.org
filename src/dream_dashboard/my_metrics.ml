[@@@ocaml.warning "-32"]

type cpu_times = {
  user : int;
  nice : int;
  sys : int;
  idle : int;
  irq : int;
  total : int;
}

type loadavg = { avg_1 : float; avg_5 : float; avg_15 : float }
type memory = { free : int; total : int }

let read_cpu_info () =
  match Luv.System_info.cpu_info () with
  | Error _ | Ok [] -> None
  | Ok (cpu :: _) ->
      let user = Unsigned.UInt64.to_int cpu.times.user in
      let nice = Unsigned.UInt64.to_int cpu.times.nice in
      let sys = Unsigned.UInt64.to_int cpu.times.sys in
      let idle = Unsigned.UInt64.to_int cpu.times.idle in
      let irq = Unsigned.UInt64.to_int cpu.times.irq in
      let total = user + nice + sys + irq in
      Some { user; nice; sys; idle; irq; total }

let read_loadavg () =
  let avg_1, avg_5, avg_15 = Luv.Resource.loadavg () in
  { avg_1; avg_5; avg_15 }

let read_memory () =
  let free = Unsigned.UInt64.to_int (Luv.Resource.free_memory ()) in
  let total = Unsigned.UInt64.to_int (Luv.Resource.total_memory ()) in
  { free; total }

(* Src *)

open Metrics

let proc_cpu_src ~tags =
  let doc = "Processor cpu counters" in
  let graph = Graph.v ~title:doc ~ylabel:"value" () in
  let data () =
    match read_cpu_info () with
    | None -> Data.v []
    | Some cpu ->
        Data.v
          [
            uint "user" ~graph cpu.user;
            uint "nice" ~graph cpu.nice;
            uint "sys" ~graph cpu.sys;
            uint "idle" ~graph cpu.idle;
            uint "irq" ~graph cpu.irq;
            uint "total" ~graph cpu.total;
          ]
  in
  Src.v ~doc ~tags ~data "proc_cpu"

let loadavg_src ~tags =
  let doc = "System load average" in
  let graph = Graph.v ~title:doc ~ylabel:"value" () in
  let data () =
    let loadavg = read_loadavg () in
    Data.v
      [
        float "avg_1" ~graph loadavg.avg_1;
        float "avg_5" ~graph loadavg.avg_5;
        float "avg_15" ~graph loadavg.avg_15;
      ]
  in
  Src.v ~doc ~tags ~data "loadavg"

let memory_src ~tags =
  let doc = "System load average" in
  let graph = Graph.v ~title:doc ~ylabel:"value" () in
  let data () =
    let memory = read_memory () in
    Data.v [ uint "free" ~graph memory.free; uint "total" ~graph memory.total ]
  in
  Src.v ~doc ~tags ~data "memory"

(* Reporters *)

(* This is an alternative to Metrics' cache reporter, but we keep the previous
   values of each data points, instead of replacing the Src_map value with the
   latest data point. This allows us to use the reporter to provide a list of
   all the data points to the user. *)
let cache_reporter () =
  let module Src_map = SM in
  let src_map = ref Src_map.empty in
  let report ~tags ~data ~over src k =
    let previous_data =
      match Src_map.find_opt src !src_map with
      | Some (_tags, previous_data) -> previous_data
      | None -> []
    in
    src_map := Src_map.add src (tags, data :: previous_data) !src_map;
    over ();
    k ()
  in
  ((fun () -> !src_map), { report; now; at_exit = (fun () -> ()) })

let get_metrics_ref = ref (fun () -> SM.empty)
let get_metrics () = !get_metrics_ref ()
let loadavg_src = loadavg_src ~tags:[]
let memory_src = memory_src ~tags:[]

let init_metrics ?(interval = 10.0) () =
  Metrics.enable_all ();
  Metrics_lwt.init_periodic (fun () -> Lwt_unix.sleep interval);
  Metrics_lwt.periodically loadavg_src;
  Metrics_lwt.periodically memory_src;
  let get_metrics_new, reporter = cache_reporter () in
  Metrics.set_reporter reporter;
  get_metrics_ref := get_metrics_new

module Metrics_field = struct
  let float f =
    match Metrics.value f with
    | V (Float, x) -> (x : float)
    | _ -> failwith "wrong type for metrics field"

  let uint f =
    match Metrics.value f with
    | V (Uint, x) -> (x : int)
    | _ -> failwith "wrong type for metrics field"
end

let get_field name data =
  let fields = Metrics.Data.fields data in
  List.find (fun field -> Metrics.key field = name) fields

let loadavg_report () =
  let _tags, data =
    match Metrics.SM.find_opt (Src loadavg_src) (get_metrics ()) with
    | Some x -> x
    | None ->
        Logs.err (fun m ->
            m
              "The Metrics src for loadavg could not be found. Did you call \
               \"init_metrics ()\"?");
        raise Not_found
  in
  List.map
    (fun (x : data) ->
      let avg_1 = Metrics_field.float (get_field "avg_1" x) in
      let avg_5 = Metrics_field.float (get_field "avg_5" x) in
      let avg_15 = Metrics_field.float (get_field "avg_15" x) in
      { avg_1; avg_5; avg_15 })
    data

let memory_report () =
  let _tags, data =
    match Metrics.SM.find_opt (Src memory_src) (get_metrics ()) with
    | Some x -> x
    | None ->
        Logs.err (fun m ->
            m
              "The Metrics src for memory could not be found. Did you call \
               \"init_metrics ()\"?");
        raise Not_found
  in
  List.map
    (fun (x : data) ->
      let free = Metrics_field.uint (get_field "free" x) in
      let total = Metrics_field.uint (get_field "total" x) in
      { free; total })
    data
