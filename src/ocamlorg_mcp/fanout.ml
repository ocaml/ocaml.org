(* Map an asynchronous function over the items of one tool call (the versions of
   a package, candidate packages), each costing one or more docs-ci fetches.

   At most [concurrency] items run at once, so that one call does not open
   dozens of connections to docs-ci, yet does not wait for each fetch in turn.

   Each item runs under [Lwt.catch]: one failing item (a docs-ci body the parser
   rejects, a bug) is reported as [Failed], not as the failure of the whole
   call.

   The call has a deadline, [deadline] seconds after it began. An item not
   started by then is not started at all, and an item still running then is
   cancelled (and so are its fetches); both come back as [Skipped]. So a call
   lasts at most about [deadline], however slow docs-ci is: an item may be
   several fetches, each with a timeout of its own (30 s by default) that is
   longer than the deadline.

   A caller reports [incomplete] results (some item failed or was skipped) as
   partial, and marks them with {!Tool.partial} so that they are not cached. *)

type 'b outcome =
  | Done of 'b
  | Failed of exn
  | Skipped  (** not started before the deadline, or cancelled at it *)

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
  (* An item runs with the time left before the deadline: [Lwt.pick] cancels
     whichever of the item and the timer loses. *)
  let run item remaining =
    Lwt.pick
      [
        Lwt.catch
          (fun () ->
            let+ v = f item in
            Done v)
          (fun e -> Lwt.return (Failed e));
        (let+ () = Lwt_unix.sleep remaining in
         Skipped);
      ]
  in
  (* Each worker takes the next item not yet taken, until none is left. Past the
     deadline, the items it takes stay [Skipped]. *)
  let rec worker () =
    if !next >= n then Lwt.return_unit
    else
      let i = !next in
      incr next;
      let remaining = stop -. now () in
      if remaining <= 0. then worker ()
      else
        let* outcome = run items.(i) remaining in
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
