(** Worker rpc *)

(** Functions to facilitate RPC calls to web workers. *)

module Worker = Brr_webworkers.Worker
open Brr_io

(** The assumption made in this module is that RPCs are answered in the order
    they are made. *)

type context = {
  worker : Worker.t;
  timeout : int;
  timeout_fn : unit -> unit;
  waiting : ((Jv.t, exn) Result.t Lwt_mvar.t * int) Queue.t;
}

exception Timeout

let demux context msg =
  Lwt.async (fun () ->
      match Queue.take_opt context.waiting with
      | None -> Lwt.return ()
      | Some (mv, outstanding_execution) ->
          Brr.G.stop_timer outstanding_execution;
          let msg : Jv.t = Message.Ev.data (Brr.Ev.as_type msg) in
          Lwt_mvar.put mv (Ok msg))

let start worker timeout timeout_fn =
  let context = { worker; timeout; timeout_fn; waiting = Queue.create () } in
  let () =
    Brr.Ev.listen Message.Ev.message (demux context) (Worker.as_target worker)
  in
  context

let rpc context call =
  let open Lwt in
  let jv = Conv.jv_of_rpc_call call in
  let mv = Lwt_mvar.create_empty () in
  let outstanding_execution =
    Brr.G.set_timeout ~ms:10000 (fun () ->
        Lwt.async (fun () -> Lwt_mvar.put mv (Error Timeout));
        context.timeout_fn ())
  in
  Queue.push (mv, outstanding_execution) context.waiting;
  Worker.post context.worker jv;
  Lwt_mvar.take mv >>= fun r ->
  match r with
  | Ok jv ->
      let response = Conv.rpc_response_of_jv jv in
      Lwt.return response
  | Error exn -> Lwt.fail exn
