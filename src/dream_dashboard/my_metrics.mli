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

val init_metrics : ?interval:float -> unit -> unit
(** Initialize the metrics reporting.

    The metrics will be periodically collected every [interval] seconds. *)

val loadavg_report : unit -> loadavg list
(** [loadavg_report ()] is the list of loadavg data points collected at the
    interval passed to [init_metrics]. *)

val memory_report : unit -> memory list
(** [memory_report ()] is the list of memory data points collected at the
    interval passed to [init_metrics]. *)
