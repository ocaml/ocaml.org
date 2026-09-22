(* In-app response cache for the MCP endpoint (issue #3775, Phase 2). MCP is
   JSON-RPC over HTTP POST, which stock Varnish passes uncached, so this is the
   only response cache we control (see {!Rate_limiter} for how this Varnish
   bypass forces caching in-app but does *not* likewise force rate limiting).
   Bounded FIFO with a TTL, keyed on a canonical [(method, params)] string.

   The no-op [ping] tool is not cacheable, so Phase 2 registers no entries; the
   substrate is here for Blocks A/B to opt deterministic tools into. As with the
   rate limiter, all access is synchronous under cooperative Lwt scheduling, so
   the [Hashtbl] and [Queue] need no lock. *)

type entry = { value : Yojson.Safe.t; stored : float }

type t = {
  max_entries : int;
  ttl : float;
  table : (string, entry) Hashtbl.t;
  order : string Queue.t; (* insertion order, for FIFO eviction *)
}

let create ~max_entries ~ttl =
  { max_entries; ttl; table = Hashtbl.create 256; order = Queue.create () }

(* Evict oldest entries until below the cap. Keys already gone from [table]
   (e.g. expired and removed) are skipped. *)
let rec evict_to_cap t =
  if Hashtbl.length t.table >= t.max_entries && not (Queue.is_empty t.order)
  then (
    let oldest = Queue.pop t.order in
    Hashtbl.remove t.table oldest;
    evict_to_cap t)

let store t ~now ~key value =
  if not (Hashtbl.mem t.table key) then (
    evict_to_cap t;
    Queue.push key t.order);
  Hashtbl.replace t.table key { value; stored = now }

(* Return the cached value for [key] if present and unexpired, otherwise run
   [compute], store, and return its result. Time is injected for testability. *)
let find_or_compute t ~now ~key compute =
  match Hashtbl.find_opt t.table key with
  | Some e when now -. e.stored < t.ttl -> e.value
  | _ ->
      let value = compute () in
      store t ~now ~key value;
      value
