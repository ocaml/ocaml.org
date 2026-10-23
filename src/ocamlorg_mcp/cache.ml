(* In-app response cache for the MCP endpoint (issue #3775, Phase 2). MCP is
   JSON-RPC over HTTP POST, which stock Varnish passes uncached, so this is the
   only response cache we control (see {!Rate_limiter} for how this Varnish
   bypass forces caching in-app but does *not* likewise force rate limiting).

   A thin specialisation of the shared {!Bounded_cache} (bounded FIFO + TTL) at
   Yojson values, keyed on a canonical [(method, params)] string. The no-op
   [ping] tool is not cacheable, so Phase 2 registers no entries; the substrate
   is here for Blocks A/B to opt deterministic tools into. All access is
   synchronous under cooperative Lwt scheduling, so the cache needs no lock. *)

type t = Yojson.Safe.t Bounded_cache.t

let create = Bounded_cache.create
let find = Bounded_cache.find
let store = Bounded_cache.store
let find_or_compute = Bounded_cache.find_or_compute
