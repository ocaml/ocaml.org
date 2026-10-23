(** A bounded, FIFO-evicting, TTL cache keyed on strings.

    The clock is injected as [~now] (seconds, as from {!Unix.gettimeofday})
    rather than read internally, so callers control time and tests stay
    deterministic. The cache holds at most [max_entries]; once full, inserting a
    new key evicts the oldest-inserted one (FIFO, not LRU). An entry older than
    [ttl] reads as a miss.

    Not thread-safe: intended for use under cooperative Lwt scheduling, where
    access between a read and the following mutation is synchronous, so the
    underlying {!Hashtbl} and {!Queue} need no lock. *)

type 'a t

val create : max_entries:int -> ttl:float -> 'a t
(** [create ~max_entries ~ttl] is an empty cache capped at [max_entries] live
    entries, each valid for [ttl] seconds. *)

val find : 'a t -> now:float -> key:string -> 'a option
(** [find t ~now ~key] is the cached value for [key] if present and stored less
    than [ttl] seconds before [now], else [None]. *)

val store : 'a t -> now:float -> key:string -> 'a -> unit
(** [store t ~now ~key value] caches [value] under [key], stamped at [now],
    evicting the oldest entry first if the cache is at capacity. Re-storing an
    existing key refreshes its value and timestamp without changing its eviction
    position. *)

val find_or_compute : 'a t -> now:float -> key:string -> (unit -> 'a) -> 'a
(** [find_or_compute t ~now ~key compute] returns the cached value for [key], or
    runs [compute ()], stores it under [key], and returns it. For a fallible or
    asynchronous computation, use {!find} and {!store} directly so the caller
    can decide whether a given result is worth caching. *)
