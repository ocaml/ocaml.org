(* Worker_rpc *)

(** Functions to facilitate RPC calls to web workers.

    The assumption made in this module is that RPCs are answered in the order
    they are made. *)

type context
(** Represents the channel used to communicate with the worker *)

exception Timeout
(** When RPC calls take too long, the Lwt promise is set to failed state with
    this exception. *)

val start : Brr_webworkers.Worker.t -> int -> (unit -> unit) -> context
(** [start worker timeout timeout_fn] initialises communications with a web
    worker. [timeout] is the number of seconds to wait for a response from any
    RPC before raising an error, and [timeout_fn] is called when a timeout
    occurs. *)

val rpc :
  context -> Js_top_worker_rpc.Rpc.call -> Js_top_worker_rpc.Rpc.response Lwt.t
(** [rpc context call] returns a promise containing the result from the worker.
    If we wait longer than the timeout specified in [context] for a response,
    the Lwt promise will fail with exception {!Timeout}. *)
