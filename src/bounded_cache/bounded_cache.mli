(** A bounded, FIFO-evicting, TTL cache keyed on strings.

    The clock is injected as [~now] (seconds, as from {!Unix.gettimeofday})
    rather than read internally, so callers control time and tests stay
    deterministic. The cache is bounded both by an entry count and by a byte
    budget: it holds at most [max_entries] entries totalling at most [max_bytes]
    bytes (as measured by [sizer]); once either bound is exceeded, the
    oldest-inserted entries are evicted until the cache is back under both
    (FIFO, not LRU). An entry past its expiry reads as a miss.

    The byte budget exists because entry size is often caller-selectable while
    the entry count is capped, so a count-only cap can bound memory far more
    weakly than it suggests (see ocaml/ocaml.org#3889). [sizer] only needs to
    approximate an entry's retained size — it is an eviction heuristic, not an
    accounting invariant.

    Not thread-safe: intended for use under cooperative Lwt scheduling, where
    access between a read and the following mutation is synchronous, so the
    underlying {!Hashtbl} and {!Queue} need no lock. *)

type 'a t

val create :
  max_entries:int -> max_bytes:int -> sizer:('a -> int) -> ttl:float -> 'a t
(** [create ~max_entries ~max_bytes ~sizer ~ttl] is an empty cache capped at
    [max_entries] live entries and [max_bytes] total bytes, each entry valid for
    [ttl] seconds. Each entry's approximate size is measured once, at {!store}
    time, by [sizer]. *)

val find : 'a t -> now:float -> key:string -> 'a option
(** [find t ~now ~key] is the cached value for [key] if present and not yet
    expired at [now], else [None]. *)

val store : ?ttl:float -> 'a t -> now:float -> key:string -> 'a -> unit
(** [store t ~now ~key value] caches [value] under [key], expiring [ttl] seconds
    after [now] ([?ttl] overrides the cache-wide default for this entry, e.g. to
    negative-cache a miss for a shorter duration), then evicts oldest entries
    until the cache is under both the entry cap and the byte budget. The
    just-stored entry is evicted last, so a single value larger than [max_bytes]
    empties the cache and is itself dropped (the cache never retains more than
    [max_bytes]). An expired entry's bytes stay accounted until it is evicted in
    FIFO turn. Re-storing an existing key refreshes its value, expiry, and
    accounted size without changing its eviction position. *)

val find_or_compute : 'a t -> now:float -> key:string -> (unit -> 'a) -> 'a
(** [find_or_compute t ~now ~key compute] returns the cached value for [key], or
    runs [compute ()], stores it under [key], and returns it. For a fallible or
    asynchronous computation, use {!find} and {!store} directly so the caller
    can decide whether a given result is worth caching. *)
