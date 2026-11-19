(* Map an asynchronous function over the items of one tool call (the versions of
   a package, candidate packages), each costing one or more docs-ci fetches.

   At most [concurrency] items run at once, so that one call does not open
   dozens of connections to docs-ci, yet does not wait for each fetch in turn.

   Each item runs under [Lwt.catch]: one failing item (a docs-ci body the parser
   rejects, a bug) is reported as [Failed], not as the failure of the whole
   call.

   The call has a deadline: an item not started [deadline] seconds after the
   call began is not started at all, and comes back as [Skipped]. Items already
   running are left to finish (each fetch has its own timeout), so a call lasts
   at most about [deadline] plus the time of one item.

   A caller reports [incomplete] results (some item failed or was skipped) as
   partial, and marks them with {!Tool.partial} so that they are not cached. *)

type 'b outcome = Done of 'b | Failed of exn | Skipped

let default_concurrency = 6
let default_deadline = 15.

let map ?(concurrency = default_concurrency) ?(deadline = default_deadline)
    ?(now = Unix.gettimeofday) (f : 'a -> 'b Lwt.t) (items : 'a list) :
    'b outcome list Lwt.t =
  let open Lwt.Syntax in
  let items = Array.of_list items in
  let n = Array.length items in
  let results = Array.make n Skipped in
  let stop = now () +. deadline in
  let next = ref 0 in
  (* Each worker takes the next item not yet taken, until none is left. Past the
     deadline, the items it takes stay [Skipped]. *)
  let rec worker () =
    if !next >= n then Lwt.return_unit
    else
      let i = !next in
      incr next;
      if now () >= stop then worker ()
      else
        let* outcome =
          Lwt.catch
            (fun () ->
              let+ v = f items.(i) in
              Done v)
            (fun e -> Lwt.return (Failed e))
        in
        results.(i) <- outcome;
        worker ()
  in
  let* () =
    Lwt.join (List.init (max 1 (min concurrency n)) (fun _ -> worker ()))
  in
  Lwt.return (Array.to_list results)

let incomplete outcomes =
  List.exists (function Done _ -> false | Failed _ | Skipped -> true) outcomes

let deadline_reached outcomes =
  List.exists (function Skipped -> true | _ -> false) outcomes
